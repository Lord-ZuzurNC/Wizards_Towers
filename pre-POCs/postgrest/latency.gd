extends SceneTree

func _initialize() -> void:
	_run()

func _run() -> void:
	await process_frame
	for threaded: bool in [false, true]:
		var times: Array[float] = []
		for i: int in 20:
			var http: HTTPRequest = HTTPRequest.new()
			http.use_threads = threaded
			root.add_child(http)
			var t0: int = Time.get_ticks_usec()
			http.request("http://127.0.0.1:3399/rpc/world_state", ["Content-Type: application/json"], HTTPClient.METHOD_POST, "{}")
			await http.request_completed
			times.append((Time.get_ticks_usec() - t0) / 1000.0)
			http.queue_free()
		times.sort()
		print("use_threads=%s  min %.2f / median %.2f / max %.2f ms  (fps cap %d)" % [threaded, times[0], times[10], times[19], Engine.max_fps])
	quit()
