extends TestCase
## Walking, one tick at a time, against walls.

const OPEN := ["#######", "#.....#", "#.....#", "#.....#", "#######"]


func test_a_direction_code_round_trips() -> void:
	for x: int in [-1, 0, 1]:
		for y: int in [-1, 0, 1]:
			var direction := Vector2i(x, y)
			assert_eq(Movement.decode(Movement.encode(direction)), direction)


func test_code_4_is_standing_still() -> void:
	assert_eq(Movement.encode(Vector2i.ZERO), Movement.IDLE)


func test_an_invalid_code_means_no_direction() -> void:
	assert_eq(Movement.decode(9), Vector2i.ZERO)
	assert_eq(Movement.decode(-1), Vector2i.ZERO)


func test_speed_100_walks_4_tiles_a_second() -> void:
	var per_second := Simulation.pixels_per_tick(100) * Simulation.TICK_RATE
	assert_true(is_equal_approx(per_second, 64.0), str(per_second))


func test_standing_still_does_not_move() -> void:
	var room := _room()
	var start := room.tile_center(Vector2i(3, 2))
	assert_eq(Movement.step(start, Movement.IDLE, 100, room), start)


func test_one_tick_right_moves_one_tick_of_speed() -> void:
	var room := _room()
	var start := room.tile_center(Vector2i(3, 2))
	var after := Movement.step(start, Movement.encode(Vector2i.RIGHT), 100, room)
	assert_true(is_equal_approx(after.x - start.x, Simulation.pixels_per_tick(100)), str(after))
	assert_eq(after.y, start.y)


func test_a_diagonal_is_as_fast_as_a_straight_line() -> void:
	var room := _room()
	var start := room.tile_center(Vector2i(3, 2))
	var after := Movement.step(start, Movement.encode(Vector2i(1, 1)), 100, room)
	var distance := start.distance_to(after)
	assert_true(is_equal_approx(distance, Simulation.pixels_per_tick(100)), str(distance))


func test_a_wall_stops_the_feet_against_it() -> void:
	var room := _room()
	var position := room.tile_center(Vector2i(3, 2))
	for i in 200:
		position = Movement.step(position, Movement.encode(Vector2i.RIGHT), 100, room)
	# The wall starts at tile 6, so 96 pixels; the feet stop half their width before it.
	assert_eq(position.x, 96.0 - Movement.FEET_SIZE.x / 2.0)


func test_pushing_diagonally_into_a_wall_slides_along_it() -> void:
	var room := _room()
	var position := room.tile_center(Vector2i(3, 2))
	for i in 200:
		position = Movement.step(position, Movement.encode(Vector2i(1, -1)), 100, room)
	assert_eq(position.x, 96.0 - Movement.FEET_SIZE.x / 2.0)
	assert_eq(position.y, 16.0 + Movement.FEET_SIZE.y / 2.0)


func test_the_feet_never_overlap_a_wall() -> void:
	var room := _room()
	var position := room.tile_center(Vector2i(3, 2))
	for i in 600:
		var code := int(i / 37.0) % 9
		position = Movement.step(position, code, 140, room)
		var box := Movement.feet_box(position)
		assert_true(box.position.x >= 16.0 and box.end.x <= 96.0, str(box))
		assert_true(box.position.y >= 16.0 and box.end.y <= 64.0, str(box))


func _room() -> RoomData:
	return RoomFixtures.make(&"open", PackedStringArray(OPEN))
