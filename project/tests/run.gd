extends SceneTree
## Runs the project's tests headless and exits non-zero if any of them fails.
##
## Usage, from the project folder:
##   godot --headless --script res://tests/run.gd [-- <directory>]
## The directory defaults to res://tests. Every [code]test_*.gd[/code] file below it is run,
## except under [code]framework/[/code], which holds the runner's own pieces.
## [code]tests/run-tests.sh[/code] wraps this call and refreshes the class cache first.
##
## A test fails on a failed assertion, on any engine or script error raised while it runs,
## or when its file does not load. A run with no test at all fails too: it proves nothing.

const DEFAULT_DIRECTORY := "res://tests"
const SKIPPED_DIRECTORY := "framework"
## The whole run is stopped past this delay, so a test awaiting a signal that never
## comes cannot hang the machine that runs it.
const WATCHDOG_SECONDS := 120

var _catcher := ErrorCatcher.new()
var _current_test := ""
var _passed := 0
var _failed := 0


func _initialize() -> void:
	OS.add_logger(_catcher)
	create_timer(float(WATCHDOG_SECONDS)).timeout.connect(_on_watchdog_timeout)
	_run()


func _run() -> void:
	# In --script mode the tree is not ready on the first frame; tests may add nodes.
	await process_frame
	var started := Time.get_ticks_msec()
	var args := OS.get_cmdline_user_args()
	var directory: String = args[0] if not args.is_empty() else DEFAULT_DIRECTORY
	var files := _find_test_files(directory)
	files.sort()
	for file in files:
		await _run_file(file)
	var seconds := (Time.get_ticks_msec() - started) / 1000.0
	var total := _passed + _failed
	print("\n%d tests, %d passed, %d failed, in %.2f s" % [total, _passed, _failed, seconds])
	if total == 0:
		print("no test found under %s" % directory)
	OS.remove_logger(_catcher)
	quit(0 if total > 0 and _failed == 0 else 1)


func _run_file(path: String) -> void:
	print(path)
	_catcher.take_errors()
	var script := load(path) as GDScript
	var load_errors := _catcher.take_errors()
	# A file whose base class failed to compile still loads, as a hollow script:
	# any error while loading means the file is not sound.
	if script == null or not script.can_instantiate() or not load_errors.is_empty():
		_report("(file)", PackedStringArray(["the file does not load"]) + load_errors)
		return
	var probe: Object = script.new()
	if not probe is TestCase or not probe.has_method("take_failures"):
		_report("(file)", PackedStringArray(["the file does not extend TestCase"]))
		return
	for method: Dictionary in script.get_script_method_list():
		var method_name: String = method["name"]
		if method_name.begins_with("test_"):
			await _run_test(script, method_name)


func _run_test(script: GDScript, method_name: String) -> void:
	_current_test = "%s %s" % [script.resource_path, method_name]
	var instance: Object = script.new()
	var test := instance as TestCase
	_catcher.take_errors()
	test.before_each()
	await test.call(method_name)
	test.after_each()
	var problems := test.take_failures() + _catcher.take_errors()
	for warning in _catcher.take_warnings():
		print("    warning: %s" % warning)
	_report(method_name, problems)


func _report(label: String, problems: PackedStringArray) -> void:
	if problems.is_empty():
		_passed += 1
		print("  ✓ %s" % label)
		return
	_failed += 1
	print("  ✗ %s" % label)
	for problem in problems:
		print("      %s" % problem)


func _find_test_files(directory: String) -> PackedStringArray:
	var found := PackedStringArray()
	var dir := DirAccess.open(directory)
	if dir == null:
		print("cannot open %s" % directory)
		return found
	for file in dir.get_files():
		if file.begins_with("test_") and file.ends_with(".gd"):
			found.append(directory.path_join(file))
	for sub in dir.get_directories():
		if sub != SKIPPED_DIRECTORY:
			found.append_array(_find_test_files(directory.path_join(sub)))
	return found


func _on_watchdog_timeout() -> void:
	print("\nstopped after %d s, still running: %s" % [WATCHDOG_SECONDS, _current_test])
	quit(1)
