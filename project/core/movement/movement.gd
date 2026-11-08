class_name Movement
extends RefCounted
## How a combatant walks: one simulation tick at a time, stopped by walls.
##
## The same function runs on the server, which decides, and on the client, which predicts
## its own wizard with it. Both must get the same answer from the same inputs, so it uses
## no physics engine and no randomness: plain arithmetic on a grid of tiles.
##
## A direction travels as a single number from 0 to 8, a [i]direction code[/i]:
## [code](x + 1) + (y + 1) × 3[/code], with x and y each -1, 0 or 1. Code 4 is standing still.

const IDLE := 4
const MAX_CODE := 8
## The part of a combatant that collides with walls: a box at its feet, centred on its
## position. Smaller than the sprite, so a wizard can walk with its head in front of a wall.
const FEET_SIZE := Vector2(10.0, 6.0)


static func encode(direction: Vector2i) -> int:
	return (clampi(direction.x, -1, 1) + 1) + (clampi(direction.y, -1, 1) + 1) * 3


static func decode(code: int) -> Vector2i:
	if code < 0 or code > MAX_CODE:
		return Vector2i.ZERO
	return Vector2i(code % 3 - 1, int(code / 3.0) - 1)


## Where a combatant at [param position] stands after one tick walking along
## [param code] at [param speed]. A diagonal is as fast as a straight line.
## Each axis moves on its own, so a wizard pushing into a wall diagonally slides along it.
static func step(position: Vector2, code: int, speed: int, room: RoomData) -> Vector2:
	var direction := Vector2(decode(code))
	if direction == Vector2.ZERO:
		return position
	var delta := direction.normalized() * Simulation.pixels_per_tick(speed)
	var moved := _move_axis(position, Vector2(delta.x, 0.0), room)
	return _move_axis(moved, Vector2(0.0, delta.y), room)


## The collision box at [param position].
static func feet_box(position: Vector2) -> Rect2:
	return Rect2(position - FEET_SIZE / 2.0, FEET_SIZE)


## Moves along one axis, then pulls back against the first wall the box would enter.
static func _move_axis(position: Vector2, delta: Vector2, room: RoomData) -> Vector2:
	if delta == Vector2.ZERO:
		return position
	var target := position + delta
	var half := FEET_SIZE / 2.0
	var box := feet_box(target)
	var tile := float(Simulation.TILE_SIZE)
	for y in range(floori(box.position.y / tile), ceili(box.end.y / tile)):
		for x in range(floori(box.position.x / tile), ceili(box.end.x / tile)):
			if not room.is_solid(Vector2i(x, y)):
				continue
			if delta.x > 0.0:
				target.x = minf(target.x, x * tile - half.x)
			elif delta.x < 0.0:
				target.x = maxf(target.x, (x + 1) * tile + half.x)
			elif delta.y > 0.0:
				target.y = minf(target.y, y * tile - half.y)
			else:
				target.y = maxf(target.y, (y + 1) * tile + half.y)
	return target
