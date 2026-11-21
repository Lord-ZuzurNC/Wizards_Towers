class_name WizardState
extends RefCounted
## What the server knows of one wizard: where it stands, its stats and its progress.

var room_id: StringName
var position := Vector2.ZERO
var speed := Simulation.BASE_SPEED
var inputs := InputBuffer.new()
var wizard_level := 1
var xp := 0
var health := Levels.health(1)
var mana := Levels.base_mana_pool(1)
## Fractions of a mana point regained but not yet whole.
var mana_carry := 0.0
## For each Grimoire position, index 0 for position 1: the first tick its spell may be
## cast again.
var ready_ticks := PackedInt32Array()
## The runes this wizard may use in a spell (GLOSSARY.md, known rune).
var known_runes := KnownRunes.starter()
## One [Spell] per Grimoire position, index 0 for position 1. Empty (not castable) until
## edited, except position 0's default.
var grimoire: Array[Spell] = []
## Card choices earned and not yet taken, oldest first: each is a list of card ids.
var card_choices: Array[PackedStringArray] = []
## Every card taken this run, in order.
var cards_taken: PackedStringArray = []
var gold := 0
## Villages bought this run, kept or not: the n of the escalating price (FORMULAS.md).
var village_purchases := 0
## A village asked for and not yet judged, by its index in the room; -1 for none. It is
## judged once the movement input [member purchase_after] has been applied, so the wizard
## stands where its player saw it when pressing the key.
var pending_purchase := -1
## The tick Ember's burn ends; it hurts on the hazard's beat until then.
var burning_until := 0
## The tick Rime's slow ends.
var slowed_until := 0
var purchase_after := 0
## GLOSSARY.md, peace shield. Only its state is kept: nothing reads it yet, since no wizard
## can hit another (see [method break_peace_shield]).
var peace_shield_active := true
## Set once health reaches 0. A dead wizard stays where it fell until the run ends.
var is_dead := false
## A [enum WizardEnding.Kind], or -1 while alive.
var ending := -1


func _init() -> void:
	ready_ticks.resize(Grimoire.MAX_POSITIONS)
	grimoire = default_grimoire()


## RUNES.md, Shape: Bolt is "the default of every new wizard"; Ember is "the reliable
## one". The other Grimoire positions start empty.
static func default_grimoire() -> Array[Spell]:
	var spells: Array[Spell] = []
	for i in Grimoire.MAX_POSITIONS:
		spells.append(Spell.new())
	spells[0].set_rune(Spell.Slot.SHAPE, &"bolt")
	spells[0].set_rune(Spell.Slot.ELEMENT, &"ember")
	spells[0].set_rune(Spell.Slot.DURATION, &"instant")
	return spells


func is_burning(tick: int) -> bool:
	return tick < burning_until


func is_slowed(tick: int) -> bool:
	return tick < slowed_until


func max_health() -> int:
	return Levels.health(wizard_level)


func mana_pool() -> int:
	return Levels.base_mana_pool(wizard_level)


func power() -> int:
	return Levels.power(wizard_level)


func village_price(values: PlaceholderValues) -> int:
	return Price.escalating(
		values.village_base_price,
		values.village_price_multiplier,
		village_purchases,
	)


## Adds [param amount] XP and levels up as many times as it pays for. Each level-up raises
## health and mana by what the new level adds, and returns how many levels were gained.
func gain_xp(amount: int, xp_per_level: int) -> int:
	xp += amount
	var gained := 0
	while xp >= xp_per_level:
		xp -= xp_per_level
		var old_health := max_health()
		var old_mana := mana_pool()
		wizard_level += 1
		health += max_health() - old_health
		mana += mana_pool() - old_mana
		gained += 1
	if wizard_level >= 2:
		break_peace_shield()
	return gained


## Turns the peace shield off for good; harmless when it already is. Called on reaching
## level 2 and on entering a dungeon. Not yet called on the wizard's first attack: that
## waits on wizard-vs-wizard combat, and a hit on a training dummy must not count, or every
## newcomer would lose it while learning to cast. Nor does the shield block anything yet:
## there is no damage from another wizard for it to block.
func break_peace_shield() -> void:
	peace_shield_active = false
