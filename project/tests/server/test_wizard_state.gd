extends TestCase
## XP and level-ups.


func test_xp_short_of_a_level_changes_nothing_else() -> void:
	var wizard := WizardState.new()
	assert_eq(wizard.gain_xp(9, 10), 0)
	assert_eq(wizard.wizard_level, 1)
	assert_eq(wizard.xp, 9)


func test_reaching_the_threshold_levels_up_and_keeps_the_rest() -> void:
	var wizard := WizardState.new()
	assert_eq(wizard.gain_xp(13, 10), 1)
	assert_eq(wizard.wizard_level, 2)
	assert_eq(wizard.xp, 3)


func test_a_large_gain_can_pay_several_levels() -> void:
	var wizard := WizardState.new()
	assert_eq(wizard.gain_xp(25, 10), 2)
	assert_eq(wizard.wizard_level, 3)
	assert_eq(wizard.xp, 5)


func test_a_level_up_adds_what_the_level_adds_without_healing_fully() -> void:
	var wizard := WizardState.new()
	wizard.health = 40
	wizard.gain_xp(10, 10)
	assert_eq(wizard.max_health(), 110)
	assert_eq(wizard.health, 50)
