extends TestCase
## Walking on a world map, end to end: biomes, the sea, and the camera.
##
## Real server, real client, real ticks, on [method RoomFixtures.small_world]: 70 × 30
## tiles, sea on the left edge, plains, then forest from column 30 on. 70 tiles (1120 px)
## is wide enough that [constant ClientWorld.WORLD_MAP_ZOOM] still leaves real room for the
## camera to move before it hits either edge — narrower, and the zoomed-out view would span
## the whole room and the camera would just sit centred, never following at all.

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
	# Half of what the zoomed-out camera shows, in world pixels either side of its centre.
	var half_extent := (ClientWorld.SCREEN.x / 2.0) / ClientWorld.WORLD_MAP_ZOOM.x
	await _ticks(2)
	# At tile 10 the wizard is too near the west edge: the camera rests against it.
	assert_true(
		absf(client.world.camera_center().x - half_extent) < 1.0,
		str(client.world.camera_center()),
	)
	client.world.input_override = RIGHT
	# Once the wizard is past half_extent the camera can follow it freely.
	assert_true(await wait_until(_wizard_beyond.bind(client, half_extent + 80.0), 8.0))
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


func test_a_newcomer_spawns_on_a_random_walkable_tile_not_always_the_same_one() -> void:
	var seen: Array[Vector2] = []
	for i in 5:
		var port := _next_port
		_next_port += 1
		var server := GameServer.new()
		var world := RoomFixtures.small_world()
		world.random_spawn = true
		server.world.rooms = { &"world": world }
		server.world.start_room = &"world"
		_add(server)
		assert_eq(server.start(port), OK)
		var client := GameClient.new()
		client.world.rooms = { &"world": RoomFixtures.small_world() }
		client.world.input_override = Movement.IDLE
		_add(client)
		assert_eq(client.join("127.0.0.1", port), OK)
		assert_true(await wait_until(_client_in_room.bind(client)))
		var position := server.world.wizard_position(client.peer_id())
		assert_false(world.is_solid(world.tile_at(position)), str(position))
		seen.append(position)
	var distinct := { }
	for p: Vector2 in seen:
		distinct[p] = true
	assert_true(distinct.size() > 1, "every spawn landed on the same tile: %s" % [seen])


func test_a_world_collapse_regrows_the_real_world_map() -> void:
	var values := PlaceholderValues.new()
	values.season_ticks = 10
	var server := GameServer.new()
	server.world.rooms = RoomCatalog.load_folder()
	server.world.start_room = &"world_map"
	server.world.values = values
	_add(server)
	assert_eq(server.start(_port), OK)
	await _ticks(1)
	var original_rows := (server.world.rooms[&"world_map"] as WorldMapData).rows
	var original_target := (server.world.rooms[&"dungeon_1_exit"] as RoomData).exits[0].target_tile
	# Five ticks before the end of winter (Season.COUNT seasons of `season_ticks` each).
	server.world.run_start_tick = server.world.tick - Season.COUNT * 10 + 5
	assert_true(
		await wait_until(
			func() -> bool:
				return (server.world.rooms[&"world_map"] as WorldMapData).rows != original_rows,
		)
	)
	var new_target := (server.world.rooms[&"dungeon_1_exit"] as RoomData).exits[0].target_tile
	assert_ne(new_target, original_target)
	var new_map := server.world.rooms[&"world_map"] as WorldMapData
	assert_false(new_map.is_solid(new_target))
	assert_true(new_map.random_spawn)
