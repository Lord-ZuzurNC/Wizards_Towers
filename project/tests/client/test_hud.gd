extends TestCase
## The HUD's card choice: a badge while choices wait, a panel only when asked for.

var _world: ClientWorld
var _channel: WorldChannel
var _hud: Hud


func before_each() -> void:
	_world = ClientWorld.new()
	_channel = WorldChannel.new()
	var cards: Dictionary[StringName, Card] = { }
	for grade: int in [Rarity.COMMON, Rarity.RARE, Rarity.LEGENDARY]:
		var card := Card.new()
		card.id = StringName("test_" + Rarity.label(grade))
		card.title = "Test card"
		card.rarity = grade
		cards[card.id] = card
	_world.cards = cards
	_world.rooms = RoomFixtures.two_joined_rooms()
	_world.setup(_channel, 1)
	_hud = Hud.new(_world)
	var root := (Engine.get_main_loop() as SceneTree).root
	root.add_child(_world)
	root.add_child(_channel)
	root.add_child(_hud)


func after_each() -> void:
	for node: Node in [_hud, _channel, _world]:
		node.queue_free()
	_hud = null
	_channel = null
	_world = null
	await (Engine.get_main_loop() as SceneTree).process_frame


func test_no_choice_no_badge_and_nothing_opens() -> void:
	assert_false(_badge().visible)
	_hud.toggle_choice()
	assert_false(_hud.is_choice_open())


func test_a_waiting_choice_shows_the_badge_but_stays_closed() -> void:
	_offer(1)
	assert_true(_badge().visible)
	assert_true(_badge().text.contains("1 card choice:"), _badge().text)
	assert_false(_hud.is_choice_open())


func test_opening_shows_the_three_cards_in_their_grade_colours() -> void:
	_offer(2)
	assert_true(_badge().text.contains("2 card choices"), _badge().text)
	_hud.toggle_choice()
	assert_true(_hud.is_choice_open())
	await (Engine.get_main_loop() as SceneTree).process_frame
	var buttons := _buttons()
	assert_eq(buttons.size(), 3)
	for i in buttons.size():
		var border := (buttons[i].get_theme_stylebox(&"normal") as StyleBoxFlat).border_color
		assert_eq(border, Rarity.COLORS[i])


func test_the_key_closes_it_again_untouched() -> void:
	_offer(1)
	_hud.toggle_choice()
	_hud.toggle_choice()
	assert_false(_hud.is_choice_open())
	assert_eq(_world.pending_choices, 1)


func test_no_choice_left_closes_the_panel_and_hides_the_badge() -> void:
	_offer(1)
	_hud.toggle_choice()
	_channel.card_choices_received.emit(0, PackedStringArray())
	assert_false(_hud.is_choice_open())
	assert_false(_badge().visible)


func _offer(pending: int) -> void:
	var ids := PackedStringArray(["test_common", "test_rare", "test_legendary"])
	_channel.card_choices_received.emit(pending, ids)


func _badge() -> Label:
	return _hud.badge


func _buttons() -> Array[Button]:
	var found: Array[Button] = []
	for node in _hud.find_children("*", "Button", true, false):
		if not node.is_queued_for_deletion():
			found.append(node as Button)
	return found
