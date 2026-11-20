extends TestCase
## A wizard casting at a training dummy, levelling up and taking a card, end to end.
##
## Real server, real client, real ticks, in the [code]left[/code] room of [RoomFixtures]
## with one dummy two tiles right of the spawn. Every wizard's Grimoire position 1 starts
## as Bolt + Ember + Instant, all common (RUNES.md): 4 mana, a 1-second cooldown, and 10
## raw damage, which deals 10 through the dummy's 10 magic_defence (FORMULAS.md) — three
## hits destroy its 30 health, for 10 XP, which is one level. Only Bolt's behaviour is
## built so far, so a test giving a position another Shape only exercises its numbers.

static var _next_port := 18_877

var _port := 0
var _nodes: Array[Node] = []
var _values: PlaceholderValues


func before_each() -> void:
	_port = _next_port
	_next_port += 1
	_values = PlaceholderValues.new()
	_values.dummy_respawn_ticks = 100_000


func after_each() -> void:
	for node in _nodes:
		node.queue_free()
	_nodes.clear()
	await (Engine.get_main_loop() as SceneTree).process_frame


func test_a_spell_cast_at_the_dummy_hurts_it_on_both_sides() -> void:
	var server := _start_server()
	var client := await _join()
	client.world.cast(1, Vector2.RIGHT)
	assert_true(await wait_until(_client_sees_dummy_health.bind(client, 20)))
	assert_eq(server.world.dummies_in(&"left")[0].health, 20)


func test_a_cast_costs_mana() -> void:
	var server := _start_server()
	var client := await _join()
	var before := server.world.wizard(client.peer_id()).mana
	client.world.cast(1, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 20)))
	# Mana comes back meanwhile, a little, so the cost shows as at least 3 of the 4.
	assert_true(server.world.wizard(client.peer_id()).mana <= before - 3)


func test_a_spell_cast_away_from_the_dummy_misses_it() -> void:
	var server := _start_server()
	var client := await _join()
	client.world.cast(1, Vector2.LEFT)
	await _ticks(20)
	assert_eq(server.world.dummies_in(&"left")[0].health, 30)


func test_without_the_mana_nothing_is_cast() -> void:
	var server := _start_server()
	var client := await _join()
	server.world.wizard(client.peer_id()).mana = 0
	client.world.cast(1, Vector2.RIGHT)
	await _ticks(20)
	assert_eq(server.world.dummies_in(&"left")[0].health, 30)


func test_the_cooldown_refuses_a_second_cast_too_soon() -> void:
	var server := _start_server()
	var client := await _join()
	client.world.cast(1, Vector2.RIGHT)
	client.world.cast(1, Vector2.RIGHT)
	await _ticks(20)
	# One second's cooldown has not elapsed in 20 ticks, so only the first cast landed.
	assert_eq(server.world.dummies_in(&"left")[0].health, 20)


func test_a_grimoire_position_out_of_range_casts_nothing() -> void:
	var server := _start_server()
	var client := await _join()
	var channel := client.get_node("Channel") as WorldChannel
	channel.send_cast(0, Vector2.RIGHT)
	channel.send_cast(11, Vector2.RIGHT)
	await _ticks(20)
	assert_eq(server.world.dummies_in(&"left")[0].health, 30)


func test_a_level_1_wizard_casts_from_its_one_position_only() -> void:
	_values.open_every_grimoire_position = false
	var server := _start_server()
	var client := await _join()
	client.world.cast(2, Vector2.RIGHT)
	await _ticks(20)
	assert_eq(server.world.dummies_in(&"left")[0].health, 30)
	client.world.cast(1, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 20)))


func test_an_empty_grimoire_position_casts_nothing() -> void:
	var server := _start_server()
	var client := await _join()
	client.world.cast(2, Vector2.RIGHT)
	await _ticks(20)
	assert_eq(server.world.dummies_in(&"left")[0].health, 30)


func test_each_position_casts_its_own_spell() -> void:
	var server := _start_server()
	var client := await _join()
	_set_spell(server, client, 6, &"bolt", &"stone", &"instant")
	client.world.cast(6, Vector2.RIGHT)
	# Stone's 16 magnitude at power 10, through a magic_defence of 10: 16 × 60 / 70 = 13.
	assert_true(await wait_until(_dummy_health_is.bind(server, 30 - 13)))


