extends TestCase
## Damage through magic_defence, from FORMULAS.md.


func test_no_defence_lets_the_whole_hit_through() -> void:
	assert_eq(Damage.dealt(10, 0), 10)


func test_a_defence_of_k_halves_the_hit() -> void:
	assert_eq(Damage.dealt(10, Damage.K), 5)


func test_the_result_is_rounded_down() -> void:
	# 10 × 60 / 70 = 8.57
	assert_eq(Damage.dealt(10, 10), 8)


func test_a_hit_always_deals_at_least_1() -> void:
	assert_eq(Damage.dealt(1, 1000), 1)


func test_full_penetration_ignores_the_defence() -> void:
	assert_eq(Damage.dealt(10, 1000, 1.0), 10)


func test_penetration_beyond_1_counts_as_1() -> void:
	assert_eq(Damage.dealt(10, 60, 3.0), 10)
	assert_eq(Damage.dealt(10, 60, -1.0), 5)
