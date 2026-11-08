class_name KeyLabels
extends RefCounted
## What to call the key bound to an action, as the player's own keyboard prints it.
##
## Actions are bound to key positions (GLOSSARY.md, key position): the key left of W, not
## the letter Q. The system's keyboard layout turns each position into the letter printed
## on it, so a French AZERTY player reads A where the bindings say Q. Without a display, as
## in the tests, the QWERTY name of the position stands in.


## The first key or button bound to [param action], or an empty string when none is.
static func for_action(action: StringName) -> String:
	if not InputMap.has_action(action):
		return ""
	var events := InputMap.action_get_events(action)
	return describe(events[0]) if not events.is_empty() else ""


## A short name for [param event]: "LMB", "Space", "Shift+Q" and so on.
static func describe(event: InputEvent) -> String:
	var name := ""
	var mouse := event as InputEventMouseButton
	var key := event as InputEventKey
	if mouse != null:
		name = _mouse_name(mouse.button_index)
	elif key != null:
		name = OS.get_keycode_string(_printed(key.physical_keycode))
	var with_modifiers := event as InputEventWithModifiers
	if with_modifiers != null and with_modifiers.shift_pressed:
		name = "Shift+" + name
	return name


## The key printed at [param position] on the player's layout.
static func _printed(position: Key) -> Key:
	if DisplayServer.get_name() == "headless":
		return position
	var printed := DisplayServer.keyboard_get_label_from_physical(position)
	return printed if printed != KEY_NONE else position


static func _mouse_name(button: MouseButton) -> String:
	match button:
		MOUSE_BUTTON_LEFT:
			return "LMB"
		MOUSE_BUTTON_RIGHT:
			return "RMB"
		MOUSE_BUTTON_MIDDLE:
			return "MMB"
	return "Mouse %d" % button
