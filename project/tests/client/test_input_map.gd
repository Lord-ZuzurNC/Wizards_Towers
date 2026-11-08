extends TestCase
## The default controls, as TECH_STACK.md, Controls, sets them.


func after_each() -> void:
	Input.action_release(&"move_left")
	Input.action_release(&"move_right")
	Input.action_release(&"move_up")
	Input.action_release(&"move_down")


func test_the_four_movement_actions_exist() -> void:
	for action: StringName in [&"move_left", &"move_right", &"move_up", &"move_down"]:
		assert_true(InputMap.has_action(action), action)


func test_each_action_answers_to_a_letter_and_an_arrow() -> void:
	var expected := {
		&"move_left": [KEY_A, KEY_LEFT],
		&"move_right": [KEY_D, KEY_RIGHT],
		&"move_up": [KEY_W, KEY_UP],
		&"move_down": [KEY_S, KEY_DOWN],
	}
	for action: StringName in expected:
		var keys: Array[int] = []
		for event in InputMap.action_get_events(action):
			var key_event := event as InputEventKey
			if key_event != null:
				keys.append(key_event.physical_keycode)
		for key: int in expected[action]:
			assert_true(keys.has(key), "%s lacks key %d" % [action, key])


func test_the_grimoire_positions_follow_the_controls_of_tech_stack() -> void:
	var expected := [
		"LMB",
		"RMB",
		"Space",
		"Q",
		"E",
		"Shift+LMB",
		"Shift+RMB",
		"Shift+Space",
		"Shift+Q",
		"Shift+E",
	]
	for i in expected.size():
		var action := ClientWorld.cast_action(i + 1)
		assert_true(InputMap.has_action(action), action)
		assert_eq(KeyLabels.for_action(action), expected[i], action)


func test_interacting_and_the_card_choice_have_their_keys() -> void:
	assert_eq(KeyLabels.for_action(&"interact"), "F")
	assert_eq(KeyLabels.for_action(&"open_card_choice"), "C")


func test_shift_with_a_button_casts_from_the_shift_row_only() -> void:
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.shift_pressed = true
	Input.parse_input_event(click)
	Input.flush_buffered_events()
	assert_true(Input.is_action_pressed(&"cast_6", true))
	assert_false(Input.is_action_pressed(&"cast_1", true))
	var release := click.duplicate() as InputEventMouseButton
	release.pressed = false
	Input.parse_input_event(release)
	Input.flush_buffered_events()


func test_a_physical_key_press_triggers_its_action() -> void:
	var press := InputEventKey.new()
	press.physical_keycode = KEY_D
	press.pressed = true
	Input.parse_input_event(press)
	Input.flush_buffered_events()
	assert_true(Input.is_action_pressed(&"move_right"))
