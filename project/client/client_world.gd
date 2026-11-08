class_name ClientWorld
extends Node2D
## What the player sees of the world: the room, their own wizard, and the others.
##
## The player's wizard is predicted, see [MovementPredictor]. Every other wizard is drawn
## [constant INTERPOLATION_TICKS] simulation ticks in the past, between two positions
## already received, so a late or lost update never makes it stutter (TECH_STACK.md,
## Netcode).
##
## The room and the wizards are flat coloured shapes from the BLK NX64 palette, standing in
## until their art exists.

## How far in the past other wizards are drawn: 3 ticks, 100 ms.
const INTERPOLATION_TICKS := 3.0
const WALL_COLOR := Color("12173d")
const FLOOR_COLOR := Color("293268")
const EXIT_COLOR := Color("3e83d1")
const OWN_COLOR := Color("ffaa6e")
const OTHER_COLOR := Color("8cff9b")
## A correction larger than this, in pixels, is a jump rather than a nudge: the wizard is
## placed there at once instead of gliding.
const SNAP_DISTANCE := 8.0

## Rooms by id. Loaded from [constant RoomCatalog.DEFAULT_FOLDER] unless a test sets them.
var rooms: Dictionary[StringName, RoomData] = { }
## Stands in for the keyboard when set to a direction code from 0 to 8; tests use it.
var input_override := -1
var room: RoomData

var _channel: WorldChannel
var _own_peer_id := 0
var _predictor := MovementPredictor.new()
var _own_marker: WizardMarker
var _others: Dictionary[int, WizardMarker] = { }
var _latest_tick := 0
var _render_tick := 0.0


func _init() -> void:
	name = "World"


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


## Connects the world to its channel, once the session has started.
func setup(channel: WorldChannel, own_peer_id: int) -> void:
	_channel = channel
	_own_peer_id = own_peer_id
	_channel.room_state_received.connect(_on_room_state_received)
	if rooms.is_empty():
		rooms = RoomCatalog.load_folder()


## Where the player's own wizard stands, as predicted. For tests and the HUD.
func own_position() -> Vector2:
	return _predictor.position


## The peer ids of the other wizards drawn in the current room.
func other_peer_ids() -> Array[int]:
	var ids: Array[int] = []
	ids.assign(_others.keys())
	return ids


func _read_input() -> int:
	if input_override >= 0:
		return input_override
	var direction := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	return Movement.encode(Vector2i(signi(roundi(direction.x)), signi(roundi(direction.y))))


func _on_room_state_received(
	tick: int,
	room_id: StringName,
	acknowledged: int,
	peer_ids: PackedInt32Array,
	positions: PackedVector2Array,
) -> void:
	if tick <= _latest_tick or not rooms.has(room_id) or peer_ids.size() != positions.size():
		return
	_latest_tick = tick
	if rooms[room_id] != room:
		_enter_room(rooms[room_id])
	for i in peer_ids.size():
		if peer_ids[i] == _own_peer_id:
			_reconcile(acknowledged, positions[i])
		else:
			_other_marker(peer_ids[i]).add_sample(tick, positions[i])
	for peer_id: int in _others.keys():
		if not peer_ids.has(peer_id):
			_others[peer_id].queue_free()
			_others.erase(peer_id)


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
