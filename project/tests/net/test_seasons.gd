extends TestCase
## Seasons, hazards and the end of a run, end to end.
##
## Real server, real client, real ticks. The run starts in the [code]left[/code] room of
## [RoomFixtures]; [method RoomFixtures.seasonal_world] is there too, as [code]world[/code],
## and tests put the wizard on it. Seasons last [constant SEASON] ticks; a test jumps to the
## season it needs by moving the start of the run back.

const SEASON := 10_000
const RIGHT := 5

static var _next_port := 19_177

var _port := 0
var _nodes: Array[Node] = []
var _values: PlaceholderValues


func before_each() -> void:
	_port = _next_port
	_next_port += 1
	_values = PlaceholderValues.new()
	_values.season_ticks = SEASON


func after_each() -> void:
	for node in _nodes:
		node.queue_free()
	_nodes.clear()
	await (Engine.get_main_loop() as SceneTree).process_frame


func test_a_world_waits_for_its_server_to_start() -> void:
	var server := GameServer.new()
	server.world.rooms = _rooms()
	server.world.start_room = &"left"
	server.world.values = _values
	_add(server)
	await _ticks(3)
	assert_eq(server.world.tick, 0)
	assert_eq(server.start(_port), OK)
	await _ticks(3)
	assert_true(server.world.tick > 0)


func test_a_run_starts_in_spring_and_the_client_counts_down() -> void:
	_start_server()
	var client := await _join()
	assert_eq(client.world.status.season, Season.Kind.SPRING)
	var first := client.world.status.season_ticks_left
	await _ticks(5)
	assert_true(client.world.status.season_ticks_left < first)


func test_the_seasons_follow_one_another() -> void:
	var server := _start_server()
	var client := await _join()
	for kind: int in [Season.Kind.SUMMER, Season.Kind.AUTUMN, Season.Kind.WINTER]:
		_jump_to(server, kind)
		assert_true(await wait_until(_client_in_season.bind(client, kind)), Season.label(kind))


func test_when_winter_runs_out_every_wizard_starts_a_new_run() -> void:
	var server := _start_server()
	var client := await _join()
	var watcher := RunEndWatcher.new()
	client.world.run_ended.connect(watcher.on_run_ended)
	var wizard := server.world.wizard(client.peer_id())
	wizard.wizard_level = 3
	wizard.gold = 50
	server.world.villages_in(&"left")[0].owner_peer_id = client.peer_id()
	_put(server, client, &"world", Vector2i(15, 2))
	assert_true(await wait_until(_client_in_room.bind(client, &"world")))
	# Five ticks before the end of winter.
	server.world.run_start_tick = server.world.tick - Season.COUNT * SEASON + 5
	assert_true(await wait_until(watcher.has_ended))
	assert_eq(watcher.ending, WorldEnding.Kind.WORLD_COLLAPSE)
	assert_true(await wait_until(_client_in_room.bind(client, &"left")))
	var newcomer := server.world.wizard(client.peer_id())
	assert_eq(newcomer.wizard_level, 1)
	assert_eq(newcomer.gold, _values.starting_gold)
	assert_eq(newcomer.position, server.world.rooms[&"left"].tile_center(Vector2i(4, 1)))
	assert_eq(server.world.villages_in(&"left")[0].owner_peer_id, 0)
	assert_eq(server.world.season, Season.Kind.SPRING)
	assert_true(await wait_until(_client_in_season.bind(client, Season.Kind.SPRING)))
	assert_true(await wait_until(_client_sees_level.bind(client, 1)))


func test_after_a_new_run_the_wizard_still_walks() -> void:
	var server := _start_server()
	var client := await _join()
	var watcher := RunEndWatcher.new()
	client.world.run_ended.connect(watcher.on_run_ended)
	server.world.run_start_tick = server.world.tick - Season.COUNT * SEASON + 3
	assert_true(await wait_until(watcher.has_ended))
	await _ticks(3)
	var start := server.world.wizard_position(client.peer_id())
	client.world.input_override = RIGHT
	assert_true(await wait_until(_server_moved_from.bind(server, client, start)))


func test_a_rift_bank_burns_in_summer_and_the_burn_outlasts_it() -> void:
	var server := _start_server()
	var client := await _join()
	_jump_to(server, Season.Kind.SUMMER)
	_put(server, client, &"world", Vector2i(11, 2))
	assert_true(await wait_until(_client_affected.bind(client, StateUpdate.BURNING)))
	var wizard := server.world.wizard(client.peer_id())
	assert_true(await wait_until(_health_below.bind(server, client, 98)))
	# Off the bank: the burn goes on hurting for a while, then stops.
	_put(server, client, &"world", Vector2i(5, 2))
	var off_at := wizard.health
	assert_true(await wait_until(_health_below.bind(server, client, off_at)))
	assert_true(await wait_until(_client_not_affected.bind(client, StateUpdate.BURNING), 4.0))
	var after := wizard.health
	await _ticks(Hazard.INTERVAL_TICKS * 3)
	assert_eq(wizard.health, after)


