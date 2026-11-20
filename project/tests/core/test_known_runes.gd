extends TestCase
## The runes one wizard may use in a spell (GLOSSARY.md, known rune).


func test_a_rune_never_learned_is_not_known_at_any_grade() -> void:
	var known := KnownRunes.new()
	assert_eq(known.best_grade(&"ember"), -1)
	assert_false(known.knows(&"ember", Rarity.COMMON))


func test_learning_a_rune_knows_it_at_that_grade_and_below() -> void:
	var known := KnownRunes.new()
	known.learn(&"ember", Rarity.RARE)
	assert_eq(known.best_grade(&"ember"), Rarity.RARE)
	assert_true(known.knows(&"ember", Rarity.COMMON))
	assert_true(known.knows(&"ember", Rarity.RARE))
	assert_false(known.knows(&"ember", Rarity.LEGENDARY))


func test_learning_a_lower_grade_again_keeps_the_best_one_found() -> void:
	var known := KnownRunes.new()
	known.learn(&"ember", Rarity.LEGENDARY)
	known.learn(&"ember", Rarity.COMMON)
	assert_eq(known.best_grade(&"ember"), Rarity.LEGENDARY)


func test_the_starter_set_knows_every_rune_at_common_only() -> void:
	var known := KnownRunes.starter()
	for rune_id in RuneCatalog.ids_of(RuneAttribute.SHAPE):
		assert_true(known.knows(rune_id, Rarity.COMMON), rune_id)
		assert_false(known.knows(rune_id, Rarity.RARE), rune_id)
	assert_true(known.knows(&"ember", Rarity.COMMON))
	assert_true(known.knows(&"hunger", Rarity.COMMON))
