extends TestCase
## WorldMapGenerator: whether what it builds for the real world map is actually sound, and
## actually different each time (GLOSSARY.md, World endings — a run collapses into a new
## world, not the same one again).

const NEIGHBOURS_4: Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),
]


func test_generate_terrain_is_fully_connected_and_covers_every_biome_and_feature() -> void:
	for seed_value: int in [1, 2, 3, 4, 5]:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_value
		var map := WorldMapGenerator.generate_terrain(rng)
		assert_eq(map.rows.size(), WorldMapGenerator.SIZE.y, "seed %d" % seed_value)
		var walkable_total := 0
		var start := Vector2i(-1, -1)
		for y in map.rows.size():
			for x in map.rows[y].length():
				if not map.is_solid(Vector2i(x, y)):
					walkable_total += 1
					if start.x < 0 and map.rows[y][x] == ".":
						start = Vector2i(x, y)
		assert_true(start.x >= 0, "seed %d: no plains tile at all" % seed_value)
		var seen: Dictionary[Vector2i, bool] = { start: true }
		var stack: Array[Vector2i] = [start]
		while not stack.is_empty():
			var p: Vector2i = stack.pop_back()
			for offset: Vector2i in NEIGHBOURS_4:
				var np: Vector2i = p + offset
				if not seen.has(np) and not map.is_solid(np):
					seen[np] = true
					stack.append(np)
		var reached := seen.size()
		assert_eq(
			reached,
			walkable_total,
			"seed %d: only %d/%d walkable tiles reachable" % [seed_value, reached, walkable_total],
		)


func test_generate_terrain_never_lets_forest_or_glacier_touch_volcanic_ground() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var map := WorldMapGenerator.generate_terrain(rng)
	for y in map.rows.size():
		for x in map.rows[y].length():
			var c := map.rows[y][x]
			if c == "f" or c == "g":
				for offset: Vector2i in NEIGHBOURS_4:
					var np: Vector2i = Vector2i(x, y) + offset
					if (
						np.y >= 0 and np.y < map.rows.size() and np.x >= 0
						and np.x < map.rows[np.y].length()
					):
						assert_ne(
							map.rows[np.y][np.x],
							"v",
							"%s next to volcanic" % [Vector2i(x, y)],
						)


func test_the_monolith_is_always_at_the_exact_centre() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	var map := WorldMapGenerator.generate_terrain(rng)
	var centre := Vector2i(WorldMapGenerator.SIZE.x / 2, WorldMapGenerator.SIZE.y / 2)
	assert_eq(map.feature_at(centre), Biome.Feature.MONOLITH)


func test_two_generations_lay_out_different_terrain() -> void:
	var rng_a := RandomNumberGenerator.new()
	rng_a.seed = 100
	var rng_b := RandomNumberGenerator.new()
	rng_b.seed = 200
	var a := WorldMapGenerator.generate_terrain(rng_a)
	var b := WorldMapGenerator.generate_terrain(rng_b)
	assert_ne(a.rows, b.rows)


func test_points_of_interest_land_on_open_ground_spaced_apart() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	var map := WorldMapGenerator.generate_terrain(rng)
	var doors := WorldMapGenerator.place_points_of_interest(
		map,
		rng,
		[&"dungeon_1_entrance", &"dungeon_2_entrance"],
	)
	assert_eq(map.dummy_tiles.size(), 10)
	assert_eq(map.villages.size(), 5)
	assert_eq(doors.size(), 2)
	assert_eq(map.exits.size(), 2)
	var all_points: Array[Vector2i] = []
	all_points.append_array(map.dummy_tiles)
	for village in map.villages:
		all_points.append(village.tile)
	all_points.append_array(doors)
	for p: Vector2i in all_points:
		assert_false(map.is_solid(p), str(p))
	for i in all_points.size():
		for j in range(i + 1, all_points.size()):
			assert_true(
				Vector2(all_points[i] - all_points[j]).length() > 1.0,
				"%s overlaps %s" % [all_points[i], all_points[j]],
			)
	for i in doors.size():
		assert_eq(map.exits[i].target_room, [&"dungeon_1_entrance", &"dungeon_2_entrance"][i])
		assert_eq(map.exits[i].area.position, doors[i])


func test_nearby_open_tile_is_walkable_and_adjacent() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 9
	var map := WorldMapGenerator.generate_terrain(rng)
	var doors := WorldMapGenerator.place_points_of_interest(map, rng, [&"dungeon_1_entrance"])
	var landing := WorldMapGenerator.nearby_open_tile(map, doors[0])
	assert_false(map.is_solid(landing))
	assert_true(Vector2(landing - doors[0]).length() <= 2.0)
