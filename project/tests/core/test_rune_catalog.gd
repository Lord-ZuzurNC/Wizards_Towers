extends TestCase
## The rune catalogue against the tables of RUNES.md.


func test_it_holds_77_runes_across_the_four_attributes() -> void:
	assert_eq(RuneCatalog.ids_of(RuneAttribute.SHAPE).size(), 21)
	assert_eq(RuneCatalog.ids_of(RuneAttribute.ELEMENT).size(), 14)
	assert_eq(RuneCatalog.ids_of(RuneAttribute.DURATION).size(), 7)
	assert_eq(RuneCatalog.ids_of(RuneAttribute.EFFECT).size(), 35)


func test_weights_match_the_tables() -> void:
	assert_eq(RuneCatalog.find(&"bolt").weight, 1)
	assert_eq(RuneCatalog.find(&"judgement").weight, 6)
	assert_eq(RuneCatalog.find(&"instant").weight, 1)
	assert_eq(RuneCatalog.find(&"eternal").weight, 5)
	assert_eq(RuneCatalog.find(&"hunger").weight, 5)


func test_element_magnitudes_match_the_table() -> void:
	assert_eq(_weight_and_magnitude(&"ember"), [2, 12])
	assert_eq(_weight_and_magnitude(&"stone"), [3, 16])
	assert_eq(_weight_and_magnitude(&"radiance"), [4, 20])
	assert_eq(_weight_and_magnitude(&"null"), [5, 24])
	assert_eq(_weight_and_magnitude(&"rust"), [5, 24])


func test_only_elements_carry_a_magnitude() -> void:
	for attribute: int in [RuneAttribute.SHAPE, RuneAttribute.DURATION, RuneAttribute.EFFECT]:
		for rune_id in RuneCatalog.ids_of(attribute):
			assert_eq(RuneCatalog.find(rune_id).magnitude, 0, rune_id)


func test_reach_belongs_to_shapes_only() -> void:
	assert_eq(RuneCatalog.find(&"bolt").reach, Rune.Reach.RANGED)
	assert_eq(RuneCatalog.find(&"slash").reach, Rune.Reach.MELEE)
	assert_eq(RuneCatalog.find(&"nova").reach, Rune.Reach.SELF)
	assert_eq(RuneCatalog.find(&"seed").reach, Rune.Reach.PLACED)
	assert_eq(RuneCatalog.find(&"ember").reach, Rune.Reach.NONE)


func test_reach_distribution_matches_the_table() -> void:
	# RUNES.md: 4 self, 2 melee, 8 ranged, 7 placed.
	var counts: Dictionary[Rune.Reach, int] = { }
	for rune_id in RuneCatalog.ids_of(RuneAttribute.SHAPE):
		var reach := RuneCatalog.find(rune_id).reach
		counts[reach] = counts.get(reach, 0) + 1
	assert_eq(counts[Rune.Reach.SELF], 4)
	assert_eq(counts[Rune.Reach.MELEE], 2)
	assert_eq(counts[Rune.Reach.RANGED], 8)
	assert_eq(counts[Rune.Reach.PLACED], 7)


func test_an_unknown_id_finds_nothing() -> void:
	assert_true(RuneCatalog.find(&"patient") == null)


func test_rarity_scales_weight_and_magnitude() -> void:
	var ember := RuneCatalog.find(&"ember")
	assert_eq(ember.weight_at(Rarity.LEGENDARY), 4.0)
	assert_eq(ember.magnitude_at(Rarity.LEGENDARY), 30.0)
	assert_true(is_equal_approx(ember.weight_at(Rarity.RARE), 2.8), str(ember.weight_at(1)))
	assert_true(is_equal_approx(ember.magnitude_at(Rarity.RARE), 19.2), str(ember.magnitude_at(1)))


func _weight_and_magnitude(rune_id: StringName) -> Array[int]:
	var rune := RuneCatalog.find(rune_id)
	return [rune.weight, rune.magnitude]
