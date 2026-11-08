extends TestCase
## Walking on a world map, end to end: biomes, the sea, and the camera.
##
## Real server, real client, real ticks, on [method RoomFixtures.small_world]: 50 × 30
## tiles, sea on the left edge, plains, then forest from column 30 on.

const LEFT := 3
const RIGHT := 5

static var _next_port := 19_077

var _port := 0
var _nodes: Array[Node] = []


func before_each() -> void:
	_port = _next_port
	_next_port += 1


func after_each() -> void:
	for node in _nodes:
		node.queue_free()
	_nodes.clear()
	await (Engine.get_main_loop() as SceneTree).process_frame


func test_the_wizard_starts_on_the_plains() -> void:
	var server := _start_server()
	var client := await _join()
	assert_eq(client.world.current_biome(), Biome.Kind.PLAINS)
	assert_eq(server.world.wizard_biome(client.peer_id()), Biome.Kind.PLAINS)
	assert_eq(client.world.location_name(), "Plains")


func test_walking_east_enters_the_forest_on_both_sides() -> void:
	var server := _start_server()
	var client := await _join()
	var hud := Hud.new(client.world)
	_add(hud)
	client.world.input_override = RIGHT
	assert_true(await wait_until(_client_in_biome.bind(client, Biome.Kind.FOREST), 8.0))
	assert_true(await wait_until(_server_in_biome.bind(server, client, Biome.Kind.FOREST)))
	assert_true(await wait_until(_location_reads.bind(hud, "Forest")), hud.location.text)


func test_the_sea_stops_the_wizard_on_both_sides() -> void:
	var server := _start_server()
	var client := await _join()
	client.world.input_override = LEFT
	var shore := Vector2(32.0 + Movement.FEET_SIZE.x / 2.0, 248.0)
	assert_true(await wait_until(_server_has_wizard_at.bind(server, client, shore), 5.0))
	client.world.input_override = Movement.IDLE
	assert_true(await wait_until(_client_sees_itself_at.bind(client, shore)))


func test_the_camera_follows_the_wizard_but_never_shows_past_the_map() -> void:
	_start_server()
	var client := await _join()
	await _ticks(2)
	# At tile 10 the wizard is too near the west edge: the camera rests against it.
	assert_eq(client.world.camera_center().x, 320.0)
	client.world.input_override = RIGHT
	# Past 320 the camera can follow; past 480 it would rest against the east edge.
	assert_true(await wait_until(_wizard_beyond.bind(client, 400.0), 6.0))
	client.world.input_override = Movement.IDLE
	await _ticks(2)
	var gap := absf(client.world.camera_center().x - client.world.own_position().x)
	assert_true(
		gap < 2.0,
		"camera %s, wizard %s" % [client.world.camera_center(), client.world.own_position()],
	)


func _start_server() -> GameServer:
	var server := GameServer.new()
	server.world.rooms = { &"world": RoomFixtures.small_world() }
	server.world.start_room = &"world"
	_add(server)
	assert_eq(server.start(_port), OK)
	return server


func _join() -> GameClient:
	var client := GameClient.new()
	client.world.rooms = { &"world": RoomFixtures.small_world() }
	client.world.input_override = Movement.IDLE
	_add(client)
	assert_eq(client.join("127.0.0.1", _port), OK)
	assert_true(await wait_until(_client_in_room.bind(client)))
	return client


func _ticks(count: int) -> void:
	for i in count:
		await (Engine.get_main_loop() as SceneTree).process_frame


func _client_in_room(client: GameClient) -> bool:
	return client.world.room != null


func _client_in_biome(client: GameClient, biome: int) -> bool:
	return client.world.current_biome() == biome


func _server_in_biome(server: GameServer, client: GameClient, biome: int) -> bool:
	return server.world.wizard_biome(client.peer_id()) == biome


func _location_reads(hud: Hud, text: String) -> bool:
	return hud.location.text == text


func _server_has_wizard_at(server: GameServer, client: GameClient, spot: Vector2) -> bool:
	return server.world.wizard_position(client.peer_id()) == spot


func _client_sees_itself_at(client: GameClient, spot: Vector2) -> bool:
	return client.world.own_position() == spot


func _wizard_beyond(client: GameClient, x: float) -> bool:
	return client.world.own_position().x > x


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)
