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
## Received on the server: a client whose wizard is dead asked to start again as a newcomer.
signal respawn_requested(peer_id: int)
## Received on the server: a client asked to buy a village of the room it stands in, once
## its movement input [param after_sequence] has been applied.
signal buy_village_requested(peer_id: int, village_index: int, after_sequence: int)
## Received on the server: a client asked to put a rune in one slot of one Grimoire
## position. [param slot] is a [enum Spell.Slot]; [param grade] a [Rarity].
signal edit_spell_requested(
	peer_id: int,
	grimoire_position: int,
	slot: int,
	rune_id: StringName,
	grade: int,
)
## Received on a client: the state after a simulation tick. Malformed ones never arrive.
signal state_update_received(update: StateUpdate)
## Received on a client: the run ended, and how.
signal world_ending_received(ending: int)
## Received on a client: a new world began on a world map grown from [param map_seed];
## the client grows the same one with [method WorldMapGenerator.regrow].
signal world_map_regrown_received(map_seed: int)
## Received on a client: its own wizard died, and how.
signal wizard_died_received(ending: int)
## Received on a client: its card choices changed.
signal card_choices_received(pending: int, card_ids: PackedStringArray)
## Received on a client: an edit of its own Grimoire was accepted. A rejected edit gets no
## message; the client already predicted it, and corrects on the next try.
signal spell_edited_received(grimoire_position: int, slot: int, rune_id: StringName, grade: int)


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
func send_respawn() -> void:
	request_respawn.rpc_id(1)


## Client side.
func send_buy_village(village_index: int, after_sequence: int) -> void:
	request_buy_village.rpc_id(1, village_index, after_sequence)


## Server side.
func send_state_update(peer_id: int, update: StateUpdate) -> void:
	state_update_sync.rpc_id(peer_id, update.to_message())


## Server side: the run is over, ended as [param ending], a [enum WorldEnding.Kind].
func send_world_ending(peer_id: int, ending: int) -> void:
	world_ending_sync.rpc_id(peer_id, ending)


## Server side: the world map was grown from [param map_seed].
func send_world_map_regrown(peer_id: int, map_seed: int) -> void:
	world_map_regrown_sync.rpc_id(peer_id, map_seed)


## Server side: [param peer_id]'s wizard died, as [param ending], a [enum WizardEnding.Kind].
func send_wizard_died(peer_id: int, ending: int) -> void:
	wizard_died_sync.rpc_id(peer_id, ending)


## Server side: the number of choices waiting, and the cards of the oldest one.
func send_card_choices(peer_id: int, pending: int, card_ids: PackedStringArray) -> void:
	card_choices_sync.rpc_id(peer_id, pending, card_ids)


## Server side: [param peer_id]'s edit of [param grimoire_position] was accepted.
func send_spell_edited(
	peer_id: int,
	grimoire_position: int,
	slot: int,
	rune_id: StringName,
	grade: int,
) -> void:
	spell_edited_sync.rpc_id(peer_id, grimoire_position, slot, rune_id, grade)


## Client side: put rune [param rune_id] at [Rarity] [param grade] in [param slot] of
## Grimoire position [param grimoire_position].
func send_edit_spell(grimoire_position: int, slot: int, rune_id: StringName, grade: int) -> void:
	request_edit_spell.rpc_id(1, grimoire_position, slot, rune_id, grade)


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
func request_respawn() -> void:
	if multiplayer.is_server():
		respawn_requested.emit(multiplayer.get_remote_sender_id())


@rpc("any_peer", "call_remote", "reliable")
func request_buy_village(village_index: int, after_sequence: int) -> void:
	if multiplayer.is_server():
		var sender := multiplayer.get_remote_sender_id()
		buy_village_requested.emit(sender, village_index, after_sequence)


@rpc("any_peer", "call_remote", "reliable")
func request_edit_spell(grimoire_position: int, slot: int, rune_id: StringName, grade: int) -> void:
	if multiplayer.is_server():
		var sender := multiplayer.get_remote_sender_id()
		edit_spell_requested.emit(sender, grimoire_position, slot, rune_id, grade)


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


## Trusted: only the server may call it.
@rpc("authority", "call_remote", "reliable")
func world_map_regrown_sync(map_seed: int) -> void:
	world_map_regrown_received.emit(map_seed)


## Trusted: only the server may call it.
@rpc("authority", "call_remote", "reliable")
func wizard_died_sync(ending: int) -> void:
	if ending >= 0 and ending < WizardEnding.NAMES.size():
		wizard_died_received.emit(ending)


## Trusted: only the server may call it.
@rpc("authority", "call_remote", "reliable")
func spell_edited_sync(grimoire_position: int, slot: int, rune_id: StringName, grade: int) -> void:
	spell_edited_received.emit(grimoire_position, slot, rune_id, grade)
