extends TestCase
## Checks that the runner tells a broken test from a sound one.
##
## Each test writes throwaway test files under user://, runs the runner on them in a
## separate Godot process, then reads its exit code and its report.
## The separate process keeps the deliberate failures out of this run's own results.

const FIXTURES := "user://runner_fixtures"

const PASSING := """extends TestCase


func test_passes() -> void:
	assert_eq(1 + 1, 2)
"""

const FAILING := """extends TestCase


func test_fails() -> void:
	assert_eq(1 + 2, 4)
"""

const CRASHING := """extends TestCase


func test_crashes() -> void:
	var nothing: Object = null
	nothing.free()
"""

# An untyped declaration is a parse error in this project, so the file cannot load.
const UNLOADABLE := """extends TestCase

var untyped = 1
"""


func after_each() -> void:
	_remove_tree(FIXTURES)


func test_a_passing_suite_exits_zero() -> void:
	var run := _run_runner({ "test_passing.gd": PASSING })
	assert_eq(run.exit_code, 0, run.output)
	assert_true(run.output.contains("1 tests, 1 passed, 0 failed"), run.output)


func test_a_failed_assertion_fails_the_run() -> void:
	var run := _run_runner({ "test_passing.gd": PASSING, "test_failing.gd": FAILING })
	assert_eq(run.exit_code, 1, run.output)
	assert_true(run.output.contains("expected 4, got 3"), run.output)
	assert_true(run.output.contains("2 tests, 1 passed, 1 failed"), run.output)


func test_a_runtime_error_fails_the_test() -> void:
	var run := _run_runner({ "test_crashing.gd": CRASHING })
	assert_eq(run.exit_code, 1, run.output)
	assert_true(run.output.contains("✗ test_crashes"), run.output)
	assert_true(run.output.contains("Invalid call"), run.output)


func test_a_file_that_does_not_load_fails_the_run() -> void:
	var run := _run_runner({ "test_unloadable.gd": UNLOADABLE })
	assert_eq(run.exit_code, 1, run.output)
	assert_true(run.output.contains("the file does not load"), run.output)


func test_an_empty_folder_fails_the_run() -> void:
	var run := _run_runner({ })
	assert_eq(run.exit_code, 1, run.output)
	assert_true(run.output.contains("no test found"), run.output)


## Writes [param files] (name to content) into a fresh fixture folder and runs the
## runner on it.
func _run_runner(files: Dictionary[String, String]) -> RunResult:
	_remove_tree(FIXTURES)
	DirAccess.make_dir_recursive_absolute(FIXTURES)
	for file_name: String in files:
		var file := FileAccess.open(FIXTURES.path_join(file_name), FileAccess.WRITE)
		file.store_string(files[file_name])
		file.close()
	var arguments := PackedStringArray(
		[
			"--headless",
			"--path",
			ProjectSettings.globalize_path("res://"),
			"--script",
			"res://tests/run.gd",
			"--",
			FIXTURES,
		]
	)
	var output: Array = []
	var result := RunResult.new()
	result.exit_code = OS.execute(OS.get_executable_path(), arguments, output, true)
	result.output = "\n".join(PackedStringArray(output))
	return result


func _remove_tree(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	for sub in dir.get_directories():
		_remove_tree(path.path_join(sub))
	for file in dir.get_files():
		dir.remove(file)
	DirAccess.remove_absolute(path)


## What one run of the runner left behind.
class RunResult:
	var exit_code := -1
	var output := ""
