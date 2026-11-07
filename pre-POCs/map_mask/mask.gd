## Pre-POC: generates world masks, one biome per zone, following docs/WORLD_MAP.md rules.
## Run: godot --headless --script mask.gd -- <output_dir> [first_seed] [count]
extends SceneTree

const W := 256
const H := 256
const NONE := 255
enum { PLAINS, FOREST, MARSH, GLACIER, DESERT, MOUNTAIN, VOLCANIC, COAST }
const NAMES := ["plains", "forest", "marsh", "glacier", "desert", "mountain", "volcanic", "coast"]
const COLORS := [
	Color("e8d44d"), Color("3e9a3e"), Color("7a5230"), Color("f4f8fb"),
	Color("ee8a2a"), Color("8c8c8c"), Color("cc2b20"), Color("2f6fd0"),
]
const SPINE_COLOR := Color("4a4a4a")
const LAKE_COLOR := Color("8fd6ff")
const ISLAND_COLOR := Color("f2e3b0")
var monolith := Vector2(W / 2.0, H / 2.0)  # drawn per mask inside the central box

var grid := PackedByteArray()
var spine := PackedByteArray()
var feature := PackedByteArray()  # 0 none, 1 Frostfang lake, 2 Frostfang island
var rng := RandomNumberGenerator.new()
var warp_x := FastNoiseLite.new()
var warp_y := FastNoiseLite.new()
var edge_noise := FastNoiseLite.new()
var coast_edge := -1
var frostfang := ""


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		printerr("usage: -- <output_dir> [first_seed] [count]")
		quit(1)
		return
	var out_dir: String = args[0]
	var first_seed := int(args[1]) if args.size() > 1 else 1
	var count := int(args[2]) if args.size() > 2 else 10
	DirAccess.make_dir_recursive_absolute(out_dir)

	var sheet := Image.create_empty(5 * (W + 6) + 6, ceili(count / 5.0) * (H + 6) + 6, false, Image.FORMAT_RGB8)
	sheet.fill(Color("202020"))
	var failures := {}
	var total_attempts := 0
	for n in count:
		var attempt := 0
		var reason := ""
		while true:
			attempt += 1
			reason = _generate(first_seed * 1000 + n * 97 + attempt)
			if reason == "":
				break
			failures[reason] = failures.get(reason, 0) + 1
			if attempt >= 200:
				break
		total_attempts += attempt
		if reason != "":
			printerr("mask %d: no valid mask in 200 attempts, last failure: %s" % [n + 1, reason])
			continue
		var img := _render()
		var big := img.duplicate() as Image
		big.resize(W * 2, H * 2, Image.INTERPOLATE_NEAREST)
		big.save_png("%s/mask_%02d.png" % [out_dir, n + 1])
		sheet.blit_rect(img, Rect2i(0, 0, W, H), Vector2i(6 + (n % 5) * (W + 6), 6 + (n / 5) * (H + 6)))
		print("mask %02d  attempts %3d  %s  frostfang: %s" % [n + 1, attempt, _shares(), frostfang])
	sheet.save_png(out_dir + "/sheet.png")
	print("attempts in total: %d for %d masks; rejected because: %s" % [total_attempts, count, str(failures)])
	quit(0)


# ---------------------------------------------------------------- generation

func _generate(seed_value: int) -> String:
	rng.seed = seed_value
	for i in 3:
		var nz: FastNoiseLite = [warp_x, warp_y, edge_noise][i]
		nz.seed = seed_value * 3 + i
		nz.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
		nz.frequency = 0.018 if i < 2 else 0.05
		nz.fractal_octaves = 3
	grid.resize(W * H)
	grid.fill(NONE)
	spine.resize(W * H)
	spine.fill(0)
	feature.resize(W * H)
	feature.fill(0)
	frostfang = "not drawn"

	# The Monolith stands anywhere within ±10 % of the centre, its Outer Ring entirely in plains.
	monolith = Vector2(rng.randf_range(0.4, 0.6) * W, rng.randf_range(0.4, 0.6) * H)
	_stamp(monolith, 16.0, PLAINS)
	_paint_coast()
	_paint_mountain()
	_paint_volcanic()
	var volcano_distance := _distance_field(func(i: int) -> bool: return grid[i] == VOLCANIC, 80)
	var seeds := _place_seeds(volcano_distance)
	if seeds.is_empty():
		return "seed placement"
	_voronoi(seeds, volcano_distance)
	_cleanup()
	var reason := _validate()
	if reason == "":
		_place_frostfang()
	return reason


