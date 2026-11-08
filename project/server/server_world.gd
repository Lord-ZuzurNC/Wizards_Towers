class_name ServerWorld
extends Node
## The authoritative world: where every wizard stands, advanced one simulation tick at a
## time.
##
## Each tick it applies at most one movement input per wizard, moves wizards through
## exits, then sends every client the state of the room its wizard stands in, with the
## sequence number of the last input it applied so the client can reconcile.

## Rooms by id. Loaded from [constant RoomCatalog.DEFAULT_FOLDER] unless a test sets them.
var rooms: Dictionary[StringName, RoomData] = { }
## The room every new wizard starts in.
var start_room := &"first_room"
var tick := 0

var _channel: WorldChannel
var _wizards: Dictionary[int, WizardState] = { }


func _init() -> void:
	name = "World"


func _physics_process(_delta: float) -> void:
	tick += 1
	for wizard: WizardState in _wizards.values():
		_advance(wizard)
	_send_room_states()


## Connects the world to the channel its messages travel on. Loads the rooms if no one
## set them. Returns false when the start room is missing.
func setup(channel: WorldChannel) -> bool:
	_channel = channel
	_channel.move_requested.connect(_on_move_requested)
	if rooms.is_empty():
		rooms = RoomCatalog.load_folder()
	if not rooms.has(start_room):
		push_error("the start room '%s' does not exist" % start_room)
		return false
	return true


func add_wizard(peer_id: int) -> void:
	var wizard := WizardState.new()
	wizard.room_id = start_room
	wizard.position = rooms[start_room].tile_center(rooms[start_room].spawn_tile)
	_wizards[peer_id] = wizard


func remove_wizard(peer_id: int) -> void:
	_wizards.erase(peer_id)


func has_wizard(peer_id: int) -> bool:
	return _wizards.has(peer_id)


func wizard_position(peer_id: int) -> Vector2:
	return _wizards[peer_id].position


func wizard_room(peer_id: int) -> StringName:
	return _wizards[peer_id].room_id


func _advance(wizard: WizardState) -> void:
	var code := wizard.inputs.take()
	if code < 0:
		return
	var room := rooms[wizard.room_id]
	wizard.position = Movement.step(wizard.position, code, wizard.speed, room)
	var room_exit := room.exit_at(wizard.position)
	if room_exit != null:
		wizard.room_id = room_exit.target_room
		wizard.position = rooms[wizard.room_id].tile_center(room_exit.target_tile)


func _send_room_states() -> void:
	var by_room: Dictionary[StringName, Array] = { }
	for peer_id: int in _wizards:
		var room_id := _wizards[peer_id].room_id
		if not by_room.has(room_id):
			by_room[room_id] = []
		by_room[room_id].append(peer_id)
	for room_id: StringName in by_room:
		var peer_ids := PackedInt32Array(by_room[room_id])
		var positions := PackedVector2Array()
		for peer_id in peer_ids:
			positions.append(_wizards[peer_id].position)
		for peer_id in peer_ids:
			var acknowledged := _wizards[peer_id].inputs.last_applied
			_channel.send_room_state(peer_id, tick, room_id, acknowledged, peer_ids, positions)


func _on_move_requested(peer_id: int, first_sequence: int, codes: PackedByteArray) -> void:
	if _wizards.has(peer_id):
		_wizards[peer_id].inputs.receive(first_sequence, codes)


## What the server knows of one wizard.
class WizardState:
	var room_id: StringName
	var position := Vector2.ZERO
	var speed := Simulation.BASE_SPEED
	var inputs := InputBuffer.new()
