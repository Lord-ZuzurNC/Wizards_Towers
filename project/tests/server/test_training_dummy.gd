extends TestCase
## The training dummy: hit, destroyed, standing up again.


func test_a_hit_goes_through_its_magic_defence() -> void:
	var dummy := _dummy()
	assert_false(dummy.take_hit(10, 0, 90))
	assert_eq(dummy.health, 30 - 8)


func test_the_destroying_hit_says_so_once() -> void:
	var dummy := _dummy()
	var destroyed := 0
	for i in 6:
		if dummy.take_hit(10, i, 90):
			destroyed += 1
	assert_eq(destroyed, 1)
	assert_true(dummy.is_destroyed())
	assert_eq(dummy.health, 0)


func test_it_stands_up_again_at_full_health_on_time() -> void:
	var dummy := _dummy()
	for i in 4:
		dummy.take_hit(10, 100, 90)
	dummy.update(189)
	assert_true(dummy.is_destroyed())
	dummy.update(190)
	assert_eq(dummy.health, 30)


func _dummy() -> TrainingDummy:
	var dummy := TrainingDummy.new()
	dummy.max_health = 30
	dummy.health = 30
	dummy.magic_defence = 10
	return dummy