func test_each_position_cools_down_on_its_own() -> void:
	var server := _start_server()
	var client := await _join()
	_set_spell(server, client, 2, &"bolt", &"ember", &"instant")
	client.world.cast(1, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 20)))
	# Position 1 is cooling down; position 2, never cast yet, still lands.
	client.world.cast(1, Vector2.RIGHT)
	client.world.cast(2, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 10)))
	assert_true(await wait_until(_position_ready.bind(client, 0)))
	client.world.cast(1, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 0)))


func test_a_shift_click_casts_from_position_6_only() -> void:
	var server := _start_server()
	var client := await _join()
	# Position 6 costs 9 mana; position 1 would cost 4 more on top.
	_set_spell(server, client, 6, &"bolt", &"rust", &"delayed")
	# The keyboard and mouse, not the test's override: idle, since nothing is held.
	client.world.input_override = -1
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.shift_pressed = true
	Input.parse_input_event(click)
	Input.flush_buffered_events()
	var before := server.world.wizard(client.peer_id()).mana
	assert_true(await wait_until(_mana_at_most.bind(server, client, before - 1)))
	await _ticks(10)
	var mana := server.world.wizard(client.peer_id()).mana
	assert_true(mana > before - 9 - 4, "mana %d: position 1 was cast too" % mana)
	var release := click.duplicate() as InputEventMouseButton
	release.pressed = false
	Input.parse_input_event(release)
	Input.flush_buffered_events()


func test_a_projectile_says_which_position_cast_it() -> void:
	var server := _start_server()
	var client := await _join()
	_set_spell(server, client, 7, &"bolt", &"ember", &"instant")
	client.world.cast(7, Vector2.LEFT)
	assert_true(await wait_until(_client_sees_projectile_from.bind(client, 7)))


func test_a_non_bolt_shape_cannot_be_cast_yet() -> void:
	var server := _start_server()
	var client := await _join()
	_set_spell(server, client, 2, &"lance", &"ember", &"instant")
	client.world.cast(2, Vector2.RIGHT)
	await _ticks(20)
	assert_eq(server.world.dummies_in(&"left")[0].health, 30)


func test_destroying_the_dummy_levels_up_and_offers_the_three_cards() -> void:
	var server := _start_server()
	var client := await _join()
	await _destroy_dummy(server, client)
	assert_true(await wait_until(_client_has_choices.bind(client, 1)))
	var wizard := server.world.wizard(client.peer_id())
	assert_eq(wizard.wizard_level, 2)
	assert_eq(wizard.xp, 0)
	assert_eq(wizard.gold, _values.dummy_gold)
	var ids: Array[StringName] = []
	for card in client.world.offered_cards:
		ids.append(card.id)
	assert_eq(ids, [&"test_common", &"test_rare", &"test_legendary"] as Array[StringName])
	assert_true(await wait_until(_client_sees_level.bind(client, 2)))


func test_hitting_a_destroyed_dummy_gives_no_more_xp() -> void:
	var server := _start_server()
	var client := await _join()
	await _destroy_dummy(server, client)
	assert_true(await wait_until(_position_ready.bind(client, 0)))
	client.world.cast(1, Vector2.RIGHT)
	await _ticks(15)
	assert_eq(server.world.wizard(client.peer_id()).wizard_level, 2)
	assert_eq(server.world.wizard(client.peer_id()).xp, 0)


func test_a_spell_flies_through_a_destroyed_dummy() -> void:
	var server := _start_server()
	var client := await _join()
	await _destroy_dummy(server, client)
	assert_true(await wait_until(_position_ready.bind(client, 0)))
	client.world.cast(1, Vector2.RIGHT)
	# The dummy stands at x = 104 and a hit reaches 10 pixels: beyond 114, it flew through.
	assert_true(await wait_until(_client_sees_spell_beyond.bind(client, 114.0)))


func test_taking_a_card_closes_the_choice() -> void:
	var server := _start_server()
	var client := await _join()
	await _destroy_dummy(server, client)
	assert_true(await wait_until(_client_has_choices.bind(client, 1)))
	client.world.take_card(2)
	assert_true(await wait_until(_client_has_choices.bind(client, 0)))
	var wizard := server.world.wizard(client.peer_id())
	assert_eq(wizard.cards_taken, PackedStringArray(["test_legendary"]))
	assert_eq(wizard.card_choices.size(), 0)


func test_a_card_out_of_range_or_without_a_choice_is_ignored() -> void:
	var server := _start_server()
	var client := await _join()
	var channel := client.get_node("Channel") as WorldChannel
	channel.send_take_card(0)
	await _destroy_dummy(server, client)
	assert_true(await wait_until(_client_has_choices.bind(client, 1)))
	channel.send_take_card(3)
	channel.send_take_card(-1)
	await _ticks(10)
	assert_eq(server.world.wizard(client.peer_id()).cards_taken.size(), 0)
	assert_eq(client.world.pending_choices, 1)


