extends TestCase
## The HUD's card choice: a badge while choices wait, a panel only when asked for.
## The banner of a run's end, or of the player's own wizard's death, and Escape to start
## again after one. The peace shield's label, and the Grimoire editor.
##
## No server: the test emits the channel's signals itself, and a [RecordingChannel] keeps
## what the client asks for instead of sending it.

var _world: ClientWorld
var _channel: RecordingChannel
var _hud: Hud


func before_each() -> void:
	_world = ClientWorld.new()
	_channel = RecordingChannel.new()
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


func test_the_spell_bar_names_its_ten_keys_in_two_rows() -> void:
	var texts: Array[String] = []
	for node in _hud.find_children("*", "Label", true, false):
		texts.append((node as Label).text)
	for expected: String in ["LMB", "RMB", "Space", "Q", "E", "Shift"]:
		assert_true(texts.has(expected), "%s missing from %s" % [expected, texts])
	# Each key appears twice: once plain, once in the Shift row.
	assert_eq(texts.count("LMB"), 2)


func test_an_open_card_choice_keeps_clicks_from_casting() -> void:
	_offer(1)
	_hud.toggle_choice()
	assert_true(_world.ui_has_mouse)
	_hud.toggle_choice()
	assert_false(_world.ui_has_mouse)


func test_a_death_shows_its_ending_and_stays_up() -> void:
	_channel.wizard_died_received.emit(WizardEnding.Kind.DEVOURED_WILDS)
	assert_true(_hud.ending.visible)
	assert_true(_hud.ending.text.begins_with("Devoured by the Wilds"), _hud.ending.text)
	await _outlast_a_world_ending()
	assert_true(_hud.ending.visible)


func test_a_world_ending_after_a_death_shows_the_world_ending() -> void:
	_channel.wizard_died_received.emit(WizardEnding.Kind.DEVOURED_WILDS)
	_channel.world_ending_received.emit(WorldEnding.Kind.WORLD_COLLAPSE)
	assert_true(_hud.ending.visible)
	assert_true(_hud.ending.text.begins_with("World Collapse"), _hud.ending.text)
	await _outlast_a_world_ending()
	assert_false(_hud.ending.visible)


func test_a_death_soon_after_a_world_ending_outlasts_its_timer() -> void:
	_channel.world_ending_received.emit(WorldEnding.Kind.WORLD_COLLAPSE)
	_channel.wizard_died_received.emit(WizardEnding.Kind.DEVOURED_WILDS)
	await _outlast_a_world_ending()
	assert_true(_hud.ending.visible)
	assert_true(_hud.ending.text.begins_with("Devoured by the Wilds"), _hud.ending.text)


func test_the_peace_shield_shows_while_it_is_up_and_goes_once_broken() -> void:
	assert_false(_hud.peace_shield.visible)
	_update(1, true)
	assert_true(_hud.peace_shield.visible)
	_update(2, false)
	assert_false(_hud.peace_shield.visible)


func test_a_fresh_wizard_after_a_death_hides_the_death_banner() -> void:
	_update(1, false, true)
	_channel.wizard_died_received.emit(WizardEnding.Kind.DEVOURED_WILDS)
	assert_true(_hud.ending.text.contains("Escape"), _hud.ending.text)
	_update(2, false, true)
	assert_true(_hud.ending.visible)
	_update(3, true, false)
	assert_false(_hud.ending.visible)


func test_a_fresh_wizard_after_a_run_s_end_keeps_the_run_s_banner() -> void:
	_update(1, false, true)
	_channel.wizard_died_received.emit(WizardEnding.Kind.DEVOURED_WILDS)
	_channel.world_ending_received.emit(WorldEnding.Kind.WORLD_COLLAPSE)
	_update(2, true, false)
	assert_true(_hud.ending.visible)
	assert_true(_hud.ending.text.begins_with("World Collapse"), _hud.ending.text)


func test_escape_while_dead_asks_to_start_again() -> void:
	_update(1, false, true)
	await _press_escape()
	assert_eq(_channel.respawns, 1)


func test_escape_while_alive_does_nothing() -> void:
	_update(1, true, false)
	await _press_escape()
	assert_eq(_channel.respawns, 0)


func test_picking_a_position_a_slot_and_a_rune_asks_for_that_edit_at_common() -> void:
	_update(1, true, false, 3)
	_hud.toggle_grimoire()
	assert_true(_hud.is_grimoire_open())
	assert_true(_world.ui_has_mouse)
	_editor_button("2").pressed.emit()
	_editor_button("Shape: empty").pressed.emit()
	_editor_button("Lance").pressed.emit()
	assert_eq(_channel.edits, [[2, Spell.Slot.SHAPE as int, &"lance", Rarity.COMMON as int]])