func test_a_rift_bank_is_harmless_out_of_summer() -> void:
	var server := _start_server()
	var client := await _join()
	_put(server, client, &"world", Vector2i(11, 2))
	await _ticks(Hazard.INTERVAL_TICKS * 3)
	assert_eq(server.world.wizard(client.peer_id()).health, 100)


func test_the_glacier_slows_in_winter_and_the_client_predicts_with_it() -> void:
	var server := _start_server()
	var client := await _join()
	_jump_to(server, Season.Kind.WINTER)
	_put(server, client, &"world", Vector2i(22, 2))
	assert_true(await wait_until(_client_affected.bind(client, StateUpdate.SLOWED)))
	var slowed := roundi(Simulation.BASE_SPEED * (1.0 - _values.slow_share))
	assert_eq(server.world.wizard(client.peer_id()).speed, slowed)
	assert_eq(client.world.status.speed, slowed)
	assert_eq(client.world.predicted_speed(), slowed)
	assert_true(server.world.wizard(client.peer_id()).health < 100)


func test_the_frozen_sea_is_walked_on_in_winter() -> void:
	var server := _start_server()
	var client := await _join()
	_jump_to(server, Season.Kind.WINTER)
	_put(server, client, &"world", Vector2i(2, 2))
	assert_true(await wait_until(_client_in_season.bind(client, Season.Kind.WINTER)))
	client.world.input_override = 3
	assert_true(await wait_until(_server_x_below.bind(server, client, 30.0), 3.0))
	var on_ice := server.world.wizard_position(client.peer_id())
	var world := server.world.rooms[&"world"] as WorldMapData
	assert_true(world.is_frozen_water(world.tile_at(on_ice)))


func test_the_hud_shows_the_season_and_the_end_of_a_run() -> void:
	var server := _start_server()
	var client := await _join()
	var hud := Hud.new(client.world)
	_add(hud)
	assert_true(await wait_until(_season_reads.bind(hud, "Spring 5:3")), hud.season.text)
	server.world.run_start_tick = server.world.tick - Season.COUNT * SEASON + 3
	assert_true(await wait_until(hud.ending.is_visible))
	assert_true(hud.ending.text.begins_with("World Collapse"), hud.ending.text)


## Moves the start of the run back so the next tick falls in [param kind].
func _jump_to(server: GameServer, kind: int) -> void:
	server.world.run_start_tick = server.world.tick - kind * SEASON - 1


## Puts the client's wizard on [param tile] of [param room_id], as the server decides.
func _put(server: GameServer, client: GameClient, room_id: StringName, tile: Vector2i) -> void:
	var wizard := server.world.wizard(client.peer_id())
	wizard.room_id = room_id
	wizard.position = server.world.rooms[room_id].tile_center(tile)


func _start_server() -> GameServer:
	var server := GameServer.new()
	server.world.rooms = _rooms()
	server.world.start_room = &"left"
	server.world.values = _values
	_add(server)
	assert_eq(server.start(_port), OK)
	return server


func _join() -> GameClient:
	var client := GameClient.new()
	client.world.rooms = _rooms()
	client.world.values = _values
	client.world.input_override = Movement.IDLE
	_add(client)
	assert_eq(client.join("127.0.0.1", _port), OK)
	assert_true(await wait_until(_client_in_room.bind(client, &"left")))
	return client


func _rooms() -> Dictionary[StringName, RoomData]:
	var rooms := RoomFixtures.two_joined_rooms()
	var near := VillageSite.new()
	near.title = "Near"
	near.tile = Vector2i(5, 1)
	rooms[&"left"].villages = [near]
	rooms[&"world"] = RoomFixtures.seasonal_world()
	return rooms


func _ticks(count: int) -> void:
	for i in count:
		await (Engine.get_main_loop() as SceneTree).physics_frame


func _client_in_room(client: GameClient, room_id: StringName) -> bool:
	return client.world.room != null and client.world.room.id == room_id


func _client_in_season(client: GameClient, kind: int) -> bool:
	return client.world.status.season == kind


func _client_sees_level(client: GameClient, level: int) -> bool:
	return client.world.status.wizard_level == level


func _client_affected(client: GameClient, effect: int) -> bool:
	return client.world.status.effects & effect != 0


func _client_not_affected(client: GameClient, effect: int) -> bool:
	return client.world.status.effects & effect == 0


func _health_below(server: GameServer, client: GameClient, health: int) -> bool:
	return server.world.wizard(client.peer_id()).health < health


func _server_moved_from(server: GameServer, client: GameClient, start: Vector2) -> bool:
	return server.world.wizard_position(client.peer_id()) != start


func _server_x_below(server: GameServer, client: GameClient, x: float) -> bool:
	return server.world.wizard_position(client.peer_id()).x < x


func _season_reads(hud: Hud, prefix: String) -> bool:
	return hud.season.text.begins_with(prefix)


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)


## Records the end of a run, through a named method rather than a lambda.
class RunEndWatcher:
	extends RefCounted

	var ending := -1


	func on_run_ended(kind: int) -> void:
		ending = kind


	func has_ended() -> bool:
		return ending >= 0
