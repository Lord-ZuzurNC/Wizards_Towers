class_name WorldMapGenerator
extends RefCounted
## Builds a fresh world map from scratch — a new layout each time a run collapses
## (GLOSSARY.md, World endings), not the same one forever.
##
## The shape is deliberate, not organic noise everywhere: the mountain spine and the
## volcanic rift are built as unbroken walls across a band of rows, because the game relies
## on them actually blocking a straight line through (see the "cannot be crossed" tests on
## [WorldMapData]). Softer biomes (forest, marsh, glacier, desert) are grown as blobs that
## never reach that far. Every candidate map is checked — full connectivity, no forest or
## glacier touching volcanic ground, every biome and feature present — before it is used; a
## failing candidate is thrown away and retried with the same [RandomNumberGenerator], so a
## caller never sees a broken map.

## WORLD_MAP.md has the real map at 2 560 tiles a side; this placeholder generator stays at
## the hand-made map's old size so the rest of the game (the HUD, the camera, the dungeon
## doors) sees nothing larger than it already handles.
const SIZE := Vector2i(120, 68)
const BORDER := 3
const ATTEMPTS := 50

const PLAINS := "."

## A row of a grid still being built: one character per tile, mutable in place.
const NEIGHBOURS_4: Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),
]
const NEIGHBOURS_8: Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),
	Vector2i(1, 1),
	Vector2i(-1, -1),
	Vector2i(1, -1),
	Vector2i(-1, 1),
]


## A sound, freshly laid out world map: just the terrain and the Monolith, nothing walking
## on it yet. [param rng] is advanced as it goes; call [method place_points_of_interest]
## next to add dummies, villages and dungeon doors.
static func generate_terrain(rng: RandomNumberGenerator) -> WorldMapData:
	for _attempt in ATTEMPTS:
		var grid := _build(rng)
		if _is_sound(grid):
			return _to_world_map(grid)
	push_error("WorldMapGenerator: no sound map in %d attempts" % ATTEMPTS)
	return _to_world_map(_build(rng))


static func _to_world_map(grid: Array[PackedStringArray]) -> WorldMapData:
	var map := WorldMapData.new()
	map.id = &"world_map"
	map.title = "World map"
	map.rows = _rows_of(grid)
	map.random_spawn = true
	return map


## Scatters dummies, villages and one door per entry of [param dungeon_rooms] onto
## [param map]'s walkable ground, far enough apart not to overlap. Returns the door tile
## chosen for each dungeon, in the same order, so the caller can also point that dungeon's
## own exit back near the right spot (see [method nearby_open_tile]).
static func place_points_of_interest(
	map: WorldMapData,
	rng: RandomNumberGenerator,
	dungeon_rooms: Array[StringName],
) -> Array[Vector2i]:
	var centre := Vector2i(SIZE.x / 2, SIZE.y / 2)
	var taken: Array[Vector2i] = [centre]

	var dummies := _pick_spaced(map, rng, 10, 6.0, taken)
	taken.append_array(dummies)
	var village_tiles := _pick_spaced(map, rng, 5, 10.0, taken)
	taken.append_array(village_tiles)
	var dungeon_doors := _pick_spaced(map, rng, dungeon_rooms.size(), 14.0, taken)

	map.dummy_tiles.assign(dummies)
	map.villages.clear()
	var titles := ["Village One", "Village Two", "Village Three", "Village Four", "Village Five"]
	for i in village_tiles.size():
		var village := VillageSite.new()
		village.title = titles[i] if i < titles.size() else "Village %d" % (i + 1)
		village.tile = village_tiles[i]
		map.villages.append(village)

	map.spawn_tile = dummies[0] if not dummies.is_empty() else centre

	map.exits.clear()
	for i in dungeon_rooms.size():
		var room_exit := RoomExit.new()
		room_exit.area = Rect2i(dungeon_doors[i], Vector2i.ONE)
		room_exit.target_room = dungeon_rooms[i]
		# Matches the dungeon rooms' own door row (data/rooms/dungeon_*_entrance.tres).
		room_exit.target_tile = Vector2i(1, 10)
		map.exits.append(room_exit)
	return dungeon_doors


