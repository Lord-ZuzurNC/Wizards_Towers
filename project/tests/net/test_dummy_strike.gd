extends TestCase
## The training dummy's provisional strike, end to end: a testing aid that makes the peace
## shield's effect visible, not a hostile dummy.
##
## Real server, real client, real ticks. The run starts on tile (4, 1) of the
## [code]left[/code] room of [RoomFixtures]; each test stands one dummy in it, next to the
## wizard or [constant FAR] tiles away. Hits come on the hazards' beat,
## [constant Hazard.INTERVAL_TICKS].

const NEXT_TO := Vector2i(5, 1)
const FAR := Vector2i(1, 1)
const BEATS := 4

static var _next_port := 19_677

var _port := 0
var _nodes: Array[Node] = []
var _values: PlaceholderValues


func before_each() -> void:
	_port = _next_port
	_next_port += 1
	_values = PlaceholderValues.new()


func after_each() -> void:
	for node in _nodes:
		node.queue_free()
	_nodes.clear()
	await (Engine.get_main_loop() as SceneTree).process_frame


func test_a_shielded_wizard_next_to_a_dummy_takes_nothing() -> void:
	var server := _start_server(NEXT_TO)
	var client := await _join()
	var wizard := server.world.wizard(client.peer_id())
	assert_true(wizard.peace_shield_active)
	await _ticks(Hazard.INTERVAL_TICKS * BEATS)
	assert_eq(wizard.health, Levels.health(1))
	assert_true(wizard.peace_shield_active)


func test_an_unshielded_wizard_next_to_a_dummy_is_struck_on_every_beat() -> void:
	var server := _start_server(NEXT_TO)
	var client := await _join()
	var wizard := server.world.wizard(client.peer_id())
	wizard.break_peace_shield()
	var dealt := Damage.dealt(_values.dummy_strike_raw_damage, Levels.magic_defence(1))
	var expected := Levels.health(1)
	for beat in 3:
		expected -= dealt
		assert_true(await wait_until(_health_is.bind(wizard, expected)), "beat %d" % beat)


func test_a_wizard_out_of_range_takes_nothing_shielded_or_not() -> void:
	for shielded: bool in [true, false]:
		_port = _next_port
		_next_port += 1
		var server := _start_server(FAR)
		var client := await _join()
		var wizard := server.world.wizard(client.peer_id())
		if not shielded:
			wizard.break_peace_shield()
		await _ticks(Hazard.INTERVAL_TICKS * BEATS)
		assert_eq(wizard.health, Levels.health(1), "shielded: %s" % shielded)


func _start_server(dummy_tile: Vector2i) -> GameServer:
	var server := GameServer.new()
	server.world.rooms = _rooms(dummy_tile)
	server.world.start_room = &"left"
	server.world.values = _values
	_add(server)
	assert_eq(server.start(_port), OK)
	return server


func _join() -> GameClient:
	var client := GameClient.new()
	client.world.rooms = RoomFixtures.two_joined_rooms()
	client.world.values = _values
	client.world.input_override = Movement.IDLE
	_add(client)
	assert_eq(client.join("127.0.0.1", _port), OK)
	assert_true(await wait_until(_client_in_room.bind(client)))
	return client


func _rooms(dummy_tile: Vector2i) -> Dictionary[StringName, RoomData]:
	var rooms := RoomFixtures.two_joined_rooms()
	rooms[&"left"].dummy_tiles = [dummy_tile]
	return rooms


func _ticks(count: int) -> void:
	for i in count:
		await (Engine.get_main_loop() as SceneTree).physics_frame


func _health_is(wizard: WizardState, health: int) -> bool:
	return wizard.health == health


func _client_in_room(client: GameClient) -> bool:
	return client.world.room != null


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)
