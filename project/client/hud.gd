class_name Hud
extends CanvasLayer
## The player's numbers along the bottom of the screen, what the interact key would do, and
## the level-up card choice.
##
## A level-up never opens its choice by itself: the world does not pause, so a choice that
## covered the screen mid-fight would be a trap (CARDS.md, The level-up choice). A badge
## says a choice waits; [kbd]C[/kbd] opens it, a click takes a card, [kbd]C[/kbd] again
## closes it untouched.
##
## Text uses the project theme's font, Pixel Operator, at the 16 pixels it is drawn for:
## any other size breaks its pixel grid.

const TEXT_COLOR := Color("ffffeb")
const BADGE_COLOR := Color("ffe091")
const PANEL_COLOR := Color("12173dee")
const BAND_COLOR := Color("12173d")
const CARD_COLOR := Color("293268")
const CARD_SIZE := Vector2(120, 160)

## The connection state; [code]main.gd[/code] writes to it. Shown until the session opens,
## and again if it ends.
var connection := Label.new()
## Where the player is: a room, or the biome underfoot on a world map. Shown in place of
## the connection state while the session is open.
var location := Label.new()
## Says how many card choices wait; hidden when none does.
var badge := Label.new()
## Says what the interact key would do here; empty when it would do nothing.
var prompt := Label.new()

var _world: ClientWorld
var _numbers := Label.new()
var _panel := Control.new()
var _row := HBoxContainer.new()


func _init(world: ClientWorld) -> void:
	_world = world
	_world.status_changed.connect(_refresh_numbers)
	_world.card_choices_changed.connect(_refresh_choices)
	# An opaque band under the text: a world map scrolls on beneath it.
	var band := ColorRect.new()
	band.color = BAND_COLOR
	band.position = Vector2(0, 320)
	band.size = Vector2(640, 40)
	add_child(band)
	# Two lines below the room, which fills the top 320 of the 360 lines: on the left what
	# is, on the right what to do.
	_numbers.position = Vector2(8, 320)
	connection.position = Vector2(8, 339)
	location.position = Vector2(8, 339)
	location.hide()
	for label: Label in [badge, prompt]:
		label.size = Vector2(316, 18)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	badge.position = Vector2(316, 320)
	prompt.position = Vector2(316, 339)
	for label: Label in [connection, location, _numbers]:
		label.add_theme_color_override(&"font_color", TEXT_COLOR)
	for label: Label in [badge, prompt]:
		label.add_theme_color_override(&"font_color", BADGE_COLOR)
	for label: Label in [connection, location, _numbers, badge, prompt]:
		add_child(label)
	_build_panel()
	_refresh_choices()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"open_card_choice"):
		toggle_choice()
		get_viewport().set_input_as_handled()


## Shows where the player is in place of the connection state, or the other way round.
func show_location(shown: bool) -> void:
	location.visible = shown
	connection.visible = not shown


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
		"Health %d/%d  Mana %d/%d  Level %d  XP %d/%d  Gold %d"
		% [
			status.health,
			status.max_health,
			status.mana,
			status.mana_pool,
			status.wizard_level,
			status.xp,
			status.xp_to_next,
			status.gold,
		]
	)
	prompt.text = _prompt_text()
	location.text = _world.location_name()


func _prompt_text() -> String:
	var index := _world.village_in_reach()
	if index < 0:
		return ""
	var title := _world.room.villages[index].title
	var status := _world.status
	match _world.village_verdict(index):
		VillagePurchase.Verdict.ALLOWED:
			return "E: buy %s, %d gold" % [title, status.village_price]
		VillagePurchase.Verdict.OWNED:
			if _world.owns_village(index):
				return "%s is yours" % title
			return "%s is held by another wizard" % title
		VillagePurchase.Verdict.LEVEL_TOO_LOW:
			return "Level %d to hold a second village" % VillagePurchase.SECOND_VILLAGE_LEVEL
		VillagePurchase.Verdict.NOT_ENOUGH_GOLD:
			return "%s: %d gold, you have %d" % [title, status.village_price, status.gold]
	return ""


func _refresh_choices() -> void:
	var pending := _world.pending_choices
	badge.text = "%d card choice%s: press C" % [pending, "" if pending == 1 else "s"]
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
