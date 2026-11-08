class_name InputBuffer
extends RefCounted
## One wizard's movement inputs, waiting for the server to apply them, one per tick.
##
## Clients send their last few inputs in every packet, so most arrive more than once:
## only sequence numbers never seen before are kept. Applying one input per tick, from a
## queue of bounded length, means a client sending faster than the tick rate cannot walk
## faster than everyone else.

## Inputs waiting at most; past this the oldest are dropped.
const MAX_QUEUED := 8

## The sequence number of the last input applied, reported back to the client.
var last_applied := 0

var _last_received := 0
## (sequence, direction code), oldest first.
var _queue: Array[Vector2i] = []


## Takes in a packet of inputs. Returns false, and keeps nothing, if any part is invalid.
func receive(first_sequence: int, codes: PackedByteArray) -> bool:
	if first_sequence < 1 or codes.is_empty() or codes.size() > Protocol.MAX_INPUTS_PER_MESSAGE:
		return false
	for code in codes:
		if code > Movement.MAX_CODE:
			return false
	for i in codes.size():
		var sequence := first_sequence + i
		if sequence > _last_received:
			_queue.append(Vector2i(sequence, codes[i]))
			_last_received = sequence
	while _queue.size() > MAX_QUEUED:
		_queue.pop_front()
	return true


## The next input to apply, or -1 when none is waiting.
func take() -> int:
	if _queue.is_empty():
		return -1
	var entry: Vector2i = _queue.pop_front()
	last_applied = entry.x
	return entry.y
