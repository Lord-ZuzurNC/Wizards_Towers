extends TestCase
## The state update message, and its refusal of anything malformed.


func test_a_message_round_trips() -> void:
	var update := _sample()
	var read := StateUpdate.from_message(update.to_message())
	assert_true(read != null)
	assert_eq(read.to_message(), update.to_message())
	assert_eq(read.xp, 7)
	assert_eq(read.dummy_health, PackedInt32Array([20]))
	assert_eq(read.village_owners, PackedInt32Array([0, 2]))
	assert_eq(read.gold, 35)
	assert_eq(read.village_price, 40)
	assert_eq(read.villages_held, 1)
	assert_eq(read.grimoire_positions, 10)
	assert_eq(read.cooldowns[1], 3)
	assert_eq(read.projectile_spells, PackedInt32Array([6]))


func test_a_message_of_the_wrong_length_is_refused() -> void:
	var message := _sample().to_message()
	message.pop_back()
	assert_true(StateUpdate.from_message(message) == null)


func test_a_field_of_the_wrong_type_is_refused() -> void:
	var message := _sample().to_message()
	message[1] = "a String, not a StringName"
	assert_true(StateUpdate.from_message(message) == null)


func test_lists_that_disagree_in_length_are_refused() -> void:
	var update := _sample()
	update.wizard_positions.append(Vector2.ZERO)
	assert_true(StateUpdate.from_message(update.to_message()) == null)


func test_villages_without_as_many_owners_are_refused() -> void:
	var update := _sample()
	update.village_owners.append(3)
	assert_true(StateUpdate.from_message(update.to_message()) == null)


func test_projectiles_without_as_many_positions_are_refused() -> void:
	var update := _sample()
	update.projectile_spells.append(1)
	assert_true(StateUpdate.from_message(update.to_message()) == null)


func test_more_than_ten_cooldowns_are_refused() -> void:
	var update := _sample()
	update.cooldowns.resize(11)
	assert_true(StateUpdate.from_message(update.to_message()) == null)


func test_a_short_status_is_refused() -> void:
	var message := _sample().to_message()
	message[12] = PackedInt32Array([1, 2, 3])
	assert_true(StateUpdate.from_message(message) == null)


func _sample() -> StateUpdate:
	var update := StateUpdate.new()
	update.tick = 12
	update.room_id = &"left"
	update.acknowledged = 9
	update.wizard_ids = PackedInt32Array([1, 2])
	update.wizard_positions = PackedVector2Array([Vector2(1, 2), Vector2(3, 4)])
	update.dummy_positions = PackedVector2Array([Vector2(5, 6)])
	update.dummy_health = PackedInt32Array([20])
	update.dummy_max_health = PackedInt32Array([30])
	update.projectile_positions = PackedVector2Array([Vector2(7, 8)])
	update.projectile_spells = PackedInt32Array([6])
	update.village_positions = PackedVector2Array([Vector2(9, 10), Vector2(11, 12)])
	update.village_owners = PackedInt32Array([0, 2])
	update.health = 100
	update.max_health = 100
	update.mana = 50
	update.mana_pool = 100
	update.wizard_level = 1
	update.xp = 7
	update.xp_to_next = 10
	update.gold = 35
	update.village_price = 40
	update.villages_held = 1
	update.grimoire_positions = 10
	update.cooldowns = PackedInt32Array([0, 3, 0, 0, 0, 0, 0, 0, 0, 0])
	return update
