class_name GameClient
extends Node
## Connects to a game server and passes the protocol handshake.
##
## Like [GameServer], it runs its own [SceneMultiplayer] on its own branch of the tree.

## The handshake passed: the session is open.
signal session_started
## The server turned this client away, for the stated reason.
signal session_refused(reason: String)
## The open session ended: the server closed it or the connection dropped.
signal session_ended
## The server could not be reached at all.
signal connection_failed

enum State {
	IDLE,
	CONNECTING,
	IN_SESSION,
	REFUSED,
	FAILED,
}

## The version this client announces. Only tests change it, to play an outdated client.
var protocol_version := Protocol.VERSION
var state := State.IDLE

var _api := SceneMultiplayer.new()
var _peer := ENetMultiplayerPeer.new()


func _exit_tree() -> void:
	leave()
	# The tree keeps a custom multiplayer per branch; a branch that is going away must
	# take its own with it, or the tree goes on polling an API rooted nowhere.
	if get_tree().get_multiplayer(get_path()) == _api:
		get_tree().set_multiplayer(null, get_path())


## Starts connecting. The node must already be in the scene tree.
func join(address: String = "127.0.0.1", port: int = Protocol.DEFAULT_PORT) -> Error:
	var error := _peer.create_client(address, port)
	if error != OK:
		return error
	_api.auth_callback = _on_auth_message
	_api.peer_authenticating.connect(_on_peer_authenticating)
	_api.connected_to_server.connect(_on_connected_to_server)
	_api.connection_failed.connect(_on_connection_failed)
	_api.server_disconnected.connect(_on_server_disconnected)
	get_tree().set_multiplayer(_api, get_path())
	_api.multiplayer_peer = _peer
	state = State.CONNECTING
	return OK


## Closes the connection. Safe to call twice.
func leave() -> void:
	if _api.multiplayer_peer == null:
		return
	_peer.close()
	_api.multiplayer_peer = null
	if state == State.CONNECTING or state == State.IN_SESSION:
		state = State.IDLE


## The server is always peer 1; the handshake opens with this client's hello.
func _on_peer_authenticating(peer_id: int) -> void:
	_api.send_auth(peer_id, Protocol.encode_hello(protocol_version))


func _on_auth_message(peer_id: int, data: PackedByteArray) -> void:
	var message := Protocol.decode_answer(data)
	if message != null and message.answer == Protocol.Answer.ACCEPTED:
		_api.complete_auth(peer_id)
		return
	var reason := "the server's answer could not be read"
	if message != null:
		reason = Protocol.describe_refusal(message.answer, message.server_version, protocol_version)
	# Closing the connection from inside this callback frees what the multiplayer API is
	# still using, and crashes the engine: the client leaves once the callback is over.
	leave.call_deferred()
	state = State.REFUSED
	session_refused.emit(reason)


func _on_connected_to_server() -> void:
	state = State.IN_SESSION
	session_started.emit()


func _on_connection_failed() -> void:
	state = State.FAILED
	connection_failed.emit()


func _on_server_disconnected() -> void:
	if state == State.IN_SESSION:
		state = State.IDLE
		session_ended.emit()
