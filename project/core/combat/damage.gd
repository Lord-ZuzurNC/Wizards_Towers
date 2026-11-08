class_name Damage
extends RefCounted
## How much of a hit gets through, from FORMULAS.md, section Combat.

## The defence that halves a hit.
const K := 60


## A hit of [param raw_damage] against [param magic_defence], with [param penetration]
## from 0 to 1 ignoring that share of the defence. Rounded down, and never below 1.
static func dealt(raw_damage: int, magic_defence: int, penetration := 0.0) -> int:
	var effective := magic_defence * (1.0 - clampf(penetration, 0.0, 1.0))
	return maxi(1, floori(raw_damage * K / (K + effective)))
