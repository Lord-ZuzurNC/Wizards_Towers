class_name Grimoire
extends RefCounted
## The numbered places a wizard casts spells from (GLOSSARY.md, Grimoire position).

const MAX_POSITIONS := 10


## How many Grimoire positions a wizard of [param wizard_level] has (FORMULAS.md).
static func positions(wizard_level: int) -> int:
	return mini(MAX_POSITIONS, 1 + floori((wizard_level - 1) / 3.0))
