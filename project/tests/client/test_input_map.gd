extends TestCase
## The movement keys, as the project maps them.


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


func test_casting_and_the_card_choice_have_their_keys() -> void:
	var expected := { &"cast_1": KEY_1, &"open_card_choice": KEY_C }
	for action: StringName in expected:
		assert_true(InputMap.has_action(action), action)
		var event := InputMap.action_get_events(action)[0] as InputEventKey
		assert_eq(event.physical_keycode, expected[action])


func test_a_physical_key_press_triggers_its_action() -> void:
	var press := InputEventKey.new()
	press.physical_keycode = KEY_D
	press.pressed = true
	Input.parse_input_event(press)
	Input.flush_buffered_events()
	assert_true(Input.is_action_pressed(&"move_right"))
