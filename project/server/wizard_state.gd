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
## The first tick the placeholder spell may be cast again.
var ready_tick := 0
## Card choices earned and not yet taken, oldest first: each is a list of card ids.
var card_choices: Array[PackedStringArray] = []
## Every card taken this run, in order.
var cards_taken: PackedStringArray = []


func max_health() -> int:
	return Levels.health(wizard_level)


func mana_pool() -> int:
	return Levels.base_mana_pool(wizard_level)


func power() -> int:
	return Levels.power(wizard_level)


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
	return gained
