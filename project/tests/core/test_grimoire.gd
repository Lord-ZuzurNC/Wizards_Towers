extends TestCase
## Grimoire positions by wizard_level, from FORMULAS.md.


func test_one_position_every_three_levels() -> void:
	assert_eq(Grimoire.positions(1), 1)
	assert_eq(Grimoire.positions(3), 1)
	assert_eq(Grimoire.positions(4), 2)
	assert_eq(Grimoire.positions(7), 3)


func test_ten_at_level_28_and_never_more() -> void:
	assert_eq(Grimoire.positions(27), 9)
	assert_eq(Grimoire.positions(28), 10)
	assert_eq(Grimoire.positions(30), 10)


func test_the_placeholder_spells_fill_every_position() -> void:
	var spells := PlaceholderValues.new().spells
	assert_eq(spells.size(), Grimoire.MAX_POSITIONS)


func test_the_placeholder_speeds_follow_what_each_position_suits() -> void:
	# Cooldowns: the fastest on 1 to 3, fast on 6 to 8, slow on 4 and 5, slowest on 9, 10.
	assert_true(_cooldown(1) < _cooldown(6))
	assert_true(_cooldown(6) < _cooldown(4))
	assert_true(_cooldown(4) < _cooldown(9))


func _cooldown(grimoire_position: int) -> int:
	return PlaceholderValues.new().spells[grimoire_position - 1].cooldown_ticks
