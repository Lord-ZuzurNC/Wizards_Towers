extends TestCase
## Checks the assertions of [TestCase] themselves.
##
## Each test asserts on a separate [TestCase], then inspects what that one recorded,
## so the deliberate failures never reach this test's own report.


func test_assert_eq_accepts_equal_values() -> void:
	var probe := TestCase.new()
	probe.assert_eq(3, 3)
	probe.assert_eq("mana", "mana")
	assert_eq(probe.take_failures().size(), 0)


func test_assert_eq_rejects_different_values() -> void:
	var probe := TestCase.new()
	probe.assert_eq(3, 4)
	var failures := probe.take_failures()
	assert_eq(failures.size(), 1)
	assert_true(failures[0].contains("expected 4, got 3"), failures[0])


func test_assert_eq_tells_an_int_from_a_float() -> void:
	var probe := TestCase.new()
	probe.assert_eq(1, 1.0)
	assert_eq(probe.take_failures().size(), 1)


func test_assert_ne_rejects_equal_values() -> void:
	var probe := TestCase.new()
	probe.assert_ne(5, 6)
	assert_eq(probe.take_failures().size(), 0)
	probe.assert_ne(5, 5)
	assert_eq(probe.take_failures().size(), 1)


func test_assert_true_and_assert_false() -> void:
	var probe := TestCase.new()
	probe.assert_true(true)
	probe.assert_false(false)
	assert_eq(probe.take_failures().size(), 0)
	probe.assert_true(false)
	probe.assert_false(true)
	assert_eq(probe.take_failures().size(), 2)


func test_fail_always_records() -> void:
	var probe := TestCase.new()
	probe.fail("unreachable branch")
	var failures := probe.take_failures()
	assert_eq(failures.size(), 1)
	assert_true(failures[0].contains("unreachable branch"), failures[0])


func test_a_failure_points_at_the_calling_line() -> void:
	var probe := TestCase.new()
	probe.assert_true(false)
	var failures := probe.take_failures()
	assert_eq(failures.size(), 1)
	var own_script: Script = get_script()
	var own_file := own_script.resource_path
	assert_true(failures[0].contains(own_file + ":"), failures[0])


func test_take_failures_empties_the_list() -> void:
	var probe := TestCase.new()
	probe.fail("once")
	probe.take_failures()
	assert_eq(probe.take_failures().size(), 0)
