class_name WorldChannel
extends Node
## The world's messages between server and client, and nothing else.
##
## An RPC only reaches a node at the same path on both sides, with the same RPC methods.
## This one node, named [code]Channel[/code] under both the [GameServer] and the
## [GameClient], carries every world message and turns it into a signal; the server and
## the client each listen to the half that concerns them.

## A client sent movement inputs. Received on the server only.
signal move_requested(peer_id: int, first_sequence: int, codes: PackedByteArray)
## The server sent the state of the client's room. Received on a client only.
signal room_state_received(
	tick: int,
	room_id: StringName,
	acknowledged: int,
	peer_ids: PackedInt32Array,
	positions: PackedVector2Array,
)


func _init() -> void:
	name = "Channel"


## Client side: sends the last few movement inputs to the server.
func send_move(first_sequence: int, codes: PackedByteArray) -> void:
	request_move.rpc_id(1, first_sequence, codes)


## Server side: sends one client the state of the room its wizard stands in.
func send_room_state(
	peer_id: int,
	tick: int,
	room_id: StringName,
	acknowledged: int,
	peer_ids: PackedInt32Array,
	positions: PackedVector2Array,
) -> void:
	room_state_sync.rpc_id(peer_id, tick, room_id, acknowledged, peer_ids, positions)


## Any client may call this: every argument is checked on the server, see [InputBuffer].
@rpc("any_peer", "call_remote", "unreliable_ordered")
func request_move(first_sequence: int, codes: PackedByteArray) -> void:
	if not multiplayer.is_server():
		return
	move_requested.emit(multiplayer.get_remote_sender_id(), first_sequence, codes)


## Trusted: only the server may call it.
@rpc("authority", "call_remote", "unreliable_ordered")
func room_state_sync(
	tick: int,
	room_id: StringName,
	acknowledged: int,
	peer_ids: PackedInt32Array,
	positions: PackedVector2Array,
) -> void:
	room_state_received.emit(tick, room_id, acknowledged, peer_ids, positions)
