class_name RoomCatalog
extends RefCounted
## Loads every room of a folder and checks them before anything uses them.

const DEFAULT_FOLDER := "res://data/rooms"


## Every [RoomData] in [param folder], by id. Pushes an error for each unsound room and
## leaves it out, so a broken room is caught at start and never half-used.
static func load_folder(folder := DEFAULT_FOLDER) -> Dictionary[StringName, RoomData]:
	var rooms: Dictionary[StringName, RoomData] = { }
	for file in ResourceLoader.list_directory(folder):
		var room := load(folder.path_join(file)) as RoomData
		if room != null:
			rooms[room.id] = room
	return check(rooms)


## Returns the sound rooms of [param rooms]; pushes an error for every other.
static func check(rooms: Dictionary[StringName, RoomData]) -> Dictionary[StringName, RoomData]:
	var known: Array[StringName] = []
	known.assign(rooms.keys())
	var sound: Dictionary[StringName, RoomData] = { }
	for id: StringName in rooms:
		var problems := rooms[id].validate(known)
		if problems.is_empty():
			sound[id] = rooms[id]
		else:
			push_error("room '%s' is unsound: %s" % [id, "; ".join(problems)])
	return sound
