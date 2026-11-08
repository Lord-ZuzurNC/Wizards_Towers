extends TestCase
## Naming keys and buttons. Without a display the QWERTY name of a key position stands in
## for the label the player's layout prints on it.


func test_mouse_buttons_have_short_names() -> void:
	assert_eq(KeyLabels.describe(_button(MOUSE_BUTTON_LEFT)), "LMB")
	assert_eq(KeyLabels.describe(_button(MOUSE_BUTTON_RIGHT)), "RMB")
	assert_eq(KeyLabels.describe(_button(MOUSE_BUTTON_MIDDLE)), "MMB")
	assert_eq(KeyLabels.describe(_button(MOUSE_BUTTON_XBUTTON1)), "Mouse 8")


func test_a_key_is_named_by_its_position() -> void:
	var key := InputEventKey.new()
	key.physical_keycode = KEY_Q
	assert_eq(KeyLabels.describe(key), "Q")


func test_shift_comes_first() -> void:
	var key := InputEventKey.new()
	key.physical_keycode = KEY_SPACE
	key.shift_pressed = true
	assert_eq(KeyLabels.describe(key), "Shift+Space")


func test_an_unknown_action_has_no_name() -> void:
	assert_eq(KeyLabels.for_action(&"no_such_action"), "")


func _button(index: MouseButton) -> InputEventMouseButton:
	var button := InputEventMouseButton.new()
	button.button_index = index
	return button
