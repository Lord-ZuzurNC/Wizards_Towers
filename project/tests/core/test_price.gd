extends TestCase
## The escalating price, from FORMULAS.md, section Economy.


func test_the_first_purchase_costs_the_base_price() -> void:
	assert_eq(Price.escalating(20, 2.0, 0), 20)


func test_each_purchase_made_multiplies_the_next_price() -> void:
	assert_eq(Price.escalating(20, 2.0, 1), 40)
	assert_eq(Price.escalating(20, 2.0, 3), 160)


func test_a_fractional_price_is_rounded_down() -> void:
	# 20 × 1.5 × 1.5 = 45, 45 × 1.5 = 67.5
	assert_eq(Price.escalating(20, 1.5, 3), 67)
