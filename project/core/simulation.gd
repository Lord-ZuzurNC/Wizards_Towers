class_name Simulation
extends RefCounted
## The fixed numbers every part of the simulation agrees on, server and client alike.
##
## See TECH_STACK.md, section Netcode, and WORLD_MAP.md, section Scale.

## Simulation ticks a second. [code]project.godot[/code] sets the physics tick rate to match.
const TICK_RATE := 30
const TILE_SIZE := 16
## A wizard's [code]speed[/code] at level 1, a normal walk.
const BASE_SPEED := 100
## [code]speed[/code] 100 walks 4 tiles a second.
const TILES_PER_SECOND_AT_BASE_SPEED := 4.0


## How far a combatant of [param speed] moves in one simulation tick, in pixels.
static func pixels_per_tick(speed: int) -> float:
	var tiles_per_second := TILES_PER_SECOND_AT_BASE_SPEED * speed / BASE_SPEED
	return tiles_per_second * TILE_SIZE / TICK_RATE
