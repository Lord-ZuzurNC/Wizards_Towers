extends TestCase
## World maps: biomes, what blocks, and the hand-made map shipped in data/rooms.

const WALKABLE := ".fmgdhvr"
const BLOCKED := "~^ox="


func test_every_character_has_its_biome_and_feature() -> void:
	var expected := {
		".": [Biome.Kind.PLAINS, Biome.Feature.GROUND],
		"f": [Biome.Kind.FOREST, Biome.Feature.GROUND],
		"m": [Biome.Kind.MARSH, Biome.Feature.GROUND],
		"g": [Biome.Kind.GLACIER, Biome.Feature.GROUND],
		"d": [Biome.Kind.DESERT, Biome.Feature.GROUND],
		"h": [Biome.Kind.MOUNTAIN, Biome.Feature.GROUND],
		"v": [Biome.Kind.VOLCANIC, Biome.Feature.GROUND],
		"~": [Biome.Kind.COAST, Biome.Feature.WATER],
		"^": [Biome.Kind.MOUNTAIN, Biome.Feature.SPINE],
		"o": [Biome.Kind.VOLCANIC, Biome.Feature.CRATER],
		"x": [Biome.Kind.VOLCANIC, Biome.Feature.RIFT_CORE],
		"r": [Biome.Kind.VOLCANIC, Biome.Feature.RIFT_BANK],
		"=": [Biome.Kind.GLACIER, Biome.Feature.WATER],
	}
	for character: String in expected:
		var world := _world(PackedStringArray([character]))
		assert_eq(world.biome_at(Vector2i.ZERO), expected[character][0], character)
		assert_eq(world.feature_at(Vector2i.ZERO), expected[character][1], character)


func test_only_ground_and_rift_banks_are_walkable() -> void:
	for character in WALKABLE:
		assert_false(_world(PackedStringArray([character])).is_solid(Vector2i.ZERO), character)
	for character in BLOCKED:
		assert_true(_world(PackedStringArray([character])).is_solid(Vector2i.ZERO), character)


func test_outside_the_map_is_solid_and_has_no_biome() -> void:
	var world := _world(PackedStringArray([".."]))
	assert_true(world.is_solid(Vector2i(2, 0)))
	assert_eq(world.biome_at(Vector2i(-1, 0)), -1)


func test_a_room_wall_means_nothing_on_a_world_map() -> void:
	var world := _world(PackedStringArray([".#."]))
	assert_eq(world.validate([]).size(), 1, str(world.validate([])))


func test_a_world_map_may_be_far_larger_than_a_room() -> void:
	var world := RoomFixtures.small_world()
	assert_eq(world.validate([]).size(), 0, str(world.validate([])))


func test_walking_into_the_sea_stops_on_the_shore() -> void:
	var world := RoomFixtures.small_world()
	var position := world.tile_center(Vector2i(10, 15))
	for i in 300:
		position = Movement.step(position, Movement.encode(Vector2i.LEFT), 100, world)
	# The sea fills columns 0 and 1: the shore starts at 32 pixels.
	assert_eq(position.x, 32.0 + Movement.FEET_SIZE.x / 2.0)


func test_walking_east_crosses_from_plains_into_forest() -> void:
	var world := RoomFixtures.small_world()
	var position := world.tile_center(Vector2i(28, 15))
	assert_eq(world.biome_at(world.tile_at(position)), Biome.Kind.PLAINS)
	for i in 30:
		position = Movement.step(position, Movement.encode(Vector2i.RIGHT), 100, world)
	assert_eq(world.biome_at(world.tile_at(position)), Biome.Kind.FOREST)


func test_the_shipped_map_holds_every_biome_and_feature() -> void:
	var world := _shipped()
	var biomes := { }
	var features := { }
	var size := world.size()
	for y in size.y:
		for x in size.x:
			biomes[world.biome_at(Vector2i(x, y))] = true
			features[world.feature_at(Vector2i(x, y))] = true
	assert_eq(biomes.size(), Biome.Kind.size(), str(biomes.keys()))
	assert_eq(features.size(), Biome.Feature.size(), str(features.keys()))
	assert_eq(world.biome_at(world.spawn_tile), Biome.Kind.PLAINS)