func _paint_coast() -> void:
	coast_edge = rng.randi_range(0, 3)
	var t0 := rng.randf_range(0.0, 0.35)
	var t1 := minf(1.0, t0 + rng.randf_range(0.5, 0.9))
	var depth := rng.randf_range(16.0, 28.0)
	for y in H:
		for x in W:
			var d := 0.0
			var t := 0.0
			match coast_edge:
				0:
					d = y; t = x / float(W - 1)
				1:
					d = W - 1 - x; t = y / float(H - 1)
				2:
					d = H - 1 - y; t = x / float(W - 1)
				3:
					d = x; t = y / float(H - 1)
			var taper_a := 1.0 if t0 <= 0.02 else clampf((t - t0) / 0.12, 0.0, 1.0)
			var taper_b := 1.0 if t1 >= 0.98 else clampf((t1 - t) / 0.12, 0.0, 1.0)
			var limit := depth * sqrt(minf(taper_a, taper_b)) * (1.0 + 0.45 * edge_noise.get_noise_2d(x, y))
			if d < limit and grid[y * W + x] == NONE:
				grid[y * W + x] = COAST


func _paint_mountain() -> void:
	var start := Vector2.ZERO
	var angle := 0.0
	var allowed_edge := -1
	if rng.randf() < 0.5:
		var edges := [0, 1, 2, 3]
		edges.erase(coast_edge)
		allowed_edge = edges[rng.randi_range(0, 2)]
		var t := rng.randf_range(0.25, 0.75)
		match allowed_edge:
			0:
				start = Vector2(t * W, 0); angle = PI / 2
			1:
				start = Vector2(W - 1, t * H); angle = PI
			2:
				start = Vector2(t * W, H - 1); angle = -PI / 2
			3:
				start = Vector2(0, t * H); angle = 0.0
		angle += rng.randf_range(-0.6, 0.6)
	else:
		start = _random_point(60.0, 30.0, func(_p: Vector2) -> bool: return true)
		angle = rng.randf_range(-PI, PI)
	_walk(start, angle, rng.randf_range(0.55, 0.8) * W, 8.0, 0.10, MOUNTAIN, 2.5, 30.0, allowed_edge)


func _paint_volcanic() -> void:
	var mode := rng.randi_range(0, 2)  # 0 volcano, 1 rift, 2 both
	if mode != 1:
		var c := _random_point(55.0, 30.0, func(p: Vector2) -> bool: return grid[int(p.y) * W + int(p.x)] == NONE)
		var r := rng.randf_range(16.0, 24.0)
		for y in range(maxi(0, int(c.y - r * 1.4)), mini(H, int(c.y + r * 1.4) + 1)):
			for x in range(maxi(0, int(c.x - r * 1.4)), mini(W, int(c.x + r * 1.4) + 1)):
				var i := y * W + x
				if grid[i] == NONE and Vector2(x, y).distance_to(c) <= r * (1.0 + 0.25 * edge_noise.get_noise_2d(x * 2, y * 2)):
					grid[i] = VOLCANIC
	if mode != 0:
		var s := _random_point(50.0, 30.0, func(p: Vector2) -> bool: return grid[int(p.y) * W + int(p.x)] == NONE)
		_walk(s, rng.randf_range(-PI, PI), rng.randf_range(0.35, 0.5) * W, 5.0, 0.3, VOLCANIC, 0.0, 35.0, -1)


func _place_seeds(volcano_distance: PackedInt32Array) -> Dictionary:
	var vd := func(p: Vector2) -> int: return volcano_distance[int(p.y) * W + int(p.x)]
	var forest := _random_point(45.0, 20.0, func(p: Vector2) -> bool:
		return grid[int(p.y) * W + int(p.x)] == NONE and vd.call(p) >= 35 and p.distance_to(monolith) <= 95.0)
	if forest.x < 0:
		return {}
	var marsh := _random_point(70.0, 20.0, func(p: Vector2) -> bool:
		var d := p.distance_to(forest)
		return grid[int(p.y) * W + int(p.x)] == NONE and d >= 45.0 and d <= 75.0 \
			and p.distance_to(monolith) > forest.distance_to(monolith) and vd.call(p) >= 10)
	if marsh.x < 0:
		return {}
	var glacier := _random_point(60.0, 20.0, func(p: Vector2) -> bool:
		return grid[int(p.y) * W + int(p.x)] == NONE and vd.call(p) >= 70 \
			and p.distance_to(forest) >= 60.0 and p.distance_to(marsh) >= 50.0)
	if glacier.x < 0:
		return {}
	var desert := _random_point(60.0, 20.0, func(p: Vector2) -> bool:
		return grid[int(p.y) * W + int(p.x)] == NONE and p.distance_to(forest) >= 60.0 \
			and p.distance_to(marsh) >= 60.0 and p.distance_to(glacier) >= 60.0)
	if desert.x < 0:
		return {}
	return {PLAINS: [monolith], FOREST: [forest], MARSH: [marsh], GLACIER: [glacier], DESERT: [desert]}


