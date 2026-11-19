class_name Rune
extends RefCounted
## The atomic spell ingredient, at its common-rarity values (RUNES.md).
##
## A [RefCounted] rather than a [Resource]: every rune is built in code by [RuneCatalog]
## from the tables in RUNES.md, never saved to or loaded from a file.
## Rarity is not stored here: a wizard's rune carries its own [Rarity] grade, and
## [method weight_at] and [method magnitude_at] scale the common values by it.

## Where a spell acts (GLOSSARY.md, reach). A property of the Shape rune, never chosen.
## [constant NONE] marks every rune that is not a Shape.
enum Reach {
	NONE,
	SELF,
	MELEE,
	RANGED,
	PLACED,
}

## By [Rarity] grade, from FORMULAS.md, section Magic.
const MAGNITUDE_MULTIPLIERS: Array[float] = [1.0, 1.6, 2.5]
const WEIGHT_MULTIPLIERS: Array[float] = [1.0, 1.4, 2.0]

var id: StringName
## A [RuneAttribute] value.
var attribute: int
## The cost pressure at common rarity, 0 to 6.
var weight: int
## The common-rarity [code]base_magnitude[/code] of an Element rune; 0 on every other.
var magnitude: int
## Meaningful on a Shape rune only; [constant Reach.NONE] on every other.
var reach: Reach


func _init(
	init_id: StringName,
	init_attribute: int,
	init_weight: int,
	init_magnitude := 0,
	init_reach := Reach.NONE,
) -> void:
	id = init_id
	attribute = init_attribute
	weight = init_weight
	magnitude = init_magnitude
	reach = init_reach


## This rune's weight at [Rarity] [param grade].
func weight_at(grade: int) -> float:
	return weight * WEIGHT_MULTIPLIERS[clampi(grade, Rarity.COMMON, Rarity.LEGENDARY)]


## This rune's magnitude at [Rarity] [param grade]; 0 unless it is an Element.
func magnitude_at(grade: int) -> float:
	return magnitude * MAGNITUDE_MULTIPLIERS[clampi(grade, Rarity.COMMON, Rarity.LEGENDARY)]
