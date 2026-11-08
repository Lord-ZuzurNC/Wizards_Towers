extends TestCase
## Buying a village with gold, end to end.
##
## Real server, real clients, real ticks, in the [code]left[/code] room of [RoomFixtures],
## which holds two villages here: "Near", one tile right of the spawn and so in reach, and
## "Far", two tiles left of it, out of reach until the wizard walks to the wall. Unless a
## test says otherwise, wizards start with 100 gold and the first village costs 20.

const LEFT := 3

static var _next_port := 18_977

var _port := 0
var _nodes: Array[Node] = []
var _values: PlaceholderValues


func before_each() -> void:
	_port = _next_port
	_next_port += 1
	_values = PlaceholderValues.new()
	_values.starting_gold = 100
	_values.village_base_price = 20
	_values.village_price_multiplier = 2.0


func after_each() -> void:
	for node in _nodes:
		node.queue_free()
	_nodes.clear()
	await (Engine.get_main_loop() as SceneTree).process_frame


func test_buying_a_village_in_reach_takes_its_price_and_makes_it_yours() -> void:
	var server := _start_server()
	var client := await _join()
	assert_eq(client.world.village_in_reach(), 0)
	client.world.buy_village(0)
	assert_true(await wait_until(client.world.owns_village.bind(0)))
	assert_eq(server.world.villages_in(&"left")[0].owner_peer_id, client.peer_id())
	assert_eq(server.world.wizard(client.peer_id()).gold, 80)
	assert_true(await wait_until(_client_sees_gold.bind(client, 80)))


func test_the_next_village_costs_more() -> void:
	_start_server()
	var client := await _join()
	assert_eq(client.world.status.village_price, 20)
	client.world.buy_village(0)
	assert_true(await wait_until(_client_sees_price.bind(client, 40)))


func test_a_village_out_of_reach_is_not_bought() -> void:
	var server := _start_server()
	var client := await _join()
	client.world.buy_village(1)
	await _ticks(10)
	assert_eq(server.world.villages_in(&"left")[1].owner_peer_id, 0)
	assert_eq(server.world.wizard(client.peer_id()).gold, 100)


func test_without_the_gold_nothing_is_bought() -> void:
	_values.starting_gold = 19
	var server := _start_server()
	var client := await _join()
	assert_eq(client.world.village_verdict(0), VillagePurchase.Verdict.NOT_ENOUGH_GOLD)
	client.world.buy_village(0)
	await _ticks(10)
	assert_eq(server.world.villages_in(&"left")[0].owner_peer_id, 0)
	assert_eq(server.world.wizard(client.peer_id()).gold, 19)


func test_a_village_held_by_another_cannot_be_bought() -> void:
	var server := _start_server()
	var first := await _join()
	var second := await _join()
	first.world.buy_village(0)
	assert_true(await wait_until(_client_sees_holder.bind(second, first.peer_id())))
	assert_eq(second.world.village_verdict(0), VillagePurchase.Verdict.OWNED)
	assert_false(second.world.owns_village(0))
	second.world.buy_village(0)
	await _ticks(10)
	assert_eq(server.world.villages_in(&"left")[0].owner_peer_id, first.peer_id())
	assert_eq(server.world.wizard(second.peer_id()).gold, 100)


func test_a_level_1_wizard_cannot_buy_a_second_village() -> void:
	var server := _start_server()
	var client := await _join()
	client.world.buy_village(0)
	assert_true(await wait_until(client.world.owns_village.bind(0)))
	await _walk_to_far_village(client)
	assert_eq(client.world.village_verdict(1), VillagePurchase.Verdict.LEVEL_TOO_LOW)
	client.world.buy_village(1)
	await _ticks(10)
	assert_eq(server.world.villages_in(&"left")[1].owner_peer_id, 0)


func test_at_level_2_a_second_village_is_bought_at_the_higher_price() -> void:
	var server := _start_server()
	var client := await _join()
	client.world.buy_village(0)
	assert_true(await wait_until(client.world.owns_village.bind(0)))
	server.world.wizard(client.peer_id()).wizard_level = 2
	await _walk_to_far_village(client)
	client.world.buy_village(1)
	assert_true(await wait_until(client.world.owns_village.bind(1)))
	assert_eq(server.world.wizard(client.peer_id()).gold, 100 - 20 - 40)
	assert_eq(server.world.villages_held(client.peer_id()), 2)


