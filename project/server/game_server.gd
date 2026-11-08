class_name GameServer
extends Node
## The authoritative world process: listens for clients and admits those that speak the
## same protocol.
##
## It runs its own [SceneMultiplayer] on its own branch of the scene tree, so a server and
## a client can share one process. That is how the tests run them, and it costs nothing
## when the server runs alone.

## A client passed the handshake; from now on it may send requests.
signal session_started(peer_id: int)
signal session_ended(peer_id: int)
## A client was turned away during the handshake, for the stated reason.
signal session_refused(peer_id: int, reason: String)

## How long a refused client keeps its connection, so the answer reaches it before the drop.
const REFUSAL_GRACE_SECONDS := 0.5

var _api := SceneMultiplayer.new()
var _peer := ENetMultiplayerPeer.new()
var _sessions: Array[int] = []
## Peers answered with a refusal and waiting to be dropped.
var _refused: Dictionary[int, bool] = { }


func _exit_tree() -> void:
	stop()
	# The tree keeps a custom multiplayer per branch; a branch that is going away must
	# take its own with it, or the tree goes on polling an API rooted nowhere.
	if get_tree().get_multiplayer(get_path()) == _api:
		get_tree().set_multiplayer(null, get_path())


## Starts listening. The node must already be in the scene tree.
func start(port: int = Protocol.DEFAULT_PORT) -> Error:
	var error := _peer.create_server(port, Protocol.MAX_CONNECTIONS)
	if error != OK:
		return error
	_api.auth_callback = _on_auth_message
	_api.peer_connected.connect(_on_peer_connected)
	_api.peer_disconnected.connect(_on_peer_disconnected)
	_api.peer_authentication_failed.connect(_on_peer_authentication_failed)
	get_tree().set_multiplayer(_api, get_path())
	_api.multiplayer_peer = _peer
	return OK


## Closes every connection and stops listening. Safe to call twice.
func stop() -> void:
	if _api.multiplayer_peer == null:
		return
	_peer.close()
	_api.multiplayer_peer = null
	_sessions.clear()
	_refused.clear()


func session_count() -> int:
	return _sessions.size()


func _on_auth_message(peer_id: int, data: PackedByteArray) -> void:
	if _refused.has(peer_id):
		return # already answered; a refused client gets nothing more
	var answer := Protocol.answer_hello(data)
	_api.send_auth(peer_id, Protocol.encode_answer(answer, Protocol.VERSION))
	if answer == Protocol.Answer.ACCEPTED:
		_api.complete_auth(peer_id)
		return
	_refused[peer_id] = true
	var reason := Protocol.describe_refusal(answer, Protocol.VERSION, Protocol.decode_hello(data))
	session_refused.emit(peer_id, reason)
	get_tree().create_timer(REFUSAL_GRACE_SECONDS).timeout.connect(_drop_refused.bind(peer_id))


func _drop_refused(peer_id: int) -> void:
	if _refused.erase(peer_id):
		_peer.disconnect_peer(peer_id)


func _on_peer_connected(peer_id: int) -> void:
	_sessions.append(peer_id)
	session_started.emit(peer_id)


func _on_peer_disconnected(peer_id: int) -> void:
	if _sessions.has(peer_id):
		_sessions.erase(peer_id)
		session_ended.emit(peer_id)


## A peer left, or timed out, before finishing the handshake.
func _on_peer_authentication_failed(peer_id: int) -> void:
	_refused.erase(peer_id)
