class_name Levels
extends RefCounted
## A wizard's base stats at each level, from FORMULAS.md, section Wizard progression.
##
## This is the automatic part of a level-up; the card taken at each level-up comes on top.


static func health(wizard_level: int) -> int:
	return 100 + 10 * (wizard_level - 1)


static func power(wizard_level: int) -> int:
	return 10 + (wizard_level - 1)


static func magic_defence(wizard_level: int) -> int:
	return 10 + (wizard_level - 1)


static func luck(wizard_level: int) -> int:
	return 5 + floori((wizard_level - 1) / 4.0)


static func base_mana_pool(wizard_level: int) -> int:
	return roundi(100 + 4 * (wizard_level - 1) + 84 * log(wizard_level) / log(30.0))
