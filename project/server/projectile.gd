class_name Projectile
extends RefCounted
## A spell in flight: it travels straight until it hits something, a wall, or its range.

## How close to a combatant's body centre the projectile must come to hit it, in pixels.
const HIT_RADIUS := 10.0
## A combatant's body centre stands this far above its feet.
const BODY_OFFSET := Vector2(0.0, -8.0)

var caster_peer_id := 0
var room_id: StringName
var position := Vector2.ZERO
## Pixels travelled each tick.
var velocity := Vector2.ZERO
var distance_left := 0.0
var raw_damage := 0
## The Grimoire position it was cast from, so a client can draw it in that spell's colour.
var grimoire_position := 1


## Moves one tick. Returns false once the projectile is spent: out of range or in a wall.
func advance(room: RoomData) -> bool:
	position += velocity
	distance_left -= velocity.length()
	return distance_left > 0.0 and not room.is_solid(room.tile_at(position))


func hits(feet_position: Vector2) -> bool:
	return position.distance_to(feet_position + BODY_OFFSET) <= HIT_RADIUS
