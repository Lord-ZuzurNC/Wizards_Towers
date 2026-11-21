extends TestCase
## A dead wizard's player starting again, as a newcomer in the same world.
##
## Real server, real clients, real ticks, set up as in `test_wizard_death.gd`: the run starts
## in the [code]left[/code] room of [RoomFixtures], and a test lets the rift bank of
## [method RoomFixtures.seasonal_world] finish the wizard off in summer.

const SEASON := 10_000
const RIFT_BANK := Vector2i(11, 2)
const SPAWN := Vector2i(4, 1)

static var _next_port := 19_577

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


func test_a_living_wizard_s_request_to_start_again_is_ignored() -> void:
	var server := _start_server()
	var client := await _join()
	var wizard := server.world.wizard(client.peer_id())
	wizard.gain_xp(3 * _values.xp_per_level, _values.xp_per_level)
	client.world.respawn()
	await _ticks(10)
	assert_true(server.world.wizard(client.peer_id()) == wizard)
	assert_eq(wizard.wizard_level, 4)


func test_a_dead_wizard_starts_again_at_level_1_on_the_spawn_with_full_health() -> void:
	var server := _start_server()
	var client := await _join()
	var dead := server.world.wizard(client.peer_id())
	dead.gain_xp(3 * _values.xp_per_level, _values.xp_per_level)
	dead.grimoire[1].set_rune(Spell.Slot.SHAPE, &"lance")
	await _die(server, client)
	var inputs := dead.inputs
	client.world.respawn()
	assert_true(await wait_until(_alive.bind(server, client)))
	var fresh := server.world.wizard(client.peer_id())
	assert_true(fresh != dead)
	assert_eq(fresh.wizard_level, 1)
	assert_eq(fresh.health, Levels.health(1))
	assert_eq(fresh.ending, -1)
	assert_true(fresh.peace_shield_active)
	assert_eq(fresh.grimoire[1].rune_id(Spell.Slot.SHAPE), &"")
	assert_eq(fresh.room_id, &"left")
	assert_eq(fresh.position, server.world.rooms[&"left"].tile_center(SPAWN))
	# The same input stream: the client goes on numbering its inputs where it was.
	assert_true(fresh.inputs == inputs)
	assert_true(await wait_until(_client_alive.bind(client)))


func test_starting_again_leaves_the_world_and_the_other_wizards_alone() -> void:
	var server := _start_server()
	var client := await _join()
	var other := await _join()
	var other_wizard := server.world.wizard(other.peer_id())
	var watcher := EndingWatcher.new()
	client.world.run_ended.connect(watcher.on_run_ended)
	other.world.run_ended.connect(watcher.on_run_ended)
	await _die(server, client)
	var run_start := server.world.run_start_tick
	var map := server.world.rooms[&"world"]
	client.world.respawn()
	assert_true(await wait_until(_alive.bind(server, client)))
	assert_true(server.world.wizard(other.peer_id()) == other_wizard)
	assert_false(other_wizard.is_dead)
	assert_eq(server.world.run_start_tick, run_start)
	assert_true(server.world.rooms[&"world"] == map)
	await _ticks(5)
	assert_true(watcher.endings.is_empty(), str(watcher.endings))


func test_the_dead_wizard_s_villages_go_back_to_no_one() -> void:
	var server := _start_server()
	var client := await _join()
	var village: VillageState = server.world.villages_in(&"left")[0]
	village.owner_peer_id = client.peer_id()
	await _die(server, client)
	client.world.respawn()
	assert_true(await wait_until(_alive.bind(server, client)))
	assert_eq(village.owner_peer_id, 0)
	assert_eq(server.world.villages_held(client.peer_id()), 0)


## Lets the rift bank finish off the client's wizard, from 1 health, in summer.
func _die(server: GameServer, client: GameClient) -> void:
	server.world.run_start_tick = server.world.tick - Season.Kind.SUMMER * SEASON - 1
	var wizard := server.world.wizard(client.peer_id())
	wizard.health = 1
	wizard.room_id = &"world"
	wizard.position = server.world.rooms[&"world"].tile_center(RIFT_BANK)
	assert_true(await wait_until(_client_dead.bind(client)))


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


func _alive(server: GameServer, client: GameClient) -> bool:
	return not server.world.wizard(client.peer_id()).is_dead


func _client_dead(client: GameClient) -> bool:
	return client.world.status.is_dead


func _client_alive(client: GameClient) -> bool:
	return not client.world.status.is_dead and client.world.status.wizard_level == 1


func _client_in_room(client: GameClient, room_id: StringName) -> bool:
	return client.world.room != null and client.world.room.id == room_id


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)


## Records the ends of runs, through a named method rather than a lambda.
class EndingWatcher:
	extends RefCounted

	var endings: Array[int] = []


	func on_run_ended(kind: int) -> void:
		endings.append(kind)
