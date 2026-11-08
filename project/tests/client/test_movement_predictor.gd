extends TestCase
## Predicting the player's own wizard, and correcting it from the server.

const RIGHT := 5 # Movement.encode(Vector2i.RIGHT)


func test_a_local_input_moves_at_once() -> void:
	var predictor := _predictor()
	var start := predictor.position
	predictor.apply_local(RIGHT)
	assert_true(predictor.position.x > start.x)


func test_inputs_get_increasing_sequence_numbers() -> void:
	var predictor := _predictor()
	assert_eq(predictor.apply_local(RIGHT), 1)
	assert_eq(predictor.apply_local(RIGHT), 2)


func test_reconciling_with_a_server_that_agrees_changes_nothing() -> void:
	var predictor := _predictor()
	var room := predictor.room
	var server_position := predictor.position
	for i in 5:
		predictor.apply_local(RIGHT)
		if i < 3:
			server_position = Movement.step(server_position, RIGHT, Simulation.BASE_SPEED, room)
	var predicted := predictor.position
	predictor.reconcile(3, room, server_position)
	assert_eq(predictor.position, predicted)
	assert_eq(predictor.pending_count(), 2)


func test_a_server_correction_is_replayed_on() -> void:
	var predictor := _predictor()
	var room := predictor.room
	for i in 4:
		predictor.apply_local(RIGHT)
	var corrected := room.tile_center(Vector2i(2, 1))
	predictor.reconcile(2, room, corrected)
	var expected := corrected
	for i in 2:
		expected = Movement.step(expected, RIGHT, Simulation.BASE_SPEED, room)
	assert_eq(predictor.position, expected)


func test_only_the_latest_unacknowledged_inputs_are_sent() -> void:
	var predictor := _predictor()
	for i in 7:
		predictor.apply_local(RIGHT if i % 2 == 0 else Movement.IDLE)
	assert_eq(predictor.first_unacknowledged(5), 3)
	assert_eq(predictor.unacknowledged_codes(5), PackedByteArray([RIGHT, 4, RIGHT, 4, RIGHT]))
	predictor.reconcile(6, predictor.room, predictor.position)
	assert_eq(predictor.first_unacknowledged(5), 7)
	assert_eq(predictor.unacknowledged_codes(5).size(), 1)


func _predictor() -> MovementPredictor:
	var rooms := RoomFixtures.two_joined_rooms()
	var predictor := MovementPredictor.new()
	predictor.start(rooms[&"left"], rooms[&"left"].tile_center(Vector2i(1, 1)))
	return predictor
