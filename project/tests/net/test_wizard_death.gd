extends TestCase
## The death of a wizard, end to end (GLOSSARY.md, Wizard endings).
##
## Real server, real client, real ticks. The run starts in the [code]left[/code] room of
## [RoomFixtures]; a test puts the wizard on the rift bank of
## [method RoomFixtures.seasonal_world], in summer, with little health left, and lets the
## hazard finish it. Hazard damage is the only lethal damage so far.

const SEASON := 10_000
const RIGHT := 5
const RIFT_BANK := Vector2i(11, 2)

static var _next_port := 19_477

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


func test_hazard_hits_bring_a_wizard_to_0_and_it_is_devoured_by_the_wilds() -> void:
	var server := _start_server()
	var client := await _join()
	var watcher := _watch(client)
	var wizard := server.world.wizard(client.peer_id())
	_burn(server, client, 3)
	# One point a hit, twice a second: three hits, so give it more than the default wait.
	assert_true(await wait_until(watcher.has_died, 4.0))
	assert_true(wizard.is_dead)
	assert_eq(wizard.health, 0)
	assert_eq(wizard.ending, WizardEnding.Kind.DEVOURED_WILDS as int)
	assert_eq(watcher.endings, [WizardEnding.Kind.DEVOURED_WILDS as int])


func test_a_dead_wizard_takes_no_more_damage_and_dies_once() -> void:
	var server := _start_server()
	var client := await _join()
	var watcher := _watch(client)
	var wizard := server.world.wizard(client.peer_id())
	_burn(server, client, 1)
	assert_true(await wait_until(watcher.has_died))
	var fell_at := wizard.position
	await _ticks(Hazard.INTERVAL_TICKS * 4)
	assert_eq(wizard.health, 0)
	assert_eq(watcher.endings.size(), 1)
	# It stays where it fell, in its room, for the others there to see.
	assert_eq(wizard.room_id, &"world")
	assert_eq(wizard.position, fell_at)


func test_a_dead_wizard_s_requests_are_ignored() -> void:
	var server := _start_server()
	var client := await _join()
	var watcher := _watch(client)
	var wizard := server.world.wizard(client.peer_id())
	_burn(server, client, 1)
	assert_true(await wait_until(watcher.has_died))
	var fell_at := wizard.position
	var mana := wizard.mana
	var applied := wizard.inputs.last_applied
	var channel := client.get_node("Channel") as WorldChannel
	client.world.input_override = RIGHT
	client.world.cast(1, Vector2.RIGHT)
	channel.send_buy_village(0, 0)
	channel.send_edit_spell(2, Spell.Slot.SHAPE, &"lance", Rarity.COMMON)
	await _ticks(20)
	assert_eq(wizard.position, fell_at)
	assert_eq(wizard.inputs.last_applied, applied)
	assert_eq(wizard.mana, mana)
	assert_eq(wizard.ready_ticks[0], 0)
	assert_eq(wizard.pending_purchase, -1)
	assert_eq(wizard.grimoire[1].rune_id(Spell.Slot.SHAPE), &"")


## Puts the client's wizard on the rift bank in summer with [param health] left.
func _burn(server: GameServer, client: GameClient, health: int) -> void:
	server.world.run_start_tick = server.world.tick - Season.Kind.SUMMER * SEASON - 1
	var wizard := server.world.wizard(client.peer_id())
	wizard.health = health
	wizard.room_id = &"world"
	wizard.position = server.world.rooms[&"world"].tile_center(RIFT_BANK)


func _watch(client: GameClient) -> DeathWatcher:
	var watcher := DeathWatcher.new()
	client.world.wizard_died.connect(watcher.on_wizard_died)
	return watcher


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


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)


## Records the wizard's deaths, through a named method rather than a lambda.
class DeathWatcher:
	extends RefCounted

	var endings: Array[int] = []


	func on_wizard_died(kind: int) -> void:
		endings.append(kind)


	func has_died() -> bool:
		return not endings.is_empty()