func _voronoi(seeds: Dictionary, volcano_distance: PackedInt32Array) -> void:
	var weight := {PLAINS: 2.0, FOREST: 1.0, MARSH: 0.9, GLACIER: 1.0, DESERT: 1.0}
	for y in H:
		for x in W:
			var i := y * W + x
			if grid[i] != NONE:
				continue
			# Two scales of warping: broad bends, then a finer ragged edge.
			var q := Vector2(x, y) + Vector2(warp_x.get_noise_2d(x, y), warp_y.get_noise_2d(x, y)) * 34.0
			q += Vector2(warp_x.get_noise_2d(x * 4.0 + 500.0, y * 4.0), warp_y.get_noise_2d(x * 4.0, y * 4.0 + 500.0)) * 7.0
			var best := PLAINS
			var best_score := INF
			for biome: int in seeds:
				if volcano_distance[i] < 6 and (biome == FOREST or biome == GLACIER):
					continue  # forest and glacier never touch volcanic ground
				for s: Vector2 in seeds[biome]:
					var score: float = q.distance_to(s) / weight[biome]
					if score < best_score:
						best_score = score
						best = biome
			grid[i] = best


## Keeps one zone per biome: any stray fragment joins the biome around it.
func _cleanup() -> void:
	for biome in [PLAINS, FOREST, MARSH, GLACIER, DESERT, COAST]:
		var comps := _components(biome)
		if comps.size() < 2:
			continue
		comps.sort_custom(func(a: Array, b: Array) -> bool: return a.size() > b.size())
		var joined := _plains_side_of_chain() if biome == PLAINS else PackedByteArray()
		for k in range(1, comps.size()):
			# Plains cut by the mountain chain stay plains: a piece is kept when only the chain separates it.
			if biome == PLAINS and comps[k].size() >= W * H * 0.01 and joined[comps[k][0]] == 1:
				continue
			var votes := {}
			for i: int in comps[k]:
				for j in _neighbours(i):
					if grid[j] != biome and grid[j] != NONE and grid[j] != MOUNTAIN and grid[j] != VOLCANIC and grid[j] != COAST:
						votes[grid[j]] = votes.get(grid[j], 0) + 1
			var target: int = biome
			var most := -1
			for b: int in votes:
				if votes[b] > most:
					most = votes[b]; target = b
			for i: int in comps[k]:
				grid[i] = target


func _validate() -> String:
	var counts := PackedInt32Array()
	counts.resize(8)
	var pairs := {}
	for y in H:
		for x in W:
			var i := y * W + x
			counts[grid[i]] += 1
			if x + 1 < W:
				pairs[_pair(grid[i], grid[i + 1])] = true
			if y + 1 < H:
				pairs[_pair(grid[i], grid[i + W])] = true
	for b in 8:
		if counts[b] < W * H * (0.008 if b == MOUNTAIN or b == VOLCANIC or b == COAST else 0.04):
			return NAMES[b] + " too small"
	for b in 8:
		if b != PLAINS and counts[b] >= counts[PLAINS]:
			return "plains not the largest"
	if not pairs.has(_pair(FOREST, PLAINS)):
		return "forest not bordering plains"
	if not pairs.has(_pair(MARSH, FOREST)):
		return "marsh not bordering forest"
	if pairs.has(_pair(GLACIER, VOLCANIC)):
		return "glacier touching volcanic"
	if pairs.has(_pair(FOREST, VOLCANIC)):
		return "forest touching volcanic"
	if _edges_touched(MOUNTAIN) > 1:
		return "mountain touching two edges"
	if _edges_touched(COAST) < 1:
		return "coast off the edge"
	for b in [FOREST, MARSH, GLACIER, DESERT]:
		if _components(b).size() != 1:
			return NAMES[b] + " split in two"
	var joined := _plains_side_of_chain()
	for i in W * H:
		if grid[i] == PLAINS and joined[i] == 0:
			return "plains in two zones"
	for y in range(int(monolith.y) - 13, int(monolith.y) + 14):
		for x in range(int(monolith.x) - 13, int(monolith.x) + 14):
			if Vector2(x, y).distance_to(monolith) <= 12.5 and grid[y * W + x] != PLAINS:
				return "Outer Ring not in plains"
	# Everything walkable must be reachable from the Monolith: only the mountain spine blocks.
	var reach := _distance_field(func(i: int) -> bool: return i == int(monolith.y) * W + int(monolith.x), 100000, true)
	for i in W * H:
		if spine[i] == 0 and reach[i] >= 100000:
			return "unreachable ground"
	return ""


