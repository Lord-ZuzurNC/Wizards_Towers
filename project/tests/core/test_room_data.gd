extends TestCase
## Room layouts, and the rooms shipped in data/rooms.


func test_the_size_comes_from_the_rows() -> void:
	var room := RoomFixtures.make(&"r", PackedStringArray(["####", "#..#", "####"]))
	assert_eq(room.size(), Vector2i(4, 3))


func test_walls_and_the_outside_are_solid() -> void:
	var room := RoomFixtures.make(&"r", PackedStringArray(["####", "#..#", "####"]))
	assert_true(room.is_solid(Vector2i(0, 0)))
	assert_false(room.is_solid(Vector2i(1, 1)))
	assert_true(room.is_solid(Vector2i(-1, 1)))
	assert_true(room.is_solid(Vector2i(4, 1)))
	assert_true(room.is_solid(Vector2i(1, 3)))


func test_a_tile_centre_and_back() -> void:
	var room := RoomFixtures.make(&"r", PackedStringArray(["####", "#..#", "####"]))
	assert_eq(room.tile_center(Vector2i(2, 1)), Vector2(40.0, 24.0))
	assert_eq(room.tile_at(Vector2(40.0, 24.0)), Vector2i(2, 1))


func test_an_exit_is_found_by_position() -> void:
	var rooms := RoomFixtures.two_joined_rooms()
	var left := rooms[&"left"]
	assert_true(left.exit_at(left.tile_center(Vector2i(7, 1))) != null)
	assert_true(left.exit_at(left.tile_center(Vector2i(6, 1))) == null)


func test_a_sound_room_has_no_problem() -> void:
	var rooms := RoomFixtures.two_joined_rooms()
	var known: Array[StringName] = [&"left", &"right"]
	assert_eq(rooms[&"left"].validate(known).size(), 0, str(rooms[&"left"].validate(known)))


func test_uneven_rows_are_a_problem() -> void:
	var room := RoomFixtures.make(&"r", PackedStringArray(["####", "#..", "####"]))
	assert_eq(room.validate([]).size(), 1)


func test_an_unknown_character_is_a_problem() -> void:
	var room := RoomFixtures.make(&"r", PackedStringArray(["####", "#.x#", "####"]))
	assert_eq(room.validate([]).size(), 1)


func test_a_spawn_on_a_wall_is_a_problem() -> void:
	var room := RoomFixtures.make(&"r", PackedStringArray(["####", "#..#", "####"]), Vector2i.ZERO)
	assert_eq(room.validate([]).size(), 1)


func test_a_village_on_a_wall_is_a_problem() -> void:
	var room := RoomFixtures.make(&"r", PackedStringArray(["####", "#..#", "####"]))
	var site := VillageSite.new()
	site.title = "Walled"
	room.villages = [site]
	var problems := room.validate([])
	assert_eq(problems.size(), 1)
	assert_true(problems[0].contains("Walled"), problems[0])


func test_an_exit_to_an_unknown_room_is_a_problem() -> void:
	var rooms := RoomFixtures.two_joined_rooms()
	var problems := rooms[&"left"].validate([&"left"])
	assert_eq(problems.size(), 1)
	assert_true(problems[0].contains("right"), problems[0])


func test_a_room_larger_than_one_screen_is_a_problem() -> void:
	var row := "#".repeat(41)
	var room := RoomFixtures.make(&"r", PackedStringArray([row, row]))
	room.spawn_tile = Vector2i(-5, -5)
	var problems := room.validate([])
	assert_true(problems.size() >= 1, str(problems))
	assert_true(str(problems).contains("41 × 2"), str(problems))


func test_the_shipped_rooms_are_sound_and_joined() -> void:
	var rooms := RoomCatalog.load_folder()
	var known: Array[StringName] = []
	known.assign(rooms.keys())
	for id: StringName in rooms:
		assert_eq(rooms[id].validate(known).size(), 0, "%s: %s" % [id, rooms[id].validate(known)])
	assert_true(rooms.has(&"first_room") and rooms.has(&"second_room"), str(rooms.keys()))
	for id: StringName in rooms:
		for room_exit in rooms[id].exits:
			var target := rooms[room_exit.target_room]
			assert_false(target.is_solid(room_exit.target_tile), "%s lands in a wall" % id)
			var landing := target.tile_center(room_exit.target_tile)
			assert_true(target.exit_at(landing) == null, "%s lands on an exit" % id)
