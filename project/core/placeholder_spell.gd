class_name PlaceholderSpell
extends Resource
## A spell standing in until spells are composed from runes (RUNES.md): a straight
## projectile, with numbers no rule has settled yet. See [PlaceholderValues].

@export var raw_damage := 10
@export var mana_cost := 10
## FORMULAS.md: cooldown ⬜.
@export var cooldown_ticks := 15
## Pixels a tick.
@export var projectile_speed := 8.0
@export var range_tiles := 12.0
## How its projectile and its place in the spell bar are drawn.
@export var color := Color("ff695a")


static func make(
	damage: int,
	mana: int,
	cooldown: int,
	speed: float,
	reach: float,
	shade: Color,
) -> PlaceholderSpell:
	var spell := PlaceholderSpell.new()
	spell.raw_damage = damage
	spell.mana_cost = mana
	spell.cooldown_ticks = cooldown
	spell.projectile_speed = speed
	spell.range_tiles = reach
	spell.color = shade
	return spell
