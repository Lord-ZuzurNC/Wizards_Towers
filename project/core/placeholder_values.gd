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
@export_group("Placeholder spells")
## One spell per Grimoire position, 1 to 10, standing in until spells are composed from
## runes. Their speeds follow what TECH_STACK.md, Controls, says each position suits:
## the fastest on 1 to 3, slow on 4 and 5, fast on 6 to 8, the slowest on 9 and 10.
@export var spells: Array[PlaceholderSpell] = []
## Opens all ten Grimoire positions from level 1, to try every key. Off, a wizard has the
## positions of its level (FORMULAS.md), without the mana-stone each one costs.
@export var open_every_grimoire_position := true
@export_group("Seasons and hazards")
## A season's length. GLOSSARY.md says 48 hours; 2 minutes keeps a whole run to 8.
@export var season_ticks := 2 * 60 * Simulation.TICK_RATE
## FORMULAS.md, Hazards: hazard_raw_damage, provisional until the runes have base damage.
@export var hazard_raw_damage := 1
## Ember's burn: how long it lasts after the last hazard hit, and what each burn hit deals.
## RUNES.md says only "a short burn"; it hits on the hazard's own beat, twice a second.
@export var burn_ticks := 60
@export var burn_raw_damage := 1
## Rime's slow: how long it lasts after the last hazard hit, and the share of speed it takes.
## RUNES.md says only "a brief slow".
@export var slow_ticks := 30
@export var slow_share := 0.3
@export_group("Gold and villages")
## Gold a wizard enters the world with.
@export var starting_gold := 0
## FORMULAS.md: base_price and multiplier for villages ⬜.
@export var village_base_price := 20
@export var village_price_multiplier := 2.0
## How close a wizard's feet must stand to a village's centre to buy it, in tiles.
@export var village_reach_tiles := 1.5
@export_group("Training dummy")
@export var dummy_health := 30
@export var dummy_magic_defence := 10
@export var dummy_xp := 10
@export var dummy_gold := 10
@export var dummy_respawn_ticks := 90


func _init() -> void:
	spells = default_spells()


## The ten spells in use unless data/placeholder_values.tres says otherwise.
static func default_spells() -> Array[PlaceholderSpell]:
	return [
		# 1 to 3: the fastest.
		PlaceholderSpell.make(6, 4, 6, 10.0, 10.0, Color("ff695a")),
		PlaceholderSpell.make(6, 4, 6, 10.0, 10.0, Color("50b9eb")),
		PlaceholderSpell.make(6, 4, 6, 10.0, 10.0, Color("8cff9b")),
		# 4 and 5: slow.
		PlaceholderSpell.make(25, 20, 45, 6.0, 14.0, Color("b483ef")),
		PlaceholderSpell.make(25, 20, 45, 6.0, 14.0, Color("ffe091")),
		# 6 to 8: fast.
		PlaceholderSpell.make(12, 8, 15, 8.0, 12.0, Color("ff6eaf")),
		PlaceholderSpell.make(12, 8, 15, 8.0, 12.0, Color("27d3cb")),
		PlaceholderSpell.make(12, 8, 15, 8.0, 12.0, Color("afd370")),
		# 9 and 10: the slowest.
		PlaceholderSpell.make(60, 40, 150, 5.0, 16.0, Color("ffffff")),
		PlaceholderSpell.make(60, 40, 150, 5.0, 16.0, Color("e54286")),
	]


static func load_default() -> PlaceholderValues:
	return load(DEFAULT_PATH) as PlaceholderValues
