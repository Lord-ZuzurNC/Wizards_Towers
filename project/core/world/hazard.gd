class_name Hazard
extends RefCounted
## Ground that hurts in its season (WORLD_MAP.md, Hazards; FORMULAS.md, Hazards).

## Which Element rune's damage and side effect the ground deals.
enum Kind {
	NONE,
	EMBER,
	RIME,
}

## FORMULAS.md: 15 simulation ticks, so 2 hits a second.
const INTERVAL_TICKS := 15
