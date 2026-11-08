extends Node
## The entry point: becomes a game server or a client, from how the game was started.
##
## A dedicated-server export is always a server. Any other build is a client, unless it
## was started with [code]--server[/code]; see [LaunchOptions] for every option.
## For development, [code]server/run-server.sh[/code] starts a headless server.

var _status: Label
var _hud: Hud


func _ready() -> void:
	var options := LaunchOptions.parse(OS.get_cmdline_user_args())
	for error in options.errors:
		printerr(error)
	if not options.errors.is_empty():
		get_tree().quit(2)
		return
	if OS.has_feature("dedicated_server") or options.server:
		_start_server(options.port)
	else:
		_start_client(options.host, options.port)


func _start_server(port: int) -> void:
	var server := GameServer.new()
	server.name = "GameServer"
	add_child(server)
	server.session_started.connect(_on_server_session_started)
	server.session_ended.connect(_on_server_session_ended)
	server.session_refused.connect(_on_server_session_refused)
	var error := server.start(port)
	if error != OK:
		_log("cannot listen on port %d: %s" % [port, error_string(error)])
		get_tree().quit(1)
		return
	_log("listening on port %d, protocol %d" % [port, Protocol.VERSION])


func _start_client(host: String, port: int) -> void:
	var client := GameClient.new()
	client.name = "GameClient"
	add_child(client)
	_hud = Hud.new(client.world)
	add_child(_hud)
	_status = _hud.connection
	var address := "%s:%d" % [host, port]
	client.session_started.connect(_show.bind("in session with %s" % address))
	client.session_refused.connect(_on_client_session_refused)
	client.session_ended.connect(_show.bind("session ended by the server"))
	client.connection_failed.connect(_show.bind("cannot reach %s" % address))
	var error := client.join(host, port)
	if error != OK:
		_show("cannot start the connection: %s" % error_string(error))
		return
	_show("connecting to %s…" % address)


func _on_server_session_started(peer_id: int) -> void:
	_log("session started: peer %d" % peer_id)


func _on_server_session_ended(peer_id: int) -> void:
	_log("session ended: peer %d" % peer_id)


func _on_server_session_refused(peer_id: int, reason: String) -> void:
	_log("refused peer %d: %s" % [peer_id, reason])


func _on_client_session_refused(reason: String) -> void:
	_show("refused: %s" % reason)


## Shows a line on the client's screen, and prints it for the terminal too.
func _show(text: String) -> void:
	_status.text = text
	_log(text)


func _log(text: String) -> void:
	print("[%s] %s" % [Time.get_time_string_from_system(), text])