func test_the_xp_goes_to_the_wizard_who_lands_the_last_hit() -> void:
	var server := _start_server()
	var first := await _join()
	var second := await _join()
	first.world.cast(1, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 20)))
	assert_true(await wait_until(_position_ready.bind(first, 0)))
	first.world.cast(1, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 10)))
	second.world.cast(1, Vector2.RIGHT)
	assert_true(await wait_until(_dummy_health_is.bind(server, 0)))
	assert_eq(server.world.wizard(first.peer_id()).xp, 0)
	assert_eq(server.world.wizard(second.peer_id()).wizard_level, 2)


## Three casts from position 1, waiting out its real cooldown between each, until the
## dummy's 30 health is gone.
func _destroy_dummy(server: GameServer, client: GameClient) -> void:
	for i in 3:
		client.world.cast(1, Vector2.RIGHT)
		var left := maxi(0, 30 - 10 * (i + 1))
		assert_true(await wait_until(_client_sees_dummy_health.bind(client, left)))
		if left > 0:
			assert_true(await wait_until(_position_ready.bind(client, 0)))


## Puts Shape [param shape_id], Element [param element_id] and Duration [param duration_id],
## all common, directly into the server's record of Grimoire position [param position] —
## the network path (`request_edit_spell`) has its own tests.
func _set_spell(
	server: GameServer,
	client: GameClient,
	position: int,
	shape_id: StringName,
	element_id: StringName,
	duration_id: StringName,
) -> void:
	var spell := server.world.wizard(client.peer_id()).grimoire[position - 1]
	spell.set_rune(Spell.Slot.SHAPE, shape_id)
	spell.set_rune(Spell.Slot.ELEMENT, element_id)
	spell.set_rune(Spell.Slot.DURATION, duration_id)


func _start_server() -> GameServer:
	var rooms := RoomFixtures.two_joined_rooms()
	rooms[&"left"].dummy_tiles = [Vector2i(6, 1)]
	var server := GameServer.new()
	server.world.rooms = rooms
	server.world.start_room = &"left"
	server.world.cards = _cards()
	server.world.values = _values
	_add(server)
	assert_eq(server.start(_port), OK)
	return server


## A client, standing in the left room and idle.
func _join() -> GameClient:
	var client := GameClient.new()
	client.world.rooms = RoomFixtures.two_joined_rooms()
	client.world.cards = _cards()
	client.world.input_override = Movement.IDLE
	_add(client)
	assert_eq(client.join("127.0.0.1", _port), OK)
	assert_true(await wait_until(_client_in_room.bind(client)))
	return client


## The three test cards, listed out of rarity order on purpose.
func _cards() -> Dictionary[StringName, Card]:
	var cards: Dictionary[StringName, Card] = { }
	for grade: int in [Rarity.LEGENDARY, Rarity.COMMON, Rarity.RARE]:
		var card := Card.new()
		card.id = StringName("test_" + Rarity.label(grade))
		card.rarity = grade
		cards[card.id] = card
	return cards


func _ticks(count: int) -> void:
	for i in count:
		await (Engine.get_main_loop() as SceneTree).physics_frame


func _client_in_room(client: GameClient) -> bool:
	return client.world.room != null


func _client_sees_dummy_health(client: GameClient, health: int) -> bool:
	var seen := client.world.dummy_health()
	return seen.size() == 1 and seen[0] == health


func _client_sees_spell_beyond(client: GameClient, x: float) -> bool:
	for spot in client.world.projectile_positions():
		if spot.x > x:
			return true
	return false


func _position_ready(client: GameClient, index: int) -> bool:
	var cooldowns := client.world.status.cooldowns
	return cooldowns.size() > index and cooldowns[index] == 0


func _client_sees_projectile_from(client: GameClient, grimoire_position: int) -> bool:
	return client.world.projectile_spells().has(grimoire_position)


func _mana_at_most(server: GameServer, client: GameClient, mana: int) -> bool:
	return server.world.wizard(client.peer_id()).mana <= mana


func _dummy_health_is(server: GameServer, health: int) -> bool:
	return server.world.dummies_in(&"left")[0].health == health


func _client_has_choices(client: GameClient, pending: int) -> bool:
	return client.world.pending_choices == pending


func _client_sees_level(client: GameClient, level: int) -> bool:
	return client.world.status.wizard_level == level


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)
