class_name Protocol
extends RefCounted
## What a client and a server must agree on before a session starts.
##
## The handshake runs in the authentication phase of [SceneMultiplayer], before any RPC
## can reach the server. The client sends a hello carrying its protocol version, and the
## server answers that it is accepted or refused. A client one version behind is refused,
## because it would corrupt a world shared with everyone else (TECH_STACK.md, Protocol
## version).
##
## Messages are small fixed-size binary records. Their size and their magic number are
## checked before anything is read, so a malformed or hostile message is turned away
## without raising an engine error.

enum Answer {
	ACCEPTED = 1,
	REFUSED_VERSION = 2,
	REFUSED_MALFORMED = 3,
}

## Bumped whenever a message shape or a persisted field changes.
## 2: movement inputs and room state updates.
## 3: casting, cards, gold and villages; the state update carries them all.
## 4: ten Grimoire positions, their cooldowns, and which one each projectile came from.
## 5: seasons, hazards and their effects, and the end of a run.
const VERSION := 5
const DEFAULT_PORT := 7777
## Sized for fifty wizards a world, see TECH_STACK.md.
const MAX_CONNECTIONS := 50
## A movement message carries at most this many inputs; anything longer is refused.
const MAX_INPUTS_PER_MESSAGE := 8
## How many of its latest unacknowledged inputs a client repeats in each message.
const INPUTS_SENT_PER_MESSAGE := 5

## Opens every message, so stray traffic is told apart from ours: "WTWT" in ASCII.
const _MAGIC := 0x5754_5754
## Magic (4 bytes) and version (4 bytes).
const _HELLO_SIZE := 8
## Magic (4 bytes), answer (1 byte) and the server's version (4 bytes).
const _ANSWER_SIZE := 9


## The client's first message: its protocol version.
static func encode_hello(version: int) -> PackedByteArray:
	var data := PackedByteArray()
	data.resize(_HELLO_SIZE)
	data.encode_u32(0, _MAGIC)
	data.encode_s32(4, version)
	return data


## Reads a hello. Returns the version it carries, or -1 when the message is malformed.
static func decode_hello(data: PackedByteArray) -> int:
	if data.size() != _HELLO_SIZE or data.decode_u32(0) != _MAGIC:
		return -1
	return data.decode_s32(4)


## The server's decision on a hello it received.
static func answer_hello(data: PackedByteArray) -> Answer:
	var version := decode_hello(data)
	if version < 0:
		return Answer.REFUSED_MALFORMED
	if version != VERSION:
		return Answer.REFUSED_VERSION
	return Answer.ACCEPTED


## The server's reply, carrying its own version so a refused client can say what it needs.
static func encode_answer(answer: Answer, server_version: int) -> PackedByteArray:
	var data := PackedByteArray()
	data.resize(_ANSWER_SIZE)
	data.encode_u32(0, _MAGIC)
	data.encode_u8(4, answer)
	data.encode_s32(5, server_version)
	return data


## Reads the server's reply. Returns null when the message is malformed.
static func decode_answer(data: PackedByteArray) -> AnswerMessage:
	if data.size() != _ANSWER_SIZE or data.decode_u32(0) != _MAGIC:
		return null
	var answer := data.decode_u8(4)
	if not Answer.values().has(answer):
		return null
	var message := AnswerMessage.new()
	message.answer = answer as Answer
	message.server_version = data.decode_s32(5)
	return message


## A sentence a player can read, for a refused handshake.
static func describe_refusal(answer: Answer, server_version: int, client_version: int) -> String:
	match answer:
		Answer.REFUSED_VERSION:
			return (
				"version mismatch: the server speaks protocol %d, this client %d"
				% [server_version, client_version]
			)
		Answer.REFUSED_MALFORMED:
			return "the server could not read this client's hello"
	return "refused for no stated reason"


## The server's reply, once read.
class AnswerMessage:
	var answer := Answer.REFUSED_MALFORMED
	var server_version := -1
