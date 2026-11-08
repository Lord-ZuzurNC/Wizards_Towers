class_name TestCase
extends RefCounted
## The base of every test file.
##
## A test file extends [TestCase] and names each test method [code]test_*[/code].
## The runner builds a fresh instance for every test method, so no state leaks from
## one test to the next.
## A failed assertion records a message and lets the test carry on: one run reports
## every broken expectation of a test, not only the first.

var _failures: PackedStringArray = []


## Runs before each test method. Override it to build fresh state.
func before_each() -> void:
	pass


## Runs after each test method, even a failed one. Override it to clean up.
func after_each() -> void:
	pass


func assert_true(condition: bool, message := "") -> void:
	if not condition:
		_record("expected true, got false", message)


func assert_false(condition: bool, message := "") -> void:
	if condition:
		_record("expected false, got true", message)


## Fails unless [param actual] equals [param expected] and has the same type.
## The type check is deliberate: an [int] 1 and a [float] 1.0 are reported as different,
## because the project rounds to integers on purpose and a stray float is a bug.
func assert_eq(actual: Variant, expected: Variant, message := "") -> void:
	if typeof(actual) != typeof(expected) or actual != expected:
		_record("expected %s, got %s" % [var_to_str(expected), var_to_str(actual)], message)


func assert_ne(actual: Variant, unexpected: Variant, message := "") -> void:
	if typeof(actual) == typeof(unexpected) and actual == unexpected:
		_record("expected anything but %s" % var_to_str(unexpected), message)


## Fails the test unconditionally, for a branch that must never run.
func fail(message: String) -> void:
	_record("failed", message)


## Hands the recorded failures to the runner and forgets them.
func take_failures() -> PackedStringArray:
	var failures := _failures
	_failures = []
	return failures


func _record(what: String, message: String) -> void:
	var text := what if message.is_empty() else "%s: %s" % [message, what]
	_failures.append("%s (%s)" % [text, _caller_location()])


## The file and line of the test code that called the assertion.
## The first frame is this very function, so its file is the one to skip.
func _caller_location() -> String:
	for trace: ScriptBacktrace in Engine.capture_script_backtraces():
		if trace.get_frame_count() == 0:
			continue
		var base_file := trace.get_frame_file(0)
		for i in trace.get_frame_count():
			if trace.get_frame_file(i) != base_file:
				return "%s:%d" % [trace.get_frame_file(i), trace.get_frame_line(i)]
	return "unknown location"
