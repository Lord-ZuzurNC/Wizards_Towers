class_name Spell
extends RefCounted
## A castable whole, assembled from runes in its five spell slots (GLOSSARY.md, spell).
##
## Each slot holds a rune id and the [Rarity] grade the wizard knows it at.
## Shape, Element and Duration are mandatory; the two Effect slots are optional, ordered,
## and may not hold the same rune. Every number here is computed from the runes, from
## FORMULAS.md, section Magic, never authored.

## The five spell slots, in order: a [code]slot_index[/code] is one of these.
enum Slot {
	SHAPE,
	ELEMENT,
	DURATION,
	EFFECT1,
	EFFECT2,
}

## The [RuneAttribute] each [enum Slot] accepts.
const SLOT_ATTRIBUTES: Array[int] = [
	RuneAttribute.SHAPE,
	RuneAttribute.ELEMENT,
	RuneAttribute.DURATION,
	RuneAttribute.EFFECT,
	RuneAttribute.EFFECT,
]
## Seconds, by Duration rune id.
const BASE_COOLDOWNS: Dictionary[StringName, float] = {
	&"instant": 1.0,
	&"brief": 1.5,
	&"delayed": 1.5,
	&"sustained": 1.0,
	&"lingering": 2.5,
	&"echoing": 3.0,
	&"eternal": 5.0,
}
## By the Element rune's common weight.
const COOLDOWN_MULTIPLIERS: Dictionary[int, float] = { 2: 1.0, 3: 1.15, 4: 1.3, 5: 1.5 }
## Rust is split out of the weight-5 row: the longest cooldown of any element.
const RUST_COOLDOWN_MULTIPLIER := 1.8

var _rune_ids: Array[StringName] = [&"", &"", &"", &"", &""]
var _grades: Array[int] = [
	Rarity.COMMON,
	Rarity.COMMON,
	Rarity.COMMON,
	Rarity.COMMON,
	Rarity.COMMON,
]


## Puts the rune [param rune_id] at [Rarity] [param grade] in [param slot].
##
## Returns [code]false[/code] and changes nothing when the rune is unknown, belongs to
## another attribute than the slot's, the grade is not a [Rarity], or the rune already
## fills the other Effect slot.
func set_rune(slot: Slot, rune_id: StringName, grade := Rarity.COMMON) -> bool:
	var rune := RuneCatalog.find(rune_id)
	if rune == null or rune.attribute != SLOT_ATTRIBUTES[slot]:
		return false
	if grade < Rarity.COMMON or grade > Rarity.LEGENDARY:
		return false
	if slot == Slot.EFFECT1 and _rune_ids[Slot.EFFECT2] == rune_id:
		return false
	if slot == Slot.EFFECT2 and _rune_ids[Slot.EFFECT1] == rune_id:
		return false
	_rune_ids[slot] = rune_id
	_grades[slot] = grade
	return true


func clear(slot: Slot) -> void:
	_rune_ids[slot] = &""
	_grades[slot] = Rarity.COMMON


## The id of the rune in [param slot]; empty when the slot is empty.
func rune_id(slot: Slot) -> StringName:
	return _rune_ids[slot]


## Whether Shape, Element and Duration all hold a rune.
func is_castable() -> bool:
	return (
		not _rune_ids[Slot.SHAPE].is_empty() and not _rune_ids[Slot.ELEMENT].is_empty()
		and not _rune_ids[Slot.DURATION].is_empty()
	)


## The sum of every filled slot's rune weight, each scaled by its own grade.
## Not rounded: it fills the weight bar, which shows no figure.
func spell_weight() -> float:
	var total := 0.0
	for slot: int in Slot.values():
		var rune := RuneCatalog.find(_rune_ids[slot])
		if rune != null:
			total += rune.weight_at(_grades[slot])
	return total


## The mana one cast costs, from [method spell_weight] on a convex curve; at least 1.
func mana_cost() -> int:
	return maxi(1, roundi(0.6 * pow(spell_weight(), 1.3)))


## Seconds before the spell can be cast again, set by its Duration and its Element.
## 0.0 while either slot is empty.
func cooldown() -> float:
	var duration := RuneCatalog.find(_rune_ids[Slot.DURATION])
	var element := RuneCatalog.find(_rune_ids[Slot.ELEMENT])
	if duration == null or element == null:
		return 0.0
	var multiplier := COOLDOWN_MULTIPLIERS[element.weight]
	if element.id == &"rust":
		multiplier = RUST_COOLDOWN_MULTIPLIER
	return BASE_COOLDOWNS[duration.id] * multiplier


## The damage of one hit cast by a combatant of [param power], before magic defence:
## the input of [method Damage.dealt]. Rounded down; 0 while the Element slot is empty.
##
## A method rather than a stored value, because it depends on the caster as much as on
## the spell. At [param power] 10, the level-1 baseline, it equals the Element's
## magnitude at its grade.
func raw_damage(power: int) -> int:
	var element := RuneCatalog.find(_rune_ids[Slot.ELEMENT])
	if element == null:
		return 0
	return floori(element.magnitude_at(_grades[Slot.ELEMENT]) * power / 10.0)
