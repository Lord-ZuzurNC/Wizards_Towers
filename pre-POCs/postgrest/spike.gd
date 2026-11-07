## PostgREST spike: Godot 4.7.2 headless talks to PostgreSQL through PostgREST.
## Run: godot --headless --script spike.gd
extends SceneTree

const BASE_URL: String = "http://127.0.0.1:3399"

var _results: Dictionary[String, Dictionary] = {}


func _initialize() -> void:
	_run()


func _run() -> void:
	await process_frame  # root accepts children only once the first frame has started
	_print_case("0 initial state", await _post("/rpc/world_state", {}))
	_print_case("A Brann buys village 3 (price 50, has 100)", await _post("/rpc/buy_village", {"p_wizard": 2, "p_village": 3}))
	_print_case("B Brann buys village 1 (price 3000, has 50)", await _post("/rpc/buy_village", {"p_wizard": 2, "p_village": 1}))
	_print_case("C crash after debit (Alba, village 1)", await _post("/rpc/buy_then_crash", {"p_wizard": 1, "p_village": 1}))
	_print_case("C' state after crash", await _post("/rpc/world_state", {}))

	# D: Alba (5000 gold) buys villages 1 and 2 (3000 each) in the same frame.
	# Each call holds its locks 0.3 s so the two requests genuinely overlap.
	_fire("D1", "/rpc/buy_village", {"p_wizard": 1, "p_village": 1, "p_hold_lock_s": 0.3})
	_fire("D2", "/rpc/buy_village", {"p_wizard": 1, "p_village": 2, "p_hold_lock_s": 0.3})
	while _results.size() < 2:
		await process_frame
	_print_case("D1 concurrent buy, village 1", _results["D1"])
	_print_case("D2 concurrent buy, village 2", _results["D2"])
	_print_case("D' state after race", await _post("/rpc/world_state", {}))

	# E: tables are not reachable, only functions.
	_print_case("E direct table write attempt", await _post("/wizards", {"id": 3, "name": "Cheat", "gold": 999999}))

	# F: latency of 20 sequential calls.
	var times: Array[float] = []
	for i: int in 20:
		var r: Dictionary = await _post("/rpc/world_state", {})
		times.append(r["ms"])
	times.sort()
	print("F latency ms: min %.2f / median %.2f / max %.2f" % [times[0], times[10], times[19]])
	quit()


func _post(path: String, body: Dictionary) -> Dictionary:
	var http: HTTPRequest = HTTPRequest.new()
	root.add_child(http)
	var headers: PackedStringArray = ["Content-Type: application/json"]
	var started: int = Time.get_ticks_usec()
	var err: Error = http.request(BASE_URL + path, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	if err != OK:
		return {"code": -1, "body": "request() failed: %d" % err, "ms": 0.0}
	var result: Array = await http.request_completed
	http.queue_free()
	return _pack(result, started)


func _fire(key: String, path: String, body: Dictionary) -> void:
	var http: HTTPRequest = HTTPRequest.new()
	root.add_child(http)
	var started: int = Time.get_ticks_usec()
	http.request_completed.connect(_on_fired.bind(key, started, http))
	http.request(BASE_URL + path, ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(body))


func _on_fired(result: int, code: int, headers: PackedStringArray, body: PackedByteArray, key: String, started: int, http: HTTPRequest) -> void:
	_results[key] = _pack([result, code, headers, body], started)
	http.queue_free()


func _pack(result: Array, started: int) -> Dictionary:
	var raw: PackedByteArray = result[3]
	return {
		"code": result[1],
		"body": raw.get_string_from_utf8(),
		"ms": (Time.get_ticks_usec() - started) / 1000.0,
	}


func _print_case(label: String, r: Dictionary) -> void:
	print("%s -> HTTP %d in %.1f ms\n    %s" % [label, r["code"], r["ms"], r["body"]])
