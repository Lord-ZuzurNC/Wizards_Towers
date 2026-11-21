class_name GrimoireEditor
extends Control
## The panel that puts runes in the spell slots of the player's Grimoire positions.
##
## A row of the ten positions, the closed ones greyed out as on the spell bar; picking an
## open one shows its five spell slots and the rune in each; picking a slot lists every
## rune that fits it; picking a rune asks the server to put it there, through
## [method ClientWorld.edit_spell]. Nothing changes on screen until the server accepts the
## edit (see [signal ClientWorld.grimoire_changed]); a refused one changes nothing.
##
## Every edit asks for [constant Rarity.COMMON]: for now every wizard knows every rune at
## common rarity only ([method KnownRunes.starter]), and no loot teaches a rarer grade yet,
## so there is no rarity to choose.
##
## Plain flat rectangles in the HUD's palette, like the card choice.

## [enum Spell.Slot] order.
const SLOT_NAMES: Array[String] = ["Shape", "Element", "Duration", "Effect 1", "Effect 2"]
const POSITION_SIZE := Vector2(56, 22)
const POSITIONS_AT := Vector2(22, 52)
const SLOT_SIZE := Vector2(200, 22)
const SLOTS_AT := Vector2(22, 90)
const RUNE_SIZE := Vector2(116, 22)
const RUNES_AT := Vector2(240, 90)
const RUNES_SIZE := Vector2(378, 222)
const GAP := 4

var _world: ClientWorld
var _position_buttons: Array[Button] = []
var _slot_buttons: Array[Button] = []
var _runes := GridContainer.new()
## The Grimoire position shown, 1 to 10; 0 before one is picked.
var _picked_position := 0
## The [enum Spell.Slot] whose runes are listed; -1 before one is picked.
var _picked_slot := -1


func _init(world: ClientWorld) -> void:
	_world = world
	_world.status_changed.connect(_refresh_positions)
	_world.grimoire_changed.connect(_refresh_slots)
	hide()
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var shade := ColorRect.new()
	shade.color = Hud.PANEL_COLOR
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	var title := Label.new()
	title.text = "Grimoire: pick a position, a slot, then a rune"
	title.add_theme_color_override(&"font_color", Hud.TEXT_COLOR)
	title.position = Vector2(0, 24)
	title.size = Vector2(640, 20)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	for i in Grimoire.MAX_POSITIONS:
		var button := _button(str(i + 1), POSITION_SIZE)
		button.position = POSITIONS_AT + Vector2(i * (POSITION_SIZE.x + GAP), 0)
		button.pressed.connect(pick_position.bind(i + 1))
		add_child(button)
		_position_buttons.append(button)
	for slot: int in Spell.Slot.values():
		var button := _button("", SLOT_SIZE)
		button.position = SLOTS_AT + Vector2(0, slot * (SLOT_SIZE.y + GAP))
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(pick_slot.bind(slot))
		add_child(button)
		_slot_buttons.append(button)
	var scroll := ScrollContainer.new()
	scroll.position = RUNES_AT
	scroll.size = RUNES_SIZE
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_runes.columns = 3
	_runes.add_theme_constant_override(&"h_separation", GAP)
	_runes.add_theme_constant_override(&"v_separation", GAP)
	scroll.add_child(_runes)
	add_child(scroll)
	_refresh_positions()
	_refresh_slots()


## Shows the slots of [param grimoire_position], 1 to 10; ignored while it is closed.
func pick_position(grimoire_position: int) -> void:
	if grimoire_position < 1 or grimoire_position > _world.status.grimoire_positions:
		return
	_picked_position = grimoire_position
	_picked_slot = -1
	_refresh_positions()
	_refresh_slots()
	_refresh_runes()


## Lists the runes that fit [param slot], a [enum Spell.Slot], of the position shown.
func pick_slot(slot: int) -> void:
	if _picked_position == 0:
		return
	_picked_slot = slot
	_refresh_slots()
	_refresh_runes()


## Asks the server to put [param rune_id] in the slot picked, at common rarity.
func pick_rune(rune_id: StringName) -> void:
	if _picked_position == 0 or _picked_slot < 0:
		return
	_world.edit_spell(_picked_position, _picked_slot, rune_id, Rarity.COMMON)


## Greys out the closed positions; forgets the position shown once it is closed, as for a
## fresh wizard back at level 1.
func _refresh_positions() -> void:
	var open := _world.status.grimoire_positions
	if _picked_position > open:
		_picked_position = 0
		_picked_slot = -1
		_refresh_slots()
		_refresh_runes()
	for i in _position_buttons.size():
		var button := _position_buttons[i]
		button.disabled = i >= open
		_highlight(button, i + 1 == _picked_position)


func _refresh_slots() -> void:
	for slot in _slot_buttons.size():
		var button := _slot_buttons[slot]
		button.visible = _picked_position > 0
		if _picked_position == 0:
			continue
		var rune_id := _world.grimoire[_picked_position - 1].rune_id(slot)
		var held := String(rune_id).capitalize() if not rune_id.is_empty() else "empty"
		button.text = "%s: %s" % [SLOT_NAMES[slot], held]
		_highlight(button, slot == _picked_slot)


func _refresh_runes() -> void:
	for child in _runes.get_children():
		_runes.remove_child(child)
		child.queue_free()
	if _picked_slot < 0:
		return
	for rune_id in RuneCatalog.ids_of(Spell.SLOT_ATTRIBUTES[_picked_slot]):
		var button := _button(String(rune_id).capitalize(), RUNE_SIZE)
		button.pressed.connect(pick_rune.bind(rune_id))
		_runes.add_child(button)


## The picked button's text in the badge colour, the others in the plain one.
func _highlight(button: Button, picked: bool) -> void:
	button.add_theme_color_override(&"font_color", Hud.BADGE_COLOR if picked else Hud.TEXT_COLOR)


func _button(text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = button_size
	button.size = button_size
	button.add_theme_color_override(&"font_color", Hud.TEXT_COLOR)
	button.add_theme_color_override(&"font_hover_color", Hud.TEXT_COLOR)
	button.add_theme_color_override(&"font_disabled_color", Hud.SpellBar.COOLING_TEXT_COLOR)
	for state: StringName in [&"normal", &"hover", &"pressed", &"focus", &"disabled"]:
		var box := StyleBoxFlat.new()
		box.bg_color = Hud.CARD_COLOR
		if state == &"hover":
			box.bg_color = Hud.CARD_COLOR.lightened(0.15)
		elif state == &"disabled":
			box.bg_color = Hud.SpellBar.LOCKED_COLOR
		box.anti_aliasing = false
		button.add_theme_stylebox_override(state, box)
	return button
