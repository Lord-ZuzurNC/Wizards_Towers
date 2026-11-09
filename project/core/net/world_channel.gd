class_name WorldChannel
extends Node
## The world's messages between server and client, and nothing else.
##
## An RPC only reaches a node at the same path on both sides, with the same RPC methods.
## This one node, named [code]Channel[/code] under both the [GameServer] and the
## [GameClient], carries every world message and turns it into a signal; the server and
## the client each listen to the half that concerns them.
## Every [code]request_[/code] may come from any client: the server checks its arguments.

## Received on the server: a client sent movement inputs.
signal move_requested(peer_id: int, first_sequence: int, codes: PackedByteArray)
## Received on the server: a client asked to cast the spell in a Grimoire position.
signal cast_requested(peer_id: int, grimoire_position: int, aim: Vector2)
## Received on the server: a client took a card from its oldest card choice.
signal take_card_requested(peer_id: int, card_index: int)
## Received on the server: a client asked to buy a village of the room it stands in, once
## its movement input [param after_sequence] has been applied.
signal buy_village_requested(peer_id: int, village_index: int, after_sequence: int)
## Received on a client: the state after a simulation tick. Malformed ones never arrive.
signal state_update_received(update: StateUpdate)
## Received on a client: the run ended, and how.
signal world_ending_received(ending: int)
## Received on a client: its card choices changed.
signal card_choices_received(pending: int, card_ids: PackedStringArray)


func _init() -> void:
	name = "Channel"


## Client side.
func send_move(first_sequence: int, codes: PackedByteArray) -> void:
	request_move.rpc_id(1, first_sequence, codes)


## Client side.
func send_cast(grimoire_position: int, aim: Vector2) -> void:
	request_cast.rpc_id(1, grimoire_position, aim)


## Client side.
func send_take_card(card_index: int) -> void:
	request_take_card.rpc_id(1, card_index)


## Client side.
func send_buy_village(village_index: int, after_sequence: int) -> void:
	request_buy_village.rpc_id(1, village_index, after_sequence)


## Server side.
func send_state_update(peer_id: int, update: StateUpdate) -> void:
	state_update_sync.rpc_id(peer_id, update.to_message())


## Server side: the run is over, ended as [param ending], a [enum WorldEnding.Kind].
func send_world_ending(peer_id: int, ending: int) -> void:
	world_ending_sync.rpc_id(peer_id, ending)


## Server side: the number of choices waiting, and the cards of the oldest one.
func send_card_choices(peer_id: int, pending: int, card_ids: PackedStringArray) -> void:
	card_choices_sync.rpc_id(peer_id, pending, card_ids)


@rpc("any_peer", "call_remote", "unreliable_ordered")
func request_move(first_sequence: int, codes: PackedByteArray) -> void:
	if multiplayer.is_server():
		move_requested.emit(multiplayer.get_remote_sender_id(), first_sequence, codes)


@rpc("any_peer", "call_remote", "reliable")
func request_cast(grimoire_position: int, aim: Vector2) -> void:
	if multiplayer.is_server():
		cast_requested.emit(multiplayer.get_remote_sender_id(), grimoire_position, aim)


@rpc("any_peer", "call_remote", "reliable")
func request_take_card(card_index: int) -> void:
	if multiplayer.is_server():
		take_card_requested.emit(multiplayer.get_remote_sender_id(), card_index)


@rpc("any_peer", "call_remote", "reliable")
func request_buy_village(village_index: int, after_sequence: int) -> void:
	if multiplayer.is_server():
		var sender := multiplayer.get_remote_sender_id()
		buy_village_requested.emit(sender, village_index, after_sequence)


## Trusted: only the server may call it.
@rpc("authority", "call_remote", "unreliable_ordered")
func state_update_sync(message: Array) -> void:
	var update := StateUpdate.from_message(message)
	if update != null:
		state_update_received.emit(update)


## Trusted: only the server may call it.
@rpc("authority", "call_remote", "reliable")
func card_choices_sync(pending: int, card_ids: PackedStringArray) -> void:
	card_choices_received.emit(pending, card_ids)


## Trusted: only the server may call it.
@rpc("authority", "call_remote", "reliable")
func world_ending_sync(ending: int) -> void:
	if ending >= 0 and ending < WorldEnding.NAMES.size():
		world_ending_received.emit(ending)
