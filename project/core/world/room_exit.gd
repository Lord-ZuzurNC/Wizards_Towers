class_name RoomExit
extends Resource
## A stretch of a room's floor that leads into another room.
##
## A wizard whose feet stand inside [member area] is moved to [member target_tile] of
## [member target_room]. The target tile must lie outside that room's own exits, or the
## wizard would bounce straight back.

## The tiles that trigger the exit, in the room's tile coordinates.
@export var area := Rect2i()
@export var target_room: StringName
## Where the wizard appears in the target room, in its tile coordinates.
@export var target_tile := Vector2i()
