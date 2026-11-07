## ZITADEL pre-POC: a Godot client logs a player in through the system browser,
## with OAuth 2.0 authorization code + PKCE and a loopback redirect (RFC 8252).
## Run: godot --headless --script login.gd -- <issuer> <client_id>
## It prints the URL to open; the browser comes back to 127.0.0.1:47123.
extends SceneTree

const PORT := 47123
const REDIRECT := "http://127.0.0.1:%d/callback" % PORT

var _issuer: String
var _client_id: String
var _verifier: String
var _state: String
var _server := TCPServer.new()
var _peer: StreamPeerTCP
var _request := ""
var _started_ms := 0
var _callback_handled := false


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2:
		_fail("usage: -- <issuer> <client_id>")
		return
	_issuer = args[0]
	_client_id = args[1]
	_verifier = _b64url(Crypto.new().generate_random_bytes(32))
	_state = _b64url(Crypto.new().generate_random_bytes(16))
	var challenge := _b64url(_verifier.sha256_buffer())

	var err := _server.listen(PORT, "127.0.0.1")
	if err != OK:
		_fail("cannot listen on 127.0.0.1:%d (%s)" % [PORT, error_string(err)])
		return

	var url := "%s/oauth/v2/authorize?%s" % [_issuer, _query({
		"client_id": _client_id,
		"redirect_uri": REDIRECT,
		"response_type": "code",
		"scope": "openid profile email",
		"code_challenge": challenge,
		"code_challenge_method": "S256",
		"state": _state,
	})]
	print("OPEN ", url)
	if DisplayServer.get_name() != "headless":
		OS.shell_open(url)
	_started_ms = Time.get_ticks_msec()


func _process(_delta: float) -> bool:
	if _callback_handled:
		return false
	if Time.get_ticks_msec() - _started_ms > 300_000:
		_fail("no browser callback within 5 minutes")
		return true
	if _peer == null:
		if _server.is_connection_available():
			_peer = _server.take_connection()
		return false
	_peer.poll()
	var available := _peer.get_available_bytes()
	if available > 0:
		_request += _peer.get_utf8_string(available)
	if not _request.contains("\r\n\r\n"):
		return false

	_callback_handled = true
	var path := _request.get_slice(" ", 1)
	_reply("<h1>Wizards Towers</h1><p>You can close this tab.</p>")
	_server.stop()
	if not path.begins_with("/callback?"):
		_fail("unexpected request: " + path)
		return true
	var params := _parse_query(path.get_slice("?", 1))
	if params.get("state", "") != _state:
		_fail("state mismatch, possible forged callback")
		return true
	if not params.has("code"):
		_fail("no code in callback: " + str(params))
		return true
	print("CALLBACK code received, state verified")
	_exchange.call_deferred(params["code"])
	return false


func _exchange(code: String) -> void:
	var http := HTTPRequest.new()
	http.use_threads = true
	root.add_child(http)
	var body := _query({
		"grant_type": "authorization_code",
		"code": code,
		"redirect_uri": REDIRECT,
		"client_id": _client_id,
		"code_verifier": _verifier,
	})
	http.request(_issuer + "/oauth/v2/token",
		["Content-Type: application/x-www-form-urlencoded"], HTTPClient.METHOD_POST, body)
	var result: Array = await http.request_completed
	var token: Variant = JSON.parse_string((result[3] as PackedByteArray).get_string_from_utf8())
	if result[1] != 200 or not token is Dictionary or not token.has("access_token"):
		_fail("token exchange HTTP %d: %s" % [result[1], str(token)])
		return
	print("TOKEN HTTP 200, type %s, expires in %s s, id_token present: %s"
		% [token["token_type"], token["expires_in"], token.has("id_token")])

	# Replaying the same code must fail: codes are single use.
	http.request(_issuer + "/oauth/v2/token",
		["Content-Type: application/x-www-form-urlencoded"], HTTPClient.METHOD_POST, body)
	result = await http.request_completed
	print("REPLAY of the same code: HTTP %d" % result[1])

	http.request(_issuer + "/oidc/v1/userinfo",
		["Authorization: Bearer " + str(token["access_token"])])
	result = await http.request_completed
	var info: Variant = JSON.parse_string((result[3] as PackedByteArray).get_string_from_utf8())
	if result[1] != 200 or not info is Dictionary:
		_fail("userinfo HTTP %d" % result[1])
		return
	print("USERINFO HTTP 200, sub %s, preferred_username %s, email %s"
		% [info.get("sub"), info.get("preferred_username"), info.get("email")])
	print("RESULT ok")
	quit(0)


func _reply(html: String) -> void:
	var bytes := html.to_utf8_buffer()
	var head := "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: %d\r\nConnection: close\r\n\r\n" % bytes.size()
	_peer.put_data(head.to_utf8_buffer() + bytes)
	_peer.disconnect_from_host()


func _b64url(raw: PackedByteArray) -> String:
	return Marshalls.raw_to_base64(raw).replace("+", "-").replace("/", "_").trim_suffix("=").trim_suffix("=")


func _query(fields: Dictionary) -> String:
	var parts: PackedStringArray = []
	for key: String in fields:
		parts.append("%s=%s" % [key.uri_encode(), str(fields[key]).uri_encode()])
	return "&".join(parts)


func _parse_query(query: String) -> Dictionary:
	var out := {}
	for pair in query.split("&", false):
		out[pair.get_slice("=", 0).uri_decode()] = pair.get_slice("=", 1).uri_decode()
	return out


func _fail(message: String) -> void:
	printerr("RESULT failed: ", message)
	quit(1)
