extends TestCase
## A wizard walking: predicted by its client, decided by the server, seen by others.
##
## Real server, real clients, real ticks, on the two small rooms of [RoomFixtures]:
## [code]left[/code] has its spawn at tile (4, 1), a wall at its left end and a door at its
## right end into [code]right[/code].

const LEFT := 3 # Movement.encode(Vector2i.LEFT)
const RIGHT := 5 # Movement.encode(Vector2i.RIGHT)

static var _next_port := 18_777

var _port := 0
var _nodes: Array[Node] = []


func before_each() -> void:
	_port = _next_port
	_next_port += 1


func after_each() -> void:
	for node in _nodes:
		node.queue_free()
	await (Engine.get_main_loop() as SceneTree).process_frame


func test_a_new_wizard_appears_on_the_spawn_tile() -> void:
	var server := _start_server()
	var client := _join()
	assert_true(await wait_until(_client_in_room.bind(client, &"left")))
	var spawn := server.world.rooms[&"left"].tile_center(Vector2i(4, 1))
	assert_eq(client.world.own_position(), spawn)
	assert_eq(server.world.wizard_position(client.peer_id()), spawn)


func test_walking_moves_the_wizard_on_the_server_and_the_prediction_agrees() -> void:
	var server := _start_server()
	var client := _join()
	assert_true(await wait_until(_client_in_room.bind(client, &"left")))
	client.world.input_override = LEFT
	# The wall ends at x = 16; the feet stop half their width after it.
	var stop := Vector2(16.0 + Movement.FEET_SIZE.x / 2.0, 24.0)
	assert_true(await wait_until(_server_has_wizard_at.bind(server, client, stop)))
	client.world.input_override = Movement.IDLE
	assert_true(await wait_until(_client_sees_itself_at.bind(client, stop)))


func test_walking_through_the_door_changes_room_on_both_sides() -> void:
	var server := _start_server()
	var client := _join()
	assert_true(await wait_until(_client_in_room.bind(client, &"left")))
	client.world.input_override = RIGHT
	assert_true(await wait_until(_client_in_room.bind(client, &"right")))
	assert_eq(server.world.wizard_room(client.peer_id()), &"right")


func test_two_wizards_in_one_room_see_each_other() -> void:
	_start_server()
	var first := _join()
	var second := _join()
	assert_true(await wait_until(_client_sees.bind(first, second)))
	assert_true(await wait_until(_client_sees.bind(second, first)))


func test_a_wizard_leaving_the_room_vanishes_for_the_others() -> void:
	_start_server()
	var walker := _join()
	var watcher := _join()
	assert_true(await wait_until(_client_sees.bind(watcher, walker)))
	walker.world.input_override = RIGHT
	assert_true(await wait_until(_client_in_room.bind(walker, &"right")))
	assert_true(await wait_until(_client_does_not_see.bind(watcher, walker)))


func _start_server() -> GameServer:
	var server := GameServer.new()
	server.world.rooms = RoomFixtures.two_joined_rooms()
	server.world.start_room = &"left"
	_add(server)
	assert_eq(server.start(_port), OK)
	return server


func _join() -> GameClient:
	var client := GameClient.new()
	client.world.rooms = RoomFixtures.two_joined_rooms()
	client.world.input_override = Movement.IDLE
	_add(client)
	assert_eq(client.join("127.0.0.1", _port), OK)
	return client


func _client_in_room(client: GameClient, room_id: StringName) -> bool:
	return client.world.room != null and client.world.room.id == room_id


func _server_has_wizard_at(server: GameServer, client: GameClient, spot: Vector2) -> bool:
	var peer_id := client.peer_id()
	return server.world.has_wizard(peer_id) and server.world.wizard_position(peer_id) == spot


func _client_sees_itself_at(client: GameClient, spot: Vector2) -> bool:
	return client.world.own_position() == spot


func _client_sees(client: GameClient, other: GameClient) -> bool:
	return client.world.other_peer_ids().has(other.peer_id())


func _client_does_not_see(client: GameClient, other: GameClient) -> bool:
	return not _client_sees(client, other)


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)
