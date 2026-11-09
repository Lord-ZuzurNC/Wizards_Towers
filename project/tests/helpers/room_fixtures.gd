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


## A 50 × 30 world map, larger than the screen: the sea along the top, bottom and left
## edges, plains in the middle and forest from column 30 on. Its spawn is tile (10, 15).
static func small_world() -> WorldMapData:
	var rows := PackedStringArray()
	for y in 30:
		var row := ""
		for x in 50:
			if y == 0 or y == 29 or x < 2:
				row += "~"
			elif x >= 30:
				row += "f"
			else:
				row += "."
		rows.append(row)
	var world := WorldMapData.new()
	world.id = &"world"
	world.rows = rows
	world.spawn_tile = Vector2i(10, 15)
	return world


## A 30 × 5 world map with a little of every seasonal ground: the sea along the edges, a
## rift bank in columns 10 to 12 and glacier in columns 20 to 24, plains elsewhere. Its
## spawn is tile (5, 2).
static func seasonal_world() -> WorldMapData:
	var rows := PackedStringArray()
	for y in 5:
		var row := ""
		for x in 30:
			if y == 0 or y == 4 or x < 2 or x > 27:
				row += "~"
			elif x >= 10 and x <= 12:
				row += "r"
			elif x >= 20 and x <= 24:
				row += "g"
			else:
				row += "."
		rows.append(row)
	var world := WorldMapData.new()
	world.id = &"world"
	world.rows = rows
	world.spawn_tile = Vector2i(5, 2)
	return world


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
