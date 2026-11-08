class_name ClientWorld
extends Node2D
## What the player sees of the world: the room, the wizards, the dummies, the spells and
## the villages.
##
## The player's wizard is predicted, see [MovementPredictor]. Every other wizard is drawn
## [constant INTERPOLATION_TICKS] simulation ticks in the past, between two positions
## already received, so a late or lost update never makes it stutter (TECH_STACK.md,
## Netcode). Spells and dummies are drawn where the last update put them: nothing about
## them is predicted.
##
## Everything is a flat coloured shape from the BLK NX64 palette, standing in until its art
## exists.

## The player's own numbers changed: health, mana, level or XP.
signal status_changed
## The pending card choices changed.
signal card_choices_changed

## How far in the past other wizards are drawn: 3 ticks, 100 ms.
const INTERPOLATION_TICKS := 3.0
const WALL_COLOR := Color("12173d")
const FLOOR_COLOR := Color("293268")
const EXIT_COLOR := Color("3e83d1")
const OWN_COLOR := Color("ffaa6e")
const OTHER_COLOR := Color("8cff9b")
const DUMMY_COLOR := Color("cdc599")
const HEALTH_COLOR := Color("ff695a")
const SPELL_COLOR := Color("ff695a")
const VILLAGE_WALL_COLOR := Color("895654")
const VILLAGE_ROOF_COLOR := Color("b23c40")
## The flag under a village no one holds; a held one flies its holder's colour.
const FREE_FLAG_COLOR := Color("909edd")
## A village drawn around its tile centre: walls, then a roof on top.
const VILLAGE_WALLS := Rect2(-10.0, -6.0, 20.0, 12.0)
const VILLAGE_ROOF := Rect2(-12.0, -12.0, 24.0, 6.0)
const VILLAGE_FLAG := Rect2(-10.0, 7.0, 20.0, 2.0)
## A correction larger than this, in pixels, is a jump rather than a nudge: the wizard is
## placed there at once instead of gliding.
const SNAP_DISTANCE := 8.0

## Rooms by id. Loaded from [constant RoomCatalog.DEFAULT_FOLDER] unless a test sets them.
var rooms: Dictionary[StringName, RoomData] = { }
## Cards by id, to show a choice. Loaded from [constant CardCatalog.DEFAULT_FOLDER] unless a
## test sets them.
var cards: Dictionary[StringName, Card] = { }
## Every number the design has not settled; see [PlaceholderValues]. The client needs the
## village reach to say when a village can be bought.
var values: PlaceholderValues
## Stands in for the keyboard when set to a direction code from 0 to 8; tests use it.
var input_override := -1
var room: RoomData
## The latest numbers the server sent about the player's own wizard.
var status := StateUpdate.new()
## How many card choices wait to be opened.
var pending_choices := 0
## The cards of the oldest waiting choice, the one opened next.
var offered_cards: Array[Card] = []

var _channel: WorldChannel
var _own_peer_id := 0
var _predictor := MovementPredictor.new()
var _own_marker: WizardMarker
var _others: Dictionary[int, WizardMarker] = { }
var _overlay := Overlay.new()
var _village_owners: PackedInt32Array = []
var _latest_tick := 0
var _render_tick := 0.0


func _init() -> void:
	name = "World"
	_overlay.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	_overlay.z_index = 2
	add_child(_overlay)


func _process(delta: float) -> void:
	if _latest_tick == 0:
		return
	_render_tick += delta * Simulation.TICK_RATE
	var target := _latest_tick - INTERPOLATION_TICKS
	if absf(_render_tick - target) > INTERPOLATION_TICKS * 2.0:
		_render_tick = target
	for marker: WizardMarker in _others.values():
		marker.position = marker.position_at(_render_tick)


func _physics_process(_delta: float) -> void:
	if _predictor.room == null:
		return
	_predictor.apply_local(_read_input())
	_channel.send_move(
		_predictor.first_unacknowledged(Protocol.INPUTS_SENT_PER_MESSAGE),
		_predictor.unacknowledged_codes(Protocol.INPUTS_SENT_PER_MESSAGE),
	)
	_own_marker.position = _predictor.position
	if input_override < 0 and Input.is_action_just_pressed(&"cast_1"):
		cast(get_global_mouse_position() - (_predictor.position + Projectile.BODY_OFFSET))
	if input_override < 0 and Input.is_action_just_pressed(&"interact"):
		var village := village_in_reach()
		if village >= 0:
			buy_village(village)