func test_on_the_shipped_map_all_walkable_ground_is_reachable() -> void:
	var world := _shipped()
	var reached := _flood(world, world.spawn_tile, Rect2i(Vector2i.ZERO, world.size()))
	var size := world.size()
	var unreached := 0
	for y in size.y:
		for x in size.x:
			if not world.is_solid(Vector2i(x, y)) and not reached.has(Vector2i(x, y)):
				unreached += 1
	assert_eq(unreached, 0)


func test_on_the_shipped_map_the_rift_core_cannot_be_crossed() -> void:
	# Within the rows of the rift, its west bank never reaches its east bank: the only way
	# round is past its southern end.
	var world := _shipped()
	var band := _rows_holding(world, Biome.Feature.RIFT_CORE)
	var west := _first_tile_of(world, Biome.Feature.RIFT_BANK, band.position.y + band.size.y / 2)
	var reached := _flood(world, west, band)
	for tile: Vector2i in reached:
		var row_core := _first_tile_of(world, Biome.Feature.RIFT_CORE, tile.y)
		assert_true(tile.x < row_core.x, "%s lies east of the core" % tile)


func test_on_the_shipped_map_the_spine_cannot_be_crossed() -> void:
	var world := _shipped()
	var band := _rows_holding(world, Biome.Feature.SPINE)
	var west := Vector2i(_first_tile_of(world, Biome.Feature.SPINE, 0).x - 3, 0)
	var reached := _flood(world, west, band)
	for tile: Vector2i in reached:
		var row_spine := _first_tile_of(world, Biome.Feature.SPINE, tile.y)
		assert_true(tile.x < row_spine.x, "%s lies east of the spine" % tile)


func test_on_the_shipped_map_forest_and_glacier_never_touch_volcanic_ground() -> void:
	var world := _shipped()
	var size := world.size()
	for y in size.y:
		for x in size.x:
			var biome := world.biome_at(Vector2i(x, y))
			if biome != Biome.Kind.FOREST and biome != Biome.Kind.GLACIER:
				continue
			for step: Vector2i in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
				var beside := world.biome_at(Vector2i(x, y) + step)
				assert_ne(
					beside,
					Biome.Kind.VOLCANIC,
					"%s touches volcanic ground" % Vector2i(x, y),
				)


## Walkable tiles reachable from [param start] by side steps, inside [param bounds]. Side
## steps are enough: the feet cannot slip between two blocked tiles meeting at a corner.
func _flood(world: WorldMapData, start: Vector2i, bounds: Rect2i) -> Dictionary:
	var reached := { start: true }
	var queue: Array[Vector2i] = [start]
	while not queue.is_empty():
		var tile: Vector2i = queue.pop_back()
		for step: Vector2i in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var next := tile + step
			if bounds.has_point(next) and not reached.has(next) and not world.is_solid(next):
				reached[next] = true
				queue.append(next)
	return reached


## The rows holding [param feature], as a band as wide as the map.
func _rows_holding(world: WorldMapData, feature: int) -> Rect2i:
	var first := -1
	var last := -1
	for y in world.size().y:
		if _first_tile_of(world, feature, y).x >= 0:
			if first < 0:
				first = y
			last = y
	return Rect2i(0, first, world.size().x, last - first + 1)


## The westernmost tile of row [param y] holding [param feature]; x is -1 when none does.
func _first_tile_of(world: WorldMapData, feature: int, y: int) -> Vector2i:
	for x in world.size().x:
		if world.feature_at(Vector2i(x, y)) == feature:
			return Vector2i(x, y)
	return Vector2i(-1, y)


func _shipped() -> WorldMapData:
	return RoomCatalog.load_folder()[&"world_map"] as WorldMapData


func _world(rows: PackedStringArray) -> WorldMapData:
	var world := WorldMapData.new()
	world.id = &"w"
	world.rows = rows
	return world