## A walkable tile next to [param tile] on [param map] — used to land a dungeon's own exit
## just beside its world-map door, not exactly on it (landing back on the door would bounce
## the wizard straight back in).
static func nearby_open_tile(map: WorldMapData, tile: Vector2i) -> Vector2i:
	var offsets: Array[Vector2i] = NEIGHBOURS_4.duplicate()
	offsets.append_array([Vector2i(2, 0), Vector2i(-2, 0), Vector2i(0, 2), Vector2i(0, -2)])
	for offset in offsets:
		var candidate := tile + offset
		if not map.is_solid(candidate):
			return candidate
	return tile

## --- terrain --------------------------------------------------------------------------


static func _build(rng: RandomNumberGenerator) -> Array[PackedStringArray]:
	var grid: Array[PackedStringArray] = []
	for _y in SIZE.y:
		var row := PackedStringArray()
		row.resize(SIZE.x)
		row.fill(PLAINS)
		grid.append(row)

	for y in SIZE.y:
		for x in SIZE.x:
			if x < BORDER or x >= SIZE.x - BORDER or y < BORDER or y >= SIZE.y - BORDER:
				grid[y][x] = "~"

	var spine_top := rng.randi_range(8, 16)
	var spine_bottom: int = mini(SIZE.y - 6, spine_top + rng.randi_range(16, 24))
	var spine_half := rng.randi_range(6, 9)
	var cur := rng.randi_range(35, 70)
	for y in range(spine_top, spine_bottom):
		cur = clampi(cur + rng.randi_range(-1, 1), 10, SIZE.x - 10)
		for dx in range(-spine_half, spine_half + 1):
			var x := cur + dx
			if x >= BORDER and x < SIZE.x - BORDER:
				grid[y][x] = "h"
		grid[y][cur] = "^"

	var rift_top: int = rng.randi_range(spine_bottom + 2, mini(SIZE.y - 20, spine_bottom + 8))
	var rift_bottom: int = mini(SIZE.y - 6, rift_top + rng.randi_range(14, 20))
	var volc_half := rng.randi_range(7, 10)
	var rift_cur := rng.randi_range(35, 75)
	var rift_cells: Dictionary[int, int] = { }
	for y in range(rift_top, rift_bottom):
		rift_cur = clampi(rift_cur + rng.randi_range(-1, 1), 10, SIZE.x - 10)
		for dx in range(-volc_half, volc_half + 1):
			var x := rift_cur + dx
			if x >= BORDER and x < SIZE.x - BORDER:
				grid[y][x] = "v"
		grid[y][rift_cur - 1] = "r"
		grid[y][rift_cur + 1] = "r"
		grid[y][rift_cur] = "x"
		rift_cells[y] = rift_cur

	# A crater, carved into volcanic ground a few tiles clear of the rift's own barrier
	# columns, so the barrier stays intact.
	if not rift_cells.is_empty():
		var crater_y: int = rift_top + (rift_bottom - rift_top) / 2
		var crater_cx: int = rift_cells.get(crater_y, rift_cur) + volc_half - 2
		for dy in range(-2, 3):
			for dx in range(-2, 3):
				if dx * dx + dy * dy <= 5:
					var x := crater_cx + dx
					var y := crater_y + dy
					if y >= 0 and y < SIZE.y and x >= 0 and x < SIZE.x and grid[y][x] == "v":
						grid[y][x] = "o"

	var blob_kinds := ["f", "m", "g", "d"]
	var blob_counts := [3, 3, 2, 2]
	for bi in blob_kinds.size():
		var kind: String = blob_kinds[bi]
		var count: int = blob_counts[bi]
		for _i in count:
			for _try in 30:
				var cx := rng.randi_range(8, SIZE.x - 9)
				var cy := rng.randi_range(8, SIZE.y - 9)
				if grid[cy][cx] == PLAINS:
					_grow_blob(grid, rng, kind, cx, cy, rng.randi_range(80, 220))
					break

	# The Monolith, carved into open plains at the exact centre, clearing a margin around it
	# so there is always room to approach it.
	var mx := SIZE.x / 2
	var my := SIZE.y / 2
	for dy in range(-6, 7):
		for dx in range(-6, 7):
			var x := mx + dx
			var y := my + dy
			if absi(dx) <= 3 and absi(dy) <= 3:
				grid[y][x] = "M"
			elif grid[y][x] != "~":
				grid[y][x] = PLAINS
	return grid


