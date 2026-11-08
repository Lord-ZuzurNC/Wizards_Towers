class_name RoomData
extends Resource
## One room: its walls, its exits and where a newcomer appears.
##
## The layout is written as text, one string per row of tiles, so it reads in the
## inspector and in the .tres file alike:
## [codeblock lang=text]
## ########
## #......#
## #..##...   "#" is a wall, "." is floor
## ########
## [/codeblock]
## A room is at most 40 × 20 tiles: one screen, the rest holding the HUD (ART_DIRECTION.md).

const WALL := "#"
const FLOOR := "."
const MAX_SIZE := Vector2i(40, 20)

@export var id: StringName
@export var rows: PackedStringArray = []
@export var exits: Array[RoomExit] = []
## The tile where a wizard entering the world appears.
@export var spawn_tile := Vector2i()
## Where training dummies stand, one per tile.
@export var dummy_tiles: Array[Vector2i] = []


## The room's size in tiles.
func size() -> Vector2i:
	if rows.is_empty():
		return Vector2i.ZERO
	return Vector2i(rows[0].length(), rows.size())


## Whether [param tile] blocks movement. Everything outside the room does.
func is_solid(tile: Vector2i) -> bool:
	if tile.y < 0 or tile.y >= rows.size() or tile.x < 0 or tile.x >= rows[tile.y].length():
		return true
	return rows[tile.y][tile.x] == WALL


## The centre of [param tile], in pixels.
func tile_center(tile: Vector2i) -> Vector2:
	return (Vector2(tile) + Vector2(0.5, 0.5)) * Simulation.TILE_SIZE


## The tile holding the point [param position], given in pixels.
func tile_at(position: Vector2) -> Vector2i:
	return Vector2i((position / Simulation.TILE_SIZE).floor())


## The exit whose area holds [param position], or null when there is none.
func exit_at(position: Vector2) -> RoomExit:
	var tile := tile_at(position)
	for room_exit in exits:
		if room_exit.area.has_point(tile):
			return room_exit
	return null


## Everything wrong with the room, one line each. Empty when the room is sound.
## [param known_rooms] lists the room ids an exit may lead to.
func validate(known_rooms: Array[StringName]) -> PackedStringArray:
	var problems := PackedStringArray()
	if id.is_empty():
		problems.append("the room has no id")
	if rows.is_empty():
		problems.append("the room has no rows")
		return problems
	var width := rows[0].length()
	for y in rows.size():
		if rows[y].length() != width:
			problems.append("row %d is %d tiles long, not %d" % [y, rows[y].length(), width])
		for character in rows[y]:
			if character != WALL and character != FLOOR:
				problems.append("row %d holds '%s', neither wall nor floor" % [y, character])
				break
	if width > MAX_SIZE.x or rows.size() > MAX_SIZE.y:
		problems.append(
			"the room is %d × %d tiles, more than %d × %d"
			% [width, rows.size(), MAX_SIZE.x, MAX_SIZE.y]
		)
	if is_solid(spawn_tile):
		problems.append("the spawn tile %s is not floor" % spawn_tile)
	for tile in dummy_tiles:
		if is_solid(tile):
			problems.append("the dummy tile %s is not floor" % tile)
	for room_exit in exits:
		if not Rect2i(Vector2i.ZERO, size()).encloses(room_exit.area):
			problems.append("an exit lies outside the room: %s" % room_exit.area)
		if not known_rooms.has(room_exit.target_room):
			problems.append("an exit leads to an unknown room '%s'" % room_exit.target_room)
	return problems
