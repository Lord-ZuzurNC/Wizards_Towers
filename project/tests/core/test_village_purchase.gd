extends TestCase
## Who may buy a village: the rules the server enforces and the client shows.

const V := VillagePurchase.Verdict


func test_a_free_village_in_reach_with_the_gold_is_allowed() -> void:
	assert_eq(_judge(10.0, 0, 1, 0, 20), V.ALLOWED)


func test_exactly_at_reach_is_in_reach() -> void:
	assert_eq(VillagePurchase.judge(24.0, 24.0, 0, 1, 0, 20, 20), V.ALLOWED)


func test_too_far() -> void:
	assert_eq(_judge(30.0, 0, 1, 0, 20), V.TOO_FAR)


func test_a_held_village_cannot_be_bought() -> void:
	assert_eq(_judge(10.0, 7, 5, 0, 1000), V.OWNED)


func test_a_level_1_wizard_holds_one_village_at_most() -> void:
	assert_eq(_judge(10.0, 0, 1, 1, 1000), V.LEVEL_TOO_LOW)
	assert_eq(_judge(10.0, 0, 2, 1, 1000), V.ALLOWED)


func test_not_enough_gold() -> void:
	assert_eq(_judge(10.0, 0, 1, 0, 19), V.NOT_ENOUGH_GOLD)


func test_the_verdict_names_the_first_obstacle() -> void:
	# Too far, held, too low and too poor at once: being too far comes first.
	assert_eq(_judge(99.0, 7, 1, 1, 0), V.TOO_FAR)
	assert_eq(_judge(10.0, 7, 1, 1, 0), V.OWNED)
	assert_eq(_judge(10.0, 0, 1, 1, 0), V.LEVEL_TOO_LOW)


## A price of 20 and a reach of 24 pixels.
func _judge(
	distance: float,
	owner: int,
	level: int,
	held: int,
	gold: int,
) -> VillagePurchase.Verdict:
	return VillagePurchase.judge(distance, 24.0, owner, level, held, gold, 20)
