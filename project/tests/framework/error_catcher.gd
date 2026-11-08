class_name ErrorCatcher
extends Logger
## Collects every error the engine reports while a test runs.
##
## GDScript has no exceptions: a runtime error prints a message and the faulty function
## simply returns. Without this logger a test that crashed halfway would still look green.
## Registered once with [method OS.add_logger]; the runner empties it around each test.
## The engine may log from any thread, hence the mutex.

var _mutex := Mutex.new()
var _errors: PackedStringArray = []
var _warnings: PackedStringArray = []


func _log_error(
	function: String,
	file: String,
	line: int,
	code: String,
	rationale: String,
	_editor_notify: bool,
	error_type: int,
	_script_backtraces: Array[ScriptBacktrace],
) -> void:
	var text := rationale if not rationale.is_empty() else code
	var entry := "%s (%s:%d, in %s)" % [text, file, line, function]
	_mutex.lock()
	if error_type == ERROR_TYPE_WARNING:
		_warnings.append(entry)
	else:
		_errors.append(entry)
	_mutex.unlock()


func _log_message(_message: String, _error: bool) -> void:
	pass


## Returns the errors caught since the last call, and forgets them.
func take_errors() -> PackedStringArray:
	_mutex.lock()
	var errors := _errors
	_errors = []
	_mutex.unlock()
	return errors


## Returns the warnings caught since the last call, and forgets them.
## Warnings are shown, but never fail a test.
func take_warnings() -> PackedStringArray:
	_mutex.lock()
	var warnings := _warnings
	_warnings = []
	_mutex.unlock()
	return warnings