func _place_frostfang() -> void:
	if rng.randf() < 0.5:
		return
	if rng.randf() < 0.5:
		var inner := _distance_field(func(i: int) -> bool: return grid[i] != GLACIER, 40)
		var spot := _random_point(0.0, 10.0, func(p: Vector2) -> bool: return inner[int(p.y) * W + int(p.x)] >= 12)
		if spot.x < 0:
			frostfang = "drawn, no room for a lake"
			return
		for y in range(int(spot.y) - 10, int(spot.y) + 11):
			for x in range(int(spot.x) - 10, int(spot.x) + 11):
				var d := Vector2(x, y).distance_to(spot)
				if x >= 0 and y >= 0 and x < W and y < H and d <= 8.0 * (1.0 + 0.2 * edge_noise.get_noise_2d(x * 3, y * 3)):
					feature[y * W + x] = 2 if d <= 2.0 else 1
		frostfang = "lake in the glacier"
	else:
		var inner := _distance_field(func(i: int) -> bool: return grid[i] != COAST, 40)
		var spot := _random_point(0.0, 3.0, func(p: Vector2) -> bool: return inner[int(p.y) * W + int(p.x)] >= 7)
		if spot.x < 0:
			frostfang = "drawn, no room for an island"
			return
		for y in range(int(spot.y) - 4, int(spot.y) + 5):
			for x in range(int(spot.x) - 4, int(spot.x) + 5):
				if x >= 0 and y >= 0 and x < W and y < H and Vector2(x, y).distance_to(spot) <= 3.0:
					feature[y * W + x] = 2
		frostfang = "island off the coast"


# ---------------------------------------------------------------- helpers

func _walk(start: Vector2, angle: float, length: float, base_w: float, wiggle: float,
		biome: int, spine_r: float, avoid_center: float, allowed_edge: int) -> void:
	var p := start
	var a := angle
	var travelled := 0.0
	while travelled < length:
		var w := base_w * (1.0 + 0.3 * edge_noise.get_noise_2d(p.x * 3, p.y * 3))
		_stamp(p, w, biome, spine_r)
		a += rng.randfn(0.0, wiggle)
		var away := p - monolith
		if away.length() < avoid_center + w + 8.0:
			a = lerp_angle(a, away.angle(), 0.35)
		var push := Vector2.ZERO
		var margin := 18.0
		if p.x < margin and allowed_edge != 3: push.x += 1
		if p.x > W - 1 - margin and allowed_edge != 1: push.x -= 1
		if p.y < margin and allowed_edge != 0: push.y += 1
		if p.y > H - 1 - margin and allowed_edge != 2: push.y -= 1
		if push != Vector2.ZERO:
			a = lerp_angle(a, push.angle(), 0.5)
		p += Vector2.from_angle(a) * 2.0
		travelled += 2.0


func _stamp(c: Vector2, r: float, biome: int, spine_r := 0.0) -> void:
	for y in range(maxi(0, int(c.y - r) - 1), mini(H, int(c.y + r) + 2)):
		for x in range(maxi(0, int(c.x - r) - 1), mini(W, int(c.x + r) + 2)):
			var i := y * W + x
			var d := Vector2(x, y).distance_to(c)
			if d <= r and grid[i] == NONE:
				grid[i] = biome
			if spine_r > 0.0 and d <= spine_r and grid[i] == biome:
				spine[i] = 1


