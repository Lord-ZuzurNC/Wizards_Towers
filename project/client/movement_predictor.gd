class_name MovementPredictor
extends RefCounted
## Moves the player's own wizard at once, before the server has answered, then corrects.
##
## Every input gets a sequence number and is kept until the server acknowledges it.
## When a state update arrives, the wizard is put back where the server says, and every
## input the server has not applied yet is replayed on top. With no packet lost, the
## replay lands exactly where the prediction already was, so the player sees no jump.
## See TECH_STACK.md, section Netcode.

var room: RoomData
var position := Vector2.ZERO
var speed := Simulation.BASE_SPEED

var _next_sequence := 1
## The inputs the server has not acknowledged yet, as (sequence, direction code).
var _pending: Array[Vector2i] = []


## Starts predicting from where the server placed the wizard.
func start(start_room: RoomData, start_position: Vector2) -> void:
	room = start_room
	position = start_position
	_pending.clear()


## Applies one tick of input locally and remembers it. Returns its sequence number.
func apply_local(code: int) -> int:
	var sequence := _next_sequence
	_next_sequence += 1
	_pending.append(Vector2i(sequence, code))
	position = Movement.step(position, code, speed, room)
	return sequence


## Puts the wizard where the server says it stood after input [param acknowledged], then
## replays the inputs that came after it.
func reconcile(acknowledged: int, server_room: RoomData, server_position: Vector2) -> void:
	while not _pending.is_empty() and _pending[0].x <= acknowledged:
		_pending.pop_front()
	room = server_room
	position = server_position
	for entry in _pending:
		position = Movement.step(position, entry.y, speed, room)


func pending_count() -> int:
	return _pending.size()


## The sequence number of the oldest input among the last [param limit] unacknowledged ones.
func first_unacknowledged(limit: int) -> int:
	return _pending[maxi(0, _pending.size() - limit)].x if not _pending.is_empty() else 0


## The direction codes of the last [param limit] unacknowledged inputs, oldest first.
## Sending a few at once means one lost packet costs nothing: the next one repeats it.
func unacknowledged_codes(limit: int) -> PackedByteArray:
	var codes := PackedByteArray()
	for i in range(maxi(0, _pending.size() - limit), _pending.size()):
		codes.append(_pending[i].y)
	return codes
