class_name RoomFixtures
extends RefCounted
## Small rooms built in code, so a test states the exact layout it relies on.


## A room from [param rows], with no exit and its spawn on [param spawn_tile].
static func make(id: StringName, rows: PackedStringArray, spawn_tile := Vector2i(1, 1)) -> RoomData:
	var room := RoomData.new()
	room.id = id
	room.rows = rows
	room.spawn_tile = spawn_tile
	return room


## Two 8 × 3 rooms joined by a door: [code]left[/code] opens on its right edge into
## [code]right[/code], which opens on its left edge back into [code]left[/code].
static func two_joined_rooms() -> Dictionary[StringName, RoomData]:
	var left := make(
		&"left",
		PackedStringArray(["########", "#.......", "########"]),
		Vector2i(4, 1),
	)
	var to_right := RoomExit.new()
	to_right.area = Rect2i(7, 1, 1, 1)
	to_right.target_room = &"right"
	to_right.target_tile = Vector2i(2, 1)
	left.exits = [to_right]
	var right := make(
		&"right",
		PackedStringArray(["########", ".......#", "########"]),
		Vector2i(4, 1),
	)
	var to_left := RoomExit.new()
	to_left.area = Rect2i(0, 1, 1, 1)
	to_left.target_room = &"left"
	to_left.target_tile = Vector2i(5, 1)
	right.exits = [to_left]
	return { &"left": left, &"right": right }