func _random_point(min_center: float, margin: float, ok: Callable) -> Vector2:
	for _t in 600:
		var p := Vector2(rng.randf_range(margin, W - 1 - margin), rng.randf_range(margin, H - 1 - margin))
		if p.distance_to(monolith) >= min_center and ok.call(p):
			return p
	return Vector2(-1, -1)


## Breadth-first distance from every cell matching `source`, capped. With `walk`, the spine blocks.
func _distance_field(source: Callable, cap: int, walk := false) -> PackedInt32Array:
	var dist := PackedInt32Array()
	dist.resize(W * H)
	dist.fill(cap)
	var queue := PackedInt32Array()
	for i in W * H:
		if source.call(i):
			dist[i] = 0
			queue.append(i)
	var head := 0
	while head < queue.size():
		var i := queue[head]
		head += 1
		if dist[i] + 1 >= cap:
			continue
		for j in _neighbours(i):
			if dist[j] > dist[i] + 1 and not (walk and spine[j] == 1):
				dist[j] = dist[i] + 1
				queue.append(j)
	return dist


func _components(biome: int) -> Array:
	var seen := PackedByteArray()
	seen.resize(W * H)
	var comps := []
	for start in W * H:
		if grid[start] != biome or seen[start] == 1:
			continue
		var comp := PackedInt32Array([start])
		seen[start] = 1
		var head := 0
		while head < comp.size():
			for j in _neighbours(comp[head]):
				if grid[j] == biome and seen[j] == 0:
					seen[j] = 1
					comp.append(j)
			head += 1
		comps.append(comp)
	return comps


## Cells joined to the Monolith through plains and mountain only: plains split by the chain count as one zone.
func _plains_side_of_chain() -> PackedByteArray:
	var out := PackedByteArray()
	out.resize(W * H)
	var start := int(monolith.y) * W + int(monolith.x)
	var queue := PackedInt32Array([start])
	out[start] = 1
	var head := 0
	while head < queue.size():
		for j in _neighbours(queue[head]):
			if out[j] == 0 and (grid[j] == PLAINS or grid[j] == MOUNTAIN):
				out[j] = 1
				queue.append(j)
		head += 1
	return out


func _neighbours(i: int) -> PackedInt32Array:
	var x := i % W
	var y := i / W
	var out := PackedInt32Array()
	if x > 0: out.append(i - 1)
	if x < W - 1: out.append(i + 1)
	if y > 0: out.append(i - W)
	if y < H - 1: out.append(i + W)
	return out


func _edges_touched(biome: int) -> int:
	var touched := [false, false, false, false]
	for t in W:
		if grid[t] == biome: touched[0] = true
		if grid[t * W + W - 1] == biome: touched[1] = true
		if grid[(H - 1) * W + t] == biome: touched[2] = true
		if grid[t * W] == biome: touched[3] = true
	return touched.count(true)


func _pair(a: int, b: int) -> int:
	return mini(a, b) * 16 + maxi(a, b)


func _shares() -> String:
	var counts := PackedInt32Array()
	counts.resize(8)
	for i in W * H:
		counts[grid[i]] += 1
	var parts := PackedStringArray()
	for b in 8:
		parts.append("%s %d%%" % [NAMES[b], roundi(100.0 * counts[b] / (W * H))])
	return ", ".join(parts) + "  (plains in %d piece%s, Monolith at %d %%, %d %%)" % [
		_components(PLAINS).size(), "" if _components(PLAINS).size() == 1 else "s",
		roundi(100.0 * monolith.x / W), roundi(100.0 * monolith.y / H)]


func _render() -> Image:
	var img := Image.create_empty(W, H, false, Image.FORMAT_RGB8)
	for y in H:
		for x in W:
			var i := y * W + x
			var c: Color = COLORS[grid[i]]
			if spine[i] == 1:
				c = SPINE_COLOR
			if feature[i] == 1:
				c = LAKE_COLOR
			elif feature[i] == 2:
				c = ISLAND_COLOR
			img.set_pixel(x, y, c)
	for y in range(int(monolith.y) - 13, int(monolith.y) + 14):
		for x in range(int(monolith.x) - 13, int(monolith.x) + 14):
			var d := Vector2(x, y).distance_to(monolith)
			if d <= 3.5:
				img.set_pixel(x, y, Color.BLACK)
			elif d >= 11.0 and d <= 12.0:
				img.set_pixel(x, y, Color("303030"))
	return img
