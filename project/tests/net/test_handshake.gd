extends TestCase
## A real server and a real client, talking over ENet on this machine.
##
## Both live in this process, each on its own branch of the tree with its own
## [SceneMultiplayer]. Each test takes a fresh port, so a socket still closing from the
## previous test cannot get in the way.

static var _next_port := 17_777

var _port := 0
var _nodes: Array[Node] = []
## The holders of bare clients, whose multiplayer the test registered by hand.
var _raw_holders: Array[Node] = []


func before_each() -> void:
	_port = _next_port
	_next_port += 1


func after_each() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	for node in _raw_holders:
		tree.set_multiplayer(null, node.get_path())
	for node in _nodes:
		node.queue_free()
	await tree.process_frame


func test_a_client_with_the_same_version_starts_a_session() -> void:
	var server := _start_server()
	var client := _join()
	assert_true(await wait_until(_client_is.bind(client, GameClient.State.IN_SESSION)))
	assert_true(await wait_until(_server_has.bind(server, 1)))


func test_an_outdated_client_is_refused_and_told_why() -> void:
	var server := _start_server()
	var server_refusals := SignalWatcher.watch(server.session_refused)
	var client := _join(Protocol.VERSION - 1)
	var client_refusals := SignalWatcher.watch(client.session_refused)
	assert_true(await wait_until(_client_is.bind(client, GameClient.State.REFUSED)))
	assert_eq(client_refusals.count(), 1)
	var reason: String = client_refusals.arguments(0)[0]
	assert_true(reason.contains("version mismatch"), reason)
	assert_eq(server_refusals.count(), 1)
	assert_eq(server.session_count(), 0)


func test_a_malformed_hello_is_refused() -> void:
	var server := _start_server()
	var api := _raw_client(PackedByteArray([1, 2, 3]))
	var answers := SignalWatcher.new()
	api.auth_callback = answers.record
	assert_true(await wait_until(answers.was_emitted))
	var data: PackedByteArray = answers.arguments(0)[1]
	var message := Protocol.decode_answer(data)
	assert_true(message != null)
	if message != null:
		assert_eq(message.answer, Protocol.Answer.REFUSED_MALFORMED)
	assert_eq(server.session_count(), 0)


func test_a_refused_client_is_dropped_by_the_server() -> void:
	var server := _start_server()
	var api := _raw_client(Protocol.encode_hello(Protocol.VERSION + 1))
	var dropped := SignalWatcher.watch(api.peer_authentication_failed)
	var deadline := GameServer.REFUSAL_GRACE_SECONDS + 1.5
	assert_true(await wait_until(dropped.was_emitted, deadline))
	assert_eq(server.session_count(), 0)


func test_leaving_ends_the_session_on_the_server() -> void:
	var server := _start_server()
	var ended := SignalWatcher.watch(server.session_ended)
	var client := _join()
	assert_true(await wait_until(_server_has.bind(server, 1)))
	client.leave()
	assert_true(await wait_until(ended.was_emitted))
	assert_eq(server.session_count(), 0)


func _start_server() -> GameServer:
	var server := GameServer.new()
	_add(server)
	assert_eq(server.start(_port), OK)
	return server


func _join(version := Protocol.VERSION) -> GameClient:
	var client := GameClient.new()
	client.protocol_version = version
	_add(client)
	assert_eq(client.join("127.0.0.1", _port), OK)
	return client


## A bare client that sends [param hello] as is, to play one that does not follow the
## protocol. It ignores the server's answers unless the test sets its own
## [member SceneMultiplayer.auth_callback].
func _raw_client(hello: PackedByteArray) -> SceneMultiplayer:
	var holder := Node.new()
	_add(holder)
	_raw_holders.append(holder)
	var api := SceneMultiplayer.new()
	var peer := ENetMultiplayerPeer.new()
	assert_eq(peer.create_client("127.0.0.1", _port), OK)
	api.auth_callback = _ignore_auth_message
	api.peer_authenticating.connect(_send_raw_hello.bind(holder, hello))
	holder.get_tree().set_multiplayer(api, holder.get_path())
	api.multiplayer_peer = peer
	return api


## Reaches the API through the holder: binding the API itself into a callable connected
## to that API's own signal would form a cycle, and leak both at exit.
func _send_raw_hello(peer_id: int, holder: Node, hello: PackedByteArray) -> void:
	(holder.multiplayer as SceneMultiplayer).send_auth(peer_id, hello)


func _ignore_auth_message(_peer_id: int, _data: PackedByteArray) -> void:
	pass


func _client_is(client: GameClient, state: GameClient.State) -> bool:
	return client.state == state


func _server_has(server: GameServer, sessions: int) -> bool:
	return server.session_count() == sessions


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)
