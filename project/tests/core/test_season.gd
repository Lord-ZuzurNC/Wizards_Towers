extends TestCase
## The season clock of a run.


func test_the_four_seasons_come_in_order() -> void:
	assert_eq(Season.at(0, 100), Season.Kind.SPRING)
	assert_eq(Season.at(99, 100), Season.Kind.SPRING)
	assert_eq(Season.at(100, 100), Season.Kind.SUMMER)
	assert_eq(Season.at(250, 100), Season.Kind.AUTUMN)
	assert_eq(Season.at(399, 100), Season.Kind.WINTER)


func test_the_run_is_over_when_winter_runs_out() -> void:
	assert_eq(Season.at(400, 100), -1)


func test_ticks_left_count_down_to_the_next_season() -> void:
	assert_eq(Season.ticks_left(0, 100), 100)
	assert_eq(Season.ticks_left(130, 100), 70)


func test_the_placeholder_season_lasts_two_minutes() -> void:
	assert_eq(PlaceholderValues.new().season_ticks, 2 * 60 * Simulation.TICK_RATE)


func test_water_freezes_in_winter_only() -> void:
	var world := RoomFixtures.seasonal_world()
	var sea := Vector2i(0, 2)
	for kind in Season.COUNT:
		world.season = kind
		assert_eq(world.is_solid(sea), kind != Season.Kind.WINTER, Season.label(kind))
		assert_eq(world.is_frozen_water(sea), kind == Season.Kind.WINTER, Season.label(kind))


func test_frozen_water_does_not_open_the_rest() -> void:
	var world := WorldMapData.new()
	world.rows = PackedStringArray(["^ox"])
	world.season = Season.Kind.WINTER
	for x in 3:
		assert_true(world.is_solid(Vector2i(x, 0)))


func test_each_hazard_holds_in_its_season_only() -> void:
	var world := RoomFixtures.seasonal_world()
	var bank := Vector2i(11, 2)
	var glacier := Vector2i(22, 2)
	var sea := Vector2i(0, 2)
	var expected := {
		Season.Kind.SPRING: [Hazard.Kind.NONE, Hazard.Kind.NONE],
		Season.Kind.SUMMER: [Hazard.Kind.EMBER, Hazard.Kind.NONE],
		Season.Kind.AUTUMN: [Hazard.Kind.NONE, Hazard.Kind.NONE],
		Season.Kind.WINTER: [Hazard.Kind.NONE, Hazard.Kind.RIME],
	}
	for kind: int in expected:
		world.season = kind
		assert_eq(world.hazard_at(bank), expected[kind][0], "bank in %s" % Season.label(kind))
		assert_eq(world.hazard_at(glacier), expected[kind][1], "glacier in %s" % Season.label(kind))
		# Frozen sea is harmless.
		assert_eq(world.hazard_at(sea), Hazard.Kind.NONE)
