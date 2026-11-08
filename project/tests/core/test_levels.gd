extends TestCase
## Base stats by wizard_level, from FORMULAS.md, Wizard progression.


func test_level_1() -> void:
	assert_eq(Levels.health(1), 100)
	assert_eq(Levels.power(1), 10)
	assert_eq(Levels.magic_defence(1), 10)
	assert_eq(Levels.luck(1), 5)
	assert_eq(Levels.base_mana_pool(1), 100)


func test_level_30() -> void:
	assert_eq(Levels.health(30), 390)
	assert_eq(Levels.power(30), 39)
	assert_eq(Levels.luck(30), 12)
	assert_eq(Levels.base_mana_pool(30), 300)


func test_every_stat_grows_or_holds_with_each_level() -> void:
	for level in range(1, 30):
		assert_true(Levels.health(level + 1) > Levels.health(level))
		assert_true(Levels.base_mana_pool(level + 1) > Levels.base_mana_pool(level), str(level))
		assert_true(Levels.luck(level + 1) >= Levels.luck(level))