static func _grow_blob(
	grid: Array[PackedStringArray],
	rng: RandomNumberGenerator,
	kind: String,
	cx: int,
	cy: int,
	size: int,
) -> void:
	var placed := 0
	var frontier: Array[Vector2i] = [Vector2i(cx, cy)]
	var seen: Dictionary[Vector2i, bool] = { Vector2i(cx, cy): true }
	while not frontier.is_empty() and placed < size:
		var i := rng.randi_range(0, frontier.size() - 1)
		var p: Vector2i = frontier[i]
		frontier.remove_at(i)
		if p.x < BORDER or p.x >= SIZE.x - BORDER or p.y < BORDER or p.y >= SIZE.y - BORDER:
			continue
		if grid[p.y][p.x] != PLAINS:
			continue
		if (kind == "f" or kind == "g") and _volcanic_nearby(grid, p, 1):
			continue
		grid[p.y][p.x] = kind
		placed += 1
		for offset in NEIGHBOURS_8:
			var np := p + offset
			if not seen.has(np) and rng.randf() < 0.85:
				seen[np] = true
				frontier.append(np)


static func _volcanic_nearby(grid: Array[PackedStringArray], p: Vector2i, margin: int) -> bool:
	for dy in range(-margin, margin + 1):
		for dx in range(-margin, margin + 1):
			var y := p.y + dy
			var x := p.x + dx
			if y >= 0 and y < SIZE.y and x >= 0 and x < SIZE.x:
				if grid[y][x] == "v" or grid[y][x] == "o":
					return true
	return false


static func _rows_of(grid: Array[PackedStringArray]) -> PackedStringArray:
	var rows := PackedStringArray()
	for row in grid:
		rows.append("".join(row))
	return rows

## --- soundness checks -------------------------------------------------------------------


static func _walkable(c: String) -> bool:
	var entry: Vector2i = WorldMapData.LEGEND.get(c, Vector2i(-1, -1))
	return entry.x >= 0 and Biome.is_walkable(entry.y)


static func _is_sound(grid: Array[PackedStringArray]) -> bool:
	# Connectivity: every walkable tile reachable from one open plains tile.
	var start := Vector2i(-1, -1)
	for y in SIZE.y:
		for x in SIZE.x:
			if grid[y][x] == PLAINS:
				start = Vector2i(x, y)
				break
		if start.x >= 0:
			break
	if start.x < 0:
		return false
	var reached := _flood(grid, start, Rect2i(Vector2i.ZERO, SIZE))
	var total := 0
	for y in SIZE.y:
		for x in SIZE.x:
			if _walkable(grid[y][x]):
				total += 1
	if reached.size() != total:
		return false

	# Forest and glacier never touch volcanic ground directly.
	for y in SIZE.y:
		for x in SIZE.x:
			if grid[y][x] == "f" or grid[y][x] == "g":
				if _volcanic_nearby(grid, Vector2i(x, y), 1):
					return false

	# Every biome and every feature appears somewhere.
	var biomes: Dictionary[int, bool] = { }
	var features: Dictionary[int, bool] = { }
	for y in SIZE.y:
		for x in SIZE.x:
			var entry: Vector2i = WorldMapData.LEGEND.get(grid[y][x], Vector2i(-1, -1))
			biomes[entry.x] = true
			features[entry.y] = true
	if biomes.size() != Biome.Kind.size() or features.size() != Biome.Feature.size():
		return false
	return true


static func _flood(grid: Array[PackedStringArray], start: Vector2i, bounds: Rect2i) -> Dictionary:
	var reached: Dictionary[Vector2i, bool] = { start: true }
	var stack: Array[Vector2i] = [start]
	while not stack.is_empty():
		var p: Vector2i = stack.pop_back()
		for offset in NEIGHBOURS_4:
			var np := p + offset
			if bounds.has_point(np) and not reached.has(np) and _walkable(grid[np.y][np.x]):
				reached[np] = true
				stack.append(np)
	return reached

## --- points of interest -------------------------------------------------------------------


static func _pick_spaced(
	map: WorldMapData,
	rng: RandomNumberGenerator,
	count: int,
	min_gap: float,
	avoid: Array[Vector2i],
) -> Array[Vector2i]:
	var chosen: Array[Vector2i] = []
	var attempts := 0
	while chosen.size() < count and attempts < 20000:
		attempts += 1
		var tile := Vector2i(rng.randi_range(6, SIZE.x - 7), rng.randi_range(6, SIZE.y - 7))
		if map.is_solid(tile):
			continue
		var too_close := false
		for other in avoid + chosen:
			if Vector2(tile - other).length() < min_gap:
				too_close = true
				break
		if not too_close:
			chosen.append(tile)
	return chosen
