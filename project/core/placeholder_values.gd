class_name PlaceholderValues
extends Resource
## Every number the design has not settled yet, gathered in one place.
##
## The game needs these to run, but none of them is a design decision: each stands in until
## FORMULAS.md, RUNES.md or CARDS.md settles it, and is then replaced by the real rule.
## Keeping them together means nothing provisional hides in the code.
## The values in use live in [code]data/placeholder_values.tres[/code].

const DEFAULT_PATH := "res://data/placeholder_values.tres"

## XP needed for each level-up, the same at every level. FORMULAS.md: XP per wizard_level ⬜.
@export var xp_per_level := 10
## Mana regained each second. No rule written yet.
@export var mana_per_second := 5
@export_group("Placeholder spell")
## The one spell, in Grimoire position 1, standing in until spells are composed from runes.
@export var spell_raw_damage := 10
@export var spell_mana_cost := 10
## FORMULAS.md: cooldown ⬜.
@export var spell_cooldown_ticks := 15
@export var spell_projectile_speed := 8.0
@export var spell_range_tiles := 12.0
@export_group("Training dummy")
@export var dummy_health := 30
@export var dummy_magic_defence := 10
@export var dummy_xp := 10
@export var dummy_respawn_ticks := 90


static func load_default() -> PlaceholderValues:
	return load(DEFAULT_PATH) as PlaceholderValues