func _draw() -> void:
	if room == null:
		return
	var tile := Vector2(Simulation.TILE_SIZE, Simulation.TILE_SIZE)
	var size := room.size()
	for y in size.y:
		for x in size.x:
			var color := WALL_COLOR if room.is_solid(Vector2i(x, y)) else FLOOR_COLOR
			draw_rect(Rect2(Vector2(x, y) * tile, tile), color)
	for room_exit in room.exits:
		draw_rect(
			Rect2(Vector2(room_exit.area.position) * tile, Vector2(room_exit.area.size) * tile),
			EXIT_COLOR,
		)
	for i in room.villages.size():
		var at := room.tile_center(room.villages[i].tile)
		draw_rect(Rect2(at + VILLAGE_WALLS.position, VILLAGE_WALLS.size), VILLAGE_WALL_COLOR)
		draw_rect(Rect2(at + VILLAGE_ROOF.position, VILLAGE_ROOF.size), VILLAGE_ROOF_COLOR)
		draw_rect(Rect2(at + VILLAGE_FLAG.position, VILLAGE_FLAG.size), _flag_color(i))


## Connects the world to its channel, once the session has started.
func setup(channel: WorldChannel, own_peer_id: int) -> void:
	_channel = channel
	_own_peer_id = own_peer_id
	_channel.state_update_received.connect(_on_state_update_received)
	_channel.card_choices_received.connect(_on_card_choices_received)
	if rooms.is_empty():
		rooms = RoomCatalog.load_folder()
	if cards.is_empty():
		cards = CardCatalog.load_folder()
	if values == null:
		values = PlaceholderValues.load_default()


## Asks the server to cast the spell of Grimoire position 1 toward [param aim].
## Nothing appears until the server accepts it.
func cast(aim: Vector2) -> void:
	if _channel != null:
		_channel.send_cast(1, aim)


## Asks the server to buy village [param index] of the current room. Nothing changes until
## the server accepts it.
func buy_village(index: int) -> void:
	if _channel != null:
		_channel.send_buy_village(index, _predictor.last_sequence())


## The nearest village of the room within reach of the player's wizard, or -1.
func village_in_reach() -> int:
	if room == null or values == null:
		return -1
	var reach := values.village_reach_tiles * Simulation.TILE_SIZE
	var nearest := -1
	var nearest_distance := INF
	for i in room.villages.size():
		var distance := _predictor.position.distance_to(room.tile_center(room.villages[i].tile))
		if distance <= reach and distance < nearest_distance:
			nearest = i
			nearest_distance = distance
	return nearest


## What pressing the key would do for village [param index], by the server's own rules.
func village_verdict(index: int) -> VillagePurchase.Verdict:
	return VillagePurchase.judge(
		_predictor.position.distance_to(room.tile_center(room.villages[index].tile)),
		values.village_reach_tiles * Simulation.TILE_SIZE,
		village_owner(index),
		status.wizard_level,
		status.villages_held,
		status.gold,
		status.village_price,
	)


## The peer id holding village [param index] of the room, as last received; 0 for none.
func village_owner(index: int) -> int:
	return _village_owners[index] if index < _village_owners.size() else 0


## Whether village [param index] of the room is the player's.
func owns_village(index: int) -> bool:
	return village_owner(index) == _own_peer_id


## Takes card [param index] of the oldest waiting choice.
func take_card(index: int) -> void:
	if _channel != null and pending_choices > 0:
		_channel.send_take_card(index)


## Where the player's own wizard stands, as predicted.
func own_position() -> Vector2:
	return _predictor.position


## The peer ids of the other wizards drawn in the current room.
func other_peer_ids() -> Array[int]:
	var ids: Array[int] = []
	ids.assign(_others.keys())
	return ids


## The health of each training dummy in the room, as last received; 0 is destroyed.
func dummy_health() -> PackedInt32Array:
	return _overlay.dummy_health


## Where the spells in flight were, as last received.
func projectile_positions() -> PackedVector2Array:
	return _overlay.projectile_positions


func _read_input() -> int:
	if input_override >= 0:
		return input_override
	var direction := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	return Movement.encode(Vector2i(signi(roundi(direction.x)), signi(roundi(direction.y))))


func _on_state_update_received(update: StateUpdate) -> void:
	if update.tick <= _latest_tick or not rooms.has(update.room_id):
		return
	_latest_tick = update.tick
	if rooms[update.room_id] != room:
		_enter_room(rooms[update.room_id])
	for i in update.wizard_ids.size():
		if update.wizard_ids[i] == _own_peer_id:
			_reconcile(update.acknowledged, update.wizard_positions[i])
		else:
			_other_marker(update.wizard_ids[i]).add_sample(update.tick, update.wizard_positions[i])
	for peer_id: int in _others.keys():
		if not update.wizard_ids.has(peer_id):
			_others[peer_id].queue_free()
			_others.erase(peer_id)
	_overlay.show_update(update)
	if update.village_owners != _village_owners:
		_village_owners = update.village_owners
		queue_redraw()
	status = update
	status_changed.emit()


