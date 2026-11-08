extends TestCase
## The colours a world map is drawn in.


func test_every_tile_kind_has_an_opaque_colour() -> void:
	for character: String in WorldMapData.LEGEND:
		var color := ClientWorld.terrain_color(_world([character.repeat(8)]), Vector2i(3, 0))
		assert_eq(color.a, 1.0, "'%s' is drawn in %s" % [character, color])


func test_both_shades_of_a_biome_appear() -> void:
	var row := ".".repeat(60)
	var world := _world([row])
	var seen := { }
	for x in 60:
		seen[ClientWorld.terrain_color(world, Vector2i(x, 0))] = true
	assert_eq(seen.size(), 2, str(seen.keys()))


func test_each_biome_ground_has_its_own_main_colour() -> void:
	var seen := { }
	for character in ".fmgdhv~":
		seen[ClientWorld.BIOME_GROUND[_world([character]).biome_at(Vector2i.ZERO)]] = true
	assert_eq(seen.size(), 8)


func _world(rows: Array) -> WorldMapData:
	var world := WorldMapData.new()
	world.rows = PackedStringArray(rows)
	return world