func test_closed_positions_are_greyed_out_and_cannot_be_picked() -> void:
	_update(1, true, false, 3)
	_hud.toggle_grimoire()
	assert_false(_editor_button("3").disabled)
	assert_true(_editor_button("4").disabled)
	_hud.grimoire_editor.pick_position(4)
	assert_eq(_editor_buttons_starting("Shape").size(), 0)


func test_an_accepted_edit_shows_in_the_editor() -> void:
	_update(1, true, false, 3)
	_hud.toggle_grimoire()
	_editor_button("2").pressed.emit()
	_channel.spell_edited_received.emit(2, Spell.Slot.SHAPE, &"lance", Rarity.COMMON)
	assert_eq(_world.grimoire[1].rune_id(Spell.Slot.SHAPE), &"lance")
	assert_eq(_editor_buttons_starting("Shape").size(), 1)
	assert_eq(_editor_buttons_starting("Shape")[0].text, "Shape: Lance")


func test_the_key_closes_the_editor_and_only_one_panel_opens_at_a_time() -> void:
	_offer(1)
	_hud.toggle_grimoire()
	_hud.toggle_choice()
	assert_true(_hud.is_choice_open())
	assert_false(_hud.is_grimoire_open())
	_hud.toggle_grimoire()
	assert_false(_hud.is_choice_open())
	_hud.toggle_grimoire()
	assert_false(_hud.is_grimoire_open())
	assert_false(_world.ui_has_mouse)


func _outlast_a_world_ending() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(Hud.ENDING_SECONDS + 0.5).timeout


func _offer(pending: int) -> void:
	var ids := PackedStringArray(["test_common", "test_rare", "test_legendary"])
	_channel.card_choices_received.emit(pending, ids)


## Sends a state update of the player's wizard alone in the left room.
func _update(tick: int, shield: bool, dead := false, positions := 1) -> void:
	var update := StateUpdate.new()
	update.tick = tick
	update.room_id = &"left"
	update.wizard_ids = PackedInt32Array([1])
	update.wizard_positions = PackedVector2Array(
		[_world.rooms[&"left"].tile_center(Vector2i(4, 1))]
	)
	update.peace_shield_active = shield
	update.is_dead = dead
	update.grimoire_positions = positions
	_channel.state_update_received.emit(update)


## Presses and releases Escape, the way the keyboard would, across two physics ticks.
func _press_escape() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	var press := InputEventKey.new()
	press.keycode = KEY_ESCAPE
	press.physical_keycode = KEY_ESCAPE
	press.pressed = true
	Input.parse_input_event(press)
	Input.flush_buffered_events()
	await tree.physics_frame
	await tree.physics_frame
	var release := press.duplicate() as InputEventKey
	release.pressed = false
	Input.parse_input_event(release)
	Input.flush_buffered_events()


func _editor_button(text: String) -> Button:
	for button in _editor_buttons_starting(text):
		if button.text == text:
			return button
	fail("no editor button '%s'" % text)
	return Button.new()


func _editor_buttons_starting(text: String) -> Array[Button]:
	var found: Array[Button] = []
	for node in _hud.grimoire_editor.find_children("*", "Button", true, false):
		var button := node as Button
		if button.visible and button.text.begins_with(text):
			found.append(button)
	return found


func _badge() -> Label:
	return _hud.badge


func _buttons() -> Array[Button]:
	var found: Array[Button] = []
	for node in _hud.find_children("*", "Button", true, false):
		# The card choice's buttons only, not the Grimoire editor's.
		if not node.is_queued_for_deletion() and not _hud.grimoire_editor.is_ancestor_of(node):
			found.append(node as Button)
	return found


## A channel that keeps what the client asks for instead of sending it: there is no server.
class RecordingChannel:
	extends WorldChannel

	var respawns := 0
	## [grimoire_position, slot, rune_id, grade] of each edit asked for.
	var edits: Array = []


	func send_move(_first_sequence: int, _codes: PackedByteArray) -> void:
		pass


	func send_respawn() -> void:
		respawns += 1


	func send_edit_spell(
		grimoire_position: int,
		slot: int,
		rune_id: StringName,
		grade: int,
	) -> void:
		edits.append([grimoire_position, slot, rune_id, grade])
