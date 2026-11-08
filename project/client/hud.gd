class_name Hud
extends CanvasLayer
## The player's numbers along the bottom of the screen, and the level-up card choice.
##
## A level-up never opens its choice by itself: the world does not pause, so a choice that
## covered the screen mid-fight would be a trap (CARDS.md, The level-up choice). A badge
## says a choice waits; [kbd]C[/kbd] opens it, a click takes a card, [kbd]C[/kbd] again
## closes it untouched.

const TEXT_COLOR := Color("ffffeb")
const BADGE_COLOR := Color("ffe091")
const PANEL_COLOR := Color("12173dee")
const CARD_COLOR := Color("293268")
const CARD_SIZE := Vector2(120, 160)

## The status line, with the connection state; [code]main.gd[/code] writes to it.
var connection := Label.new()
## Says how many card choices wait; hidden when none does.
var badge := Label.new()

var _world: ClientWorld
var _numbers := Label.new()
var _panel := Control.new()
var _row := HBoxContainer.new()


func _init(world: ClientWorld) -> void:
	_world = world
	_world.status_changed.connect(_refresh_numbers)
	_world.card_choices_changed.connect(_refresh_choices)
	# Below the room, which fills the top 320 of the 360 lines.
	connection.position = Vector2(8, 340)
	_numbers.position = Vector2(8, 324)
	badge.position = Vector2(440, 324)
	badge.add_theme_color_override(&"font_color", BADGE_COLOR)
	for label: Label in [connection, _numbers]:
		label.add_theme_color_override(&"font_color", TEXT_COLOR)
	for label: Label in [connection, _numbers, badge]:
		label.add_theme_font_size_override(&"font_size", 12)
		add_child(label)
	_build_panel()
	_refresh_choices()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"open_card_choice"):
		toggle_choice()
		get_viewport().set_input_as_handled()


## Opens the oldest waiting choice, or closes the open one without taking anything.
func toggle_choice() -> void:
	if _panel.visible:
		_panel.hide()
	elif _world.pending_choices > 0:
		_panel.show()


func is_choice_open() -> bool:
	return _panel.visible


func _build_panel() -> void:
	_panel.hide()
	_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	var shade := ColorRect.new()
	shade.color = PANEL_COLOR
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel.add_child(shade)
	var title := Label.new()
	title.text = "Level up: take one card"
	title.add_theme_color_override(&"font_color", TEXT_COLOR)
	title.position = Vector2(0, 40)
	title.size = Vector2(640, 20)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_panel.add_child(title)
	_row.position = Vector2(110, 90)
	_row.add_theme_constant_override(&"separation", 20)
	_panel.add_child(_row)
	add_child(_panel)


func _refresh_numbers() -> void:
	var status := _world.status
	_numbers.text = (
		"Health %d/%d   Mana %d/%d   Level %d   XP %d/%d"
		% [
			status.health,
			status.max_health,
			status.mana,
			status.mana_pool,
			status.wizard_level,
			status.xp,
			status.xp_to_next,
		]
	)


func _refresh_choices() -> void:
	var pending := _world.pending_choices
	badge.text = "▲ %d card choice%s: press C" % [pending, "" if pending == 1 else "s"]
	badge.visible = pending > 0
	for child in _row.get_children():
		child.queue_free()
	for i in _world.offered_cards.size():
		_row.add_child(_card_button(_world.offered_cards[i], i))
	if pending == 0:
		_panel.hide()


func _card_button(card: Card, index: int) -> Button:
	var button := Button.new()
	button.custom_minimum_size = CARD_SIZE
	button.text = "%s\n\n%s" % [card.title, Rarity.label(card.rarity)]
	button.autowrap_mode = TextServer.AUTOWRAP_WORD
	var grade := Rarity.color(card.rarity)
	button.add_theme_color_override(&"font_color", grade)
	button.add_theme_color_override(&"font_hover_color", TEXT_COLOR)
	for state: StringName in [&"normal", &"hover", &"pressed", &"focus"]:
		var box := StyleBoxFlat.new()
		box.bg_color = CARD_COLOR if state != &"hover" else CARD_COLOR.lightened(0.15)
		box.border_color = grade
		box.set_border_width_all(3 if card.rarity == Rarity.COMMON else 5)
		box.set_corner_radius_all(4)
		# Rounded corners stay on the pixel grid: no half-transparent pixels at the curve.
		box.anti_aliasing = false
		button.add_theme_stylebox_override(state, box)
	button.pressed.connect(_on_card_pressed.bind(index))
	return button


## Choices open one at a time: taking a card closes this one, even when another waits.
func _on_card_pressed(index: int) -> void:
	_world.take_card(index)
	_panel.hide()
