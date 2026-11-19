extends TestCase
## Spells assembled from runes: slot rules from GLOSSARY.md, numbers from FORMULAS.md.


func test_a_spell_missing_a_mandatory_slot_is_not_castable() -> void:
	var spell := _bolt_ember_instant()
	assert_true(spell.is_castable())
	spell.clear(Spell.Slot.DURATION)
	assert_false(spell.is_castable())


func test_an_empty_spell_is_not_castable() -> void:
	assert_false(Spell.new().is_castable())


func test_the_same_rune_in_both_effect_slots_is_refused() -> void:
	var spell := _bolt_ember_instant()
	assert_true(spell.set_rune(Spell.Slot.EFFECT1, &"chain"))
	assert_false(spell.set_rune(Spell.Slot.EFFECT2, &"chain"))
	assert_eq(spell.rune_id(Spell.Slot.EFFECT2), &"")


func test_two_different_effects_are_accepted_in_either_order() -> void:
	var spell := _bolt_ember_instant()
	assert_true(spell.set_rune(Spell.Slot.EFFECT2, &"split"))
	assert_true(spell.set_rune(Spell.Slot.EFFECT1, &"chain"))
	assert_false(spell.set_rune(Spell.Slot.EFFECT1, &"split"))


func test_a_rune_of_another_attribute_is_refused() -> void:
	var spell := Spell.new()
	assert_false(spell.set_rune(Spell.Slot.SHAPE, &"ember"))
	assert_false(spell.set_rune(Spell.Slot.EFFECT1, &"bolt"))
	assert_false(spell.set_rune(Spell.Slot.SHAPE, &"no_such_rune"))
	assert_false(spell.set_rune(Spell.Slot.SHAPE, &"bolt", 3))
	assert_eq(spell.rune_id(Spell.Slot.SHAPE), &"")


func test_bolt_ember_instant_at_common_rarity() -> void:
	var spell := _bolt_ember_instant()
	assert_eq(spell.spell_weight(), 4.0)
	# round(0.6 × 4^1.3) = round(3.64)
	assert_eq(spell.mana_cost(), 4)
	assert_eq(spell.cooldown(), 1.0)
	assert_eq(spell.raw_damage(10), 12)


func test_a_legendary_element_hits_harder_and_weighs_more() -> void:
	var spell := _bolt_ember_instant()
	spell.set_rune(Spell.Slot.ELEMENT, &"ember", Rarity.LEGENDARY)
	# Ember: magnitude 12 × 2.5, weight 2 × 2.0.
	assert_eq(spell.raw_damage(10), 30)
	assert_eq(spell.spell_weight(), 6.0)
	# round(0.6 × 6^1.3) = round(6.16)
	assert_eq(spell.mana_cost(), 6)


func test_raw_damage_grows_with_power() -> void:
	var spell := _bolt_ember_instant()
	assert_eq(spell.raw_damage(20), 24)
	# 12 × 15 / 10 = 18; 12 × 13 / 10 = 15.6, rounded down.
	assert_eq(spell.raw_damage(15), 18)
	assert_eq(spell.raw_damage(13), 15)


func test_cooldown_follows_duration_and_element_weight() -> void:
	var spell := _bolt_ember_instant()
	spell.set_rune(Spell.Slot.DURATION, &"eternal")
	assert_eq(spell.cooldown(), 5.0)
	spell.set_rune(Spell.Slot.ELEMENT, &"null")
	assert_eq(spell.cooldown(), 7.5)


func test_rust_has_its_own_longer_cooldown() -> void:
	var spell := _bolt_ember_instant()
	spell.set_rune(Spell.Slot.ELEMENT, &"rust")
	assert_true(is_equal_approx(spell.cooldown(), 1.8), str(spell.cooldown()))
	spell.set_rune(Spell.Slot.ELEMENT, &"unmaking")
	assert_true(is_equal_approx(spell.cooldown(), 1.5), str(spell.cooldown()))


func test_every_element_and_duration_has_a_cooldown() -> void:
	var spell := _bolt_ember_instant()
	for element_id in RuneCatalog.ids_of(RuneAttribute.ELEMENT):
		spell.set_rune(Spell.Slot.ELEMENT, element_id)
		for duration_id in RuneCatalog.ids_of(RuneAttribute.DURATION):
			spell.set_rune(Spell.Slot.DURATION, duration_id)
			assert_true(spell.cooldown() >= 1.0, "%s %s" % [element_id, duration_id])


func test_effects_add_their_weight() -> void:
	var spell := _bolt_ember_instant()
	spell.set_rune(Spell.Slot.EFFECT1, &"chain")
	spell.set_rune(Spell.Slot.EFFECT2, &"hunger", Rarity.LEGENDARY)
	# 4 + 3 + 5 × 2.0
	assert_eq(spell.spell_weight(), 17.0)


func _bolt_ember_instant() -> Spell:
	var spell := Spell.new()
	spell.set_rune(Spell.Slot.SHAPE, &"bolt")
	spell.set_rune(Spell.Slot.ELEMENT, &"ember")
	spell.set_rune(Spell.Slot.DURATION, &"instant")
	return spell