func test_buying_while_walking_is_judged_where_the_player_saw_the_wizard() -> void:
	# Walking left from the spawn, "Near" falls out of reach after a few ticks. The request
	# leaves while the client still shows it in reach; the server holds it until the inputs
	# sent before it are applied, so the wizard is in reach there too.
	var server := _start_server()
	var client := await _join()
	client.world.input_override = LEFT
	await _ticks(2)
	assert_eq(client.world.village_in_reach(), 0)
	client.world.buy_village(0)
	assert_true(await wait_until(client.world.owns_village.bind(0)))
	assert_eq(server.world.villages_held(client.peer_id()), 1)


func test_a_purchase_waits_for_the_inputs_sent_before_it() -> void:
	var server := _start_server()
	var client := await _join()
	var channel := client.get_node("Channel") as WorldChannel
	# Idle inputs still count, one a tick: this one comes about 30 ticks from now.
	channel.send_buy_village(0, client.world.status.acknowledged + 30)
	await _ticks(15)
	assert_eq(server.world.villages_held(client.peer_id()), 0)
	assert_true(await wait_until(client.world.owns_village.bind(0)))


func test_an_invalid_village_index_is_ignored() -> void:
	var server := _start_server()
	var client := await _join()
	var channel := client.get_node("Channel") as WorldChannel
	channel.send_buy_village(2, 0)
	await _ticks(5)
	channel.send_buy_village(-1, 0)
	await _ticks(10)
	assert_eq(server.world.wizard(client.peer_id()).gold, 100)
	assert_eq(server.world.villages_held(client.peer_id()), 0)


func test_a_holder_who_leaves_keeps_the_village() -> void:
	var server := _start_server()
	var client := await _join()
	var holder := client.peer_id()
	client.world.buy_village(0)
	assert_true(await wait_until(client.world.owns_village.bind(0)))
	client.leave()
	assert_true(await wait_until(_server_lost.bind(server, holder)))
	assert_eq(server.world.villages_in(&"left")[0].owner_peer_id, holder)


func test_the_hud_says_what_the_key_would_do() -> void:
	_start_server()
	var client := await _join()
	var hud := Hud.new(client.world)
	_add(hud)
	assert_true(await wait_until(_prompt_reads.bind(hud, "E: buy Near, 20 gold")), hud.prompt.text)
	client.world.buy_village(0)
	assert_true(await wait_until(_prompt_reads.bind(hud, "Near is yours")), hud.prompt.text)
	await _walk_to_far_village(client)
	assert_true(
		await wait_until(_prompt_reads.bind(hud, "Level 2 to hold a second village")),
		hud.prompt.text,
	)


func _walk_to_far_village(client: GameClient) -> void:
	client.world.input_override = LEFT
	assert_true(await wait_until(_in_reach_of.bind(client, 1)))
	client.world.input_override = Movement.IDLE


func _start_server() -> GameServer:
	var server := GameServer.new()
	server.world.rooms = _rooms()
	server.world.start_room = &"left"
	server.world.values = _values
	_add(server)
	assert_eq(server.start(_port), OK)
	return server


## A client, standing in the left room and idle.
func _join() -> GameClient:
	var client := GameClient.new()
	client.world.rooms = _rooms()
	client.world.values = _values
	client.world.input_override = Movement.IDLE
	_add(client)
	assert_eq(client.join("127.0.0.1", _port), OK)
	assert_true(await wait_until(_has_status.bind(client)))
	return client


func _rooms() -> Dictionary[StringName, RoomData]:
	var rooms := RoomFixtures.two_joined_rooms()
	var near := VillageSite.new()
	near.title = "Near"
	near.tile = Vector2i(5, 1)
	var far := VillageSite.new()
	far.title = "Far"
	far.tile = Vector2i(2, 1)
	rooms[&"left"].villages = [near, far]
	return rooms


func _ticks(count: int) -> void:
	for i in count:
		await (Engine.get_main_loop() as SceneTree).physics_frame


func _has_status(client: GameClient) -> bool:
	return client.world.room != null and client.world.status.village_price > 0


func _client_sees_gold(client: GameClient, gold: int) -> bool:
	return client.world.status.gold == gold


func _client_sees_price(client: GameClient, price: int) -> bool:
	return client.world.status.village_price == price


func _client_sees_holder(client: GameClient, holder: int) -> bool:
	return client.world.village_owner(0) == holder


func _in_reach_of(client: GameClient, index: int) -> bool:
	return client.world.village_in_reach() == index


func _server_lost(server: GameServer, peer_id: int) -> bool:
	return not server.world.has_wizard(peer_id)


func _prompt_reads(hud: Hud, text: String) -> bool:
	return hud.prompt.text == text


func _add(node: Node) -> void:
	(Engine.get_main_loop() as SceneTree).root.add_child(node)
	_nodes.append(node)