func _on_card_choices_received(pending: int, card_ids: PackedStringArray) -> void:
	pending_choices = maxi(0, pending)
	offered_cards.clear()
	for id in card_ids:
		if cards.has(id):
			offered_cards.append(cards[id])
	card_choices_changed.emit()


func _flag_color(index: int) -> Color:
	var holder := village_owner(index)
	if holder == 0:
		return FREE_FLAG_COLOR
	return OWN_COLOR if holder == _own_peer_id else OTHER_COLOR


func _enter_room(new_room: RoomData) -> void:
	var first_room := room == null
	room = new_room
	for marker: WizardMarker in _others.values():
		marker.queue_free()
	_others.clear()
	if first_room:
		_own_marker = WizardMarker.new(OWN_COLOR)
		# Drawn above the others, so the player never loses sight of their own wizard.
		_own_marker.z_index = 1
		add_child(_own_marker)
	queue_redraw()


func _reconcile(acknowledged: int, server_position: Vector2) -> void:
	var before := _predictor.position
	if _predictor.room == null:
		_predictor.start(room, server_position)
	else:
		_predictor.reconcile(acknowledged, room, server_position)
	if before.distance_to(_predictor.position) > SNAP_DISTANCE:
		_own_marker.position = _predictor.position
		_own_marker.reset_physics_interpolation()


func _other_marker(peer_id: int) -> WizardMarker:
	if not _others.has(peer_id):
		var marker := WizardMarker.new(OTHER_COLOR)
		# Moved every frame from interpolated positions, not by the physics tick.
		marker.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
		add_child(marker)
		_others[peer_id] = marker
	return _others[peer_id]


## A wizard on screen: a coloured block standing on its position, and, for others, the
## positions received for it, to draw it between two of them.
class WizardMarker:
	extends Node2D

	## The body drawn above the feet, which stand at the node's position.
	const BODY := Rect2(-6.0, -18.0, 12.0, 20.0)
	const KEPT_SAMPLES := 10

	var color: Color
	## (tick, position) pairs, oldest first.
	var _ticks: PackedFloat32Array = []
	var _positions: PackedVector2Array = []


	func _init(marker_color: Color) -> void:
		color = marker_color


	func _draw() -> void:
		draw_rect(BODY, color)


	func add_sample(tick: int, sample_position: Vector2) -> void:
		if _positions.is_empty():
			position = sample_position
		_ticks.append(tick)
		_positions.append(sample_position)
		if _ticks.size() > KEPT_SAMPLES:
			_ticks.remove_at(0)
			_positions.remove_at(0)


	## The position at [param tick], between the two samples around it; the nearest
	## sample when [param tick] lies outside them.
	func position_at(tick: float) -> Vector2:
		if _positions.is_empty():
			return position
		if tick <= _ticks[0]:
			return _positions[0]
		for i in range(1, _ticks.size()):
			if tick <= _ticks[i]:
				var weight := (tick - _ticks[i - 1]) / (_ticks[i] - _ticks[i - 1])
				return _positions[i - 1].lerp(_positions[i], weight)
		return _positions[-1]


## Training dummies, with a health bar, and spells in flight, as the last update had them.
class Overlay:
	extends Node2D

	const DUMMY_BODY := Rect2(-7.0, -20.0, 14.0, 22.0)
	const BAR := Rect2(-8.0, -25.0, 16.0, 2.0)
	const SPELL := Rect2(-2.0, -2.0, 4.0, 4.0)

	var dummy_positions: PackedVector2Array = []
	var dummy_health: PackedInt32Array = []
	var dummy_max_health: PackedInt32Array = []
	var projectile_positions: PackedVector2Array = []


	func _draw() -> void:
		for i in dummy_positions.size():
			if dummy_health[i] <= 0:
				continue
			var at := dummy_positions[i]
			draw_rect(Rect2(at + DUMMY_BODY.position, DUMMY_BODY.size), DUMMY_COLOR)
			var share := float(dummy_health[i]) / maxi(1, dummy_max_health[i])
			draw_rect(Rect2(at + BAR.position, BAR.size), WALL_COLOR)
			draw_rect(
				Rect2(at + BAR.position, Vector2(BAR.size.x * share, BAR.size.y)),
				HEALTH_COLOR,
			)
		for at in projectile_positions:
			draw_rect(Rect2(at + SPELL.position, SPELL.size), SPELL_COLOR)


	func show_update(update: StateUpdate) -> void:
		dummy_positions = update.dummy_positions
		dummy_health = update.dummy_health
		dummy_max_health = update.dummy_max_health
		projectile_positions = update.projectile_positions
		queue_redraw()
