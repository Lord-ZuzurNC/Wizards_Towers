extends TestCase
## Editing a Grimoire position's spell over the network (GLOSSARY.md, spell editing).
##
## Real server, real client, real ticks, in the [code]left[/code] room of [RoomFixtures].
## Where the editing wizard stands is not checked yet: that waits on territory, Milestone 4
## (see `server_world.gd`, `_on_edit_spell_requested`).

static var _next_port := 19_377

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


func test_a_known_rune_in_the_right_slot_is_accepted() -> void:
	var server := _start_server()
	var client := await _join()
	_edit(client, 2, Spell.Slot.SHAPE, &"lance", Rarity.COMMON)
	assert_true(
		await wait_until(_server_rune_is.bind(server, client, 2, Spell.Slot.SHAPE, &"lance"))
	)


func test_a_rune_in_the_wrong_slot_is_refused() -> void:
	var server := _start_server()
	var client := await _join()
	_edit(client, 2, Spell.Slot.SHAPE, &"ember", Rarity.COMMON)
	await _ticks(10)
	assert_eq(server.world.wizard(client.peer_id()).grimoire[1].rune_id(Spell.Slot.SHAPE), &"")


func test_a_grade_not_yet_known_is_refused() -> void:
	var server := _start_server()
	var client := await _join()
	_edit(client, 2, Spell.Slot.ELEMENT, &"ember", Rarity.LEGENDARY)
	await _ticks(10)
	assert_eq(server.world.wizard(client.peer_id()).grimoire[1].rune_id(Spell.Slot.ELEMENT), &"")


func test_an_unknown_rune_id_is_refused() -> void:
	var server := _start_server()
	var client := await _join()
	_edit(client, 2, Spell.Slot.SHAPE, &"not_a_rune", Rarity.COMMON)
	await _ticks(10)
	assert_eq(server.world.wizard(client.peer_id()).grimoire[1].rune_id(Spell.Slot.SHAPE), &"")


func test_a_locked_grimoire_position_is_refused() -> void:
	var values := PlaceholderValues.new()
	values.open_every_grimoire_position = false
	var server := _start_server(values)
	var client := await _join()
	_edit(client, 2, Spell.Slot.SHAPE, &"lance", Rarity.COMMON)
	await _ticks(10)
	assert_eq(server.world.wizard(client.peer_id()).grimoire[1].rune_id(Spell.Slot.SHAPE), &"")


func test_an_accepted_edit_lets_the_edited_spell_be_cast() -> void:
	var server := _start_server()
	var client := await _join()
	rooms_with_dummy(server)
	_edit(client, 2, Spell.Slot.SHAPE, &"bolt", Rarity.COMMON)
	_edit(client, 2, Spell.Slot.ELEMENT, &"ember", Rarity.COMMON)
	_edit(client, 2, Spell.Slot.DURATION, &"instant", Rarity.COMMON)
	assert_true(
		await wait_until(_server_rune_is.bind(server, client, 2, Spell.Slot.DURATION, &"instant"))
	)
	client.world.cast(2, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 20)))


func rooms_with_dummy(server: GameServer) -> void:
	for room: RoomData in server.world.rooms.values():
		room.dummy_tiles = [Vector2i(6, 1)]


func _edit(client: GameClient, position: int, slot: int, rune_id: StringName, grade: int) -> void:
	var channel := client.get_node("Channel") as WorldChannel
	channel.send_edit_spell(position, slot, rune_id, grade)


func _start_server(values := PlaceholderValues.new()) -> GameServer:
	var rooms := RoomFixtures.two_joined_rooms()
	rooms[&"left"].dummy_tiles = [Vector2i(6, 1)]
	var server := GameServer.new()
	server.world.rooms = rooms
	server.world.start_room = &"left"
	server.world.values = values
	_add(server)
	assert_eq(server.start(_port), OK)
	return server


func _join() -> GameClient:
	var client := GameClient.new()
	client.world.rooms = RoomFixtures.two_joined_rooms()
	client.world.input_override = Movement.IDLE
	_add(client)
	assert_eq(client.join("127.0.0.1", _port), OK)
	assert_true(await wait_until(_client_in_room.bind(client)))
	return client


func _ticks(count: int) -> void:
	for i in count:
		await (Engine.get_main_loop() as SceneTree).physics_frame


func _client_in_room(client: GameClient) -> bool:
	return client.world.room != null


func _server_rune_is(
	server: GameServer,
	client: GameClient,
	position: int,
	slot: int,
	rune_id: StringName,
) -> bool:
	return server.world.wizard(client.peer_id()).grimoire[position - 1].rune_id(slot) == rune_id


func _dummy_health_is(server: GameServer, health: int) -> bool:
	return server.world.dummies_in(&"left")[0].health == health


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)
