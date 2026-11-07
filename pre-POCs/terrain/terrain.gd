## Pre-POC: turns one biome mask into terrain views of 16-pixel tiles, in the BLK NX64 palette.
## Run: godot --headless --script terrain.gd -- <mask_sheet.png> <mask number 1-10> <output_dir>
## Every tile and sprite is a placeholder drawn by code, only to judge scale, readability and the palette.
extends SceneTree

const MASK := 256          # mask points per side
const TILES_PER_POINT := 10
const TILE := 16
const VIEW_W := 640        # native resolution, scaled ×3 to 1080p
const VIEW_H := 360
const SCALE := 3

enum { PLAINS, FOREST, MARSH, GLACIER, DESERT, MOUNTAIN, VOLCANIC, COAST, SPINE }
const NAMES := ["plains", "forest", "marsh", "glacier", "desert", "mountain", "volcanic", "coast", "spine"]
## Higher layers outline themselves over lower ones (docs/WORLD_MAP.md, Layers).
const RANK := [1, 2, 3, 4, 5, 6, 7, 0, 6]
## The mask sheet's legend, read back into biomes.
const MASK_COLORS := {
	"e8d44d": PLAINS, "3e9a3e": FOREST, "7a5230": MARSH, "f4f8fb": GLACIER, "ee8a2a": DESERT,
	"8c8c8c": MOUNTAIN, "4a4a4a": SPINE, "cc2b20": VOLCANIC, "2f6fd0": COAST,
	"8fd6ff": GLACIER, "f2e3b0": GLACIER, "000000": PLAINS, "303030": PLAINS,
}

## BLK NX64, the game's palette (docs/ART_DIRECTION.md). Every pixel written comes from this list.
const PAL_HEX := "000000 12173d 293268 464b8c 6b74b2 909edd c1d9f2 ffffff a293c4 7b6aa5 53427f 3c2c68 431e66 5d2f8c 854cbf b483ef 8cff9b 42bc7f 22896e 14665b 0f4a4c 0a2a33 1d1a59 322d89 354ab2 3e83d1 50b9eb 8cdaff 53a1ad 3b768f 21526b 163755 008782 00aaa5 27d3cb 78fae6 cdc599 988f64 5c5d41 353f23 919b45 afd370 ffe091 ffaa6e ff695a b23c40 ff6675 dd3745 a52639 721c2f b22e69 e54286 ff6eaf ffa5d5 ffd3ad cc817a 895654 61393b 3f1f3c 723352 994c69 c37289 f29faa ffccd0"
var pal: Array[Color] = []

## Ground per biome: base, shade, light, outline drawn where it lies over a lower layer.
const GROUND := [
	["afd370", "919b45", "ffe091", "5c5d41"],  # plains
	["22896e", "14665b", "42bc7f", "0f4a4c"],  # forest
	["5c5d41", "353f23", "919b45", "353f23"],  # marsh
	["c1d9f2", "909edd", "ffffff", "6b74b2"],  # glacier
	["ffe091", "ffaa6e", "ffd3ad", "cc817a"],  # desert
	["7b6aa5", "53427f", "a293c4", "3c2c68"],  # mountain
	["3f1f3c", "61393b", "723352", "12173d"],  # volcanic
	["3e83d1", "354ab2", "50b9eb", "21526b"],  # coast
	["53427f", "3c2c68", "7b6aa5", "293268"],  # spine
]

var mask := PackedByteArray()
var warp := FastNoiseLite.new()
var fine := FastNoiseLite.new()
var patch := FastNoiseLite.new()
var lava := FastNoiseLite.new()
var sprites := {}


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 3:
		printerr("usage: -- <mask_sheet.png> <mask number 1-10> <output_dir>")
		quit(1)
		return
	for h in PAL_HEX.split(" "):
		pal.append(Color(h))
	var n := int(args[1]) - 1
	var out_dir: String = args[2]
	DirAccess.make_dir_recursive_absolute(out_dir)
	_read_mask(args[0], n)
	for nz: FastNoiseLite in [warp, fine, patch, lava]:
		nz.seed = 4242 + n
		nz.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	warp.frequency = 0.035
	fine.frequency = 0.2
	patch.frequency = 0.09
	lava.frequency = 0.05
	lava.fractal_octaves = 2

	var stamp := Time.get_datetime_string_from_system().replace("T", "-").replace(":", "-")
	var spots := _find_spots()
	var sheet := Image.create_empty(2 * VIEW_W * 2 + 18, ceili(spots.size() / 2.0) * (VIEW_H * 2 + 6) + 6, false, Image.FORMAT_RGB8)
	sheet.fill(Color("202020"))
	var k := 0
	var log_lines := PackedStringArray()
	for name: String in spots:
		var view := _render_view(spots[name], name == "plains and forest")
		var big := view.duplicate()
		big.resize(VIEW_W * 2, VIEW_H * 2, Image.INTERPOLATE_NEAREST)
		sheet.blit_rect(big, Rect2i(0, 0, VIEW_W * 2, VIEW_H * 2), Vector2i(6 + (k % 2) * (VIEW_W * 2 + 6), 6 + (k / 2) * (VIEW_H * 2 + 6)))
		log_lines.append("view %d  %s  centred on tile %d, %d" % [k + 1, name, spots[name].x, spots[name].y])
		if name == "plains and forest":
			var x3 := view.duplicate()
			x3.resize(VIEW_W * SCALE, VIEW_H * SCALE, Image.INTERPOLATE_NEAREST)
			x3.save_png("%s/day_1080p_%s.png" % [out_dir, stamp])
			var night := _night(view)
			log_lines.append("night view: pixels outside BLK NX64: %d" % _off_palette(night))
			night.resize(VIEW_W * SCALE, VIEW_H * SCALE, Image.INTERPOLATE_NEAREST)
			night.save_png("%s/night_1080p_%s.png" % [out_dir, stamp])
		k += 1
	sheet.save_png("%s/views_%s.png" % [out_dir, stamp])
	var off := _off_palette(sheet)
	log_lines.append("mask %d of %s; pixels outside BLK NX64 in the views: %d" % [n + 1, args[0].get_file(), off])
	var f := FileAccess.open("%s/run_%s.txt" % [out_dir, stamp], FileAccess.WRITE)
	f.store_string("\n".join(log_lines) + "\n")
	f.close()
	print("\n".join(log_lines))
	print("written: views_%s.png, day_1080p_%s.png, night_1080p_%s.png, run_%s.txt" % [stamp, stamp, stamp, stamp])
	quit(0)


# ---------------------------------------------------------------- the mask

func _read_mask(path: String, n: int) -> void:
	var img := Image.load_from_file(path)
	mask.resize(MASK * MASK)
	var ox := 6 + (n % 5) * (MASK + 6)
	var oy := 6 + (n / 5) * (MASK + 6)
	for y in MASK:
		for x in MASK:
			var hex := img.get_pixel(ox + x, oy + y).to_html(false)
			mask[y * MASK + x] = MASK_COLORS.get(hex, PLAINS)


func _point(x: int, y: int) -> int:
	return mask[clampi(y, 0, MASK - 1) * MASK + clampi(x, 0, MASK - 1)]


## The biome under a world pixel. Borders are bent at tile scale, then settled on 4-pixel steps,
## the detail a set of transition tiles would give.
func _biome_at(px: int, py: int) -> int:
	var bx := float(px / 4 * 4) / TILE
	var by := float(py / 4 * 4) / TILE
	var wx := warp.get_noise_2d(bx, by) * 9.0 + fine.get_noise_2d(bx, by) * 1.5
	var wy := warp.get_noise_2d(bx + 300.0, by) * 9.0 + fine.get_noise_2d(bx, by + 300.0) * 1.5
	return _point(floori((bx + wx) / TILES_PER_POINT), floori((by + wy) / TILES_PER_POINT))


## One view centred on a border worth showing, found in the mask.
func _find_spots() -> Dictionary:
	var wanted := {
		"plains and forest": [PLAINS, FOREST], "forest and marsh": [FOREST, MARSH],
		"glacier": [GLACIER, PLAINS], "desert": [DESERT, PLAINS],
		"mountain spine": [SPINE, MOUNTAIN], "volcanic rift": [VOLCANIC, MOUNTAIN],
		"coast": [COAST, PLAINS],
	}
	var spots := {}
	for name: String in wanted:
		var a: int = wanted[name][0]
		var b: int = wanted[name][1]
		var best := Vector2i(-1, -1)
		var best_score := -1
		for y in range(12, MASK - 12, 2):
			for x in range(12, MASK - 12, 2):
				if _point(x, y) != a:
					continue
				var na := 0
				var nb := 0
				for dy in range(-2, 3):
					for dx in range(-3, 4):
						var p := _point(x + dx, y + dy)
						na += int(p == a)
						nb += int(p == b)
				var score := mini(na, nb)
				if score > best_score:
					best_score = score
					best = Vector2i(x, y)
		if best_score > 3:
			spots[name] = best * TILES_PER_POINT + Vector2i(5, 5)
	return spots


# ---------------------------------------------------------------- a view

func _render_view(centre_tile: Vector2i, characters: bool) -> Image:
	var x0 := centre_tile.x * TILE - VIEW_W / 2
	var y0 := centre_tile.y * TILE - VIEW_H / 2
	var m := 40  # margin for sprites rooted outside the view
	var bw := VIEW_W + 2 * m
	var bh := VIEW_H + 2 * m
	var bio := PackedByteArray()
	bio.resize(bw * bh)
	for y in bh:
		for x in bw:
			bio[y * bw + x] = _biome_at(x0 - m + x, y0 - m + y)
	var img := Image.create_empty(bw, bh, false, Image.FORMAT_RGBA8)
	# Ground.
	for y in bh:
		for x in bw:
			var b := bio[y * bw + x]
			var wx := x0 - m + x
			var wy := y0 - m + y
			img.set_pixel(x, y, _ground(b, wx, wy, bio, bw, bh, x, y))
	# Decor, rooted on tiles lying wholly in one biome, drawn from the back to the front.
	var decor := []
	var t0 := Vector2i(floori(float(x0 - m) / TILE), floori(float(y0 - m) / TILE))
	for ty in range(t0.y, t0.y + bh / TILE + 2):
		for tx in range(t0.x, t0.x + bw / TILE + 2):
			var cx := tx * TILE + 8 - (x0 - m)
			var cy := ty * TILE + 8 - (y0 - m)
			if cx < 8 or cy < 8 or cx >= bw - 8 or cy >= bh - 8:
				continue
			var b := bio[cy * bw + cx]
			if bio[(cy - 7) * bw + cx - 7] != b or bio[(cy + 7) * bw + cx + 7] != b \
					or bio[(cy - 7) * bw + cx + 7] != b or bio[(cy + 7) * bw + cx - 7] != b:
				continue
			var key := _decor_for(b, tx, ty)
			if key != "":
				var jx := int(_hash(tx, ty, 7) * 8.0) - 4
				var jy := int(_hash(tx, ty, 8) * 6.0) - 3
				decor.append([cy + jy, cx + jx, key, b])
	if characters:
		decor.append([bh / 2 + 10, bw / 2 - 20, "wizard", PLAINS])
		decor.append([bh / 2 + 14, bw / 2 + 50, "boss", PLAINS])
	decor.sort_custom(func(a: Array, b: Array) -> bool: return a[0] < b[0])
	for d: Array in decor:
		var spr: Image = _sprite(d[2])
		_shadow(img, d[1], d[0] + 1, maxi(3, spr.get_width() * 2 / 5), d[3])
		img.blend_rect(spr, Rect2i(Vector2i.ZERO, spr.get_size()), Vector2i(d[1] - spr.get_width() / 2, d[0] - spr.get_height() + 1))
	var out := img.get_region(Rect2i(m, m, VIEW_W, VIEW_H))
	out.convert(Image.FORMAT_RGB8)
	return out


func _ground(b: int, wx: int, wy: int, bio: PackedByteArray, bw: int, bh: int, x: int, y: int) -> Color:
	var g: Array = GROUND[b]
	# A coloured outline where this ground lies over a lower layer.
	for o: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var nx := x + o.x
		var ny := y + o.y
		if nx < 0 or ny < 0 or nx >= bw or ny >= bh:
			continue
		var nb := bio[ny * bw + nx]
		if b == COAST and nb != COAST:
			return Color("8cdaff")  # surf against the shore
		if RANK[nb] < RANK[b]:
			return Color(g[3])
	var p := patch.get_noise_2d(wx, wy)
	var h := _hash(wx, wy, b)
	match b:
		VOLCANIC:
			var l := absf(lava.get_noise_2d(wx, wy))
			if l < 0.025:
				return Color("ffaa6e")
			if l < 0.05:
				return Color("ff695a")
			if l < 0.07:
				return Color("b23c40")
		COAST:
			if (wy % 9 == 0) and _hash(wx / 6, wy, 3) > 0.8:
				return Color(g[2])
			return Color(g[0]) if p > -0.2 else Color(g[1])
		DESERT:
			if (wy + int(patch.get_noise_2d(wx * 0.3, 0.0) * 6.0)) % 7 == 0 and h > 0.3:
				return Color(g[1])
			return Color(g[2]) if h > 0.97 else Color(g[0])
		GLACIER:
			if absf(fine.get_noise_2d(wx * 0.5, wy * 0.5)) < 0.015 and p > 0.3:
				return Color("6b74b2")  # crevasse
	if h > 0.985:
		return Color(g[2])
	if p > 0.35 or (p > 0.25 and h > 0.5):
		return Color(g[1])
	return Color(g[0])


func _decor_for(b: int, tx: int, ty: int) -> String:
	var r := _hash(tx, ty, 11)
	var v := int(_hash(tx, ty, 12) * 3.0)
	match b:
		PLAINS:
			if r < 0.05: return "bush%d" % v
			if r < 0.30: return "tuft%d" % v
			if r < 0.42: return "flower%d" % v
		FOREST:
			if r < 0.62: return "tree%d" % v
			if r < 0.75: return "tuft%d" % v
		MARSH:
			if r < 0.30: return "puddle%d" % v
			if r < 0.55: return "reeds%d" % v
			if r < 0.62: return "deadtree%d" % v
		GLACIER:
			if r < 0.14: return "shard%d" % v
			if r < 0.26: return "snow%d" % v
		DESERT:
			if r < 0.07: return "deadtree%d" % v
			if r < 0.20: return "dryrock%d" % v
			if r < 0.32: return "drytuft%d" % v
		MOUNTAIN:
			if r < 0.30: return "rock%d" % v
		SPINE:
			return "peak%d" % v
		VOLCANIC:
			if r < 0.16: return "obsidian%d" % v
	return ""


## A ground shadow under a sprite, in the darkest tone the ground already uses.
func _shadow(img: Image, cx: int, cy: int, r: int, b: int) -> void:
	var c := Color(GROUND[b][3])
	for y in range(-2, 3):
		for x in range(-r, r + 1):
			if float(x * x) / (r * r) + float(y * y) / 4.0 <= 1.0:
				var px := cx + x
				var py := cy + y
				if px >= 0 and py >= 0 and px < img.get_width() and py < img.get_height():
					img.set_pixel(px, py, c)


# ---------------------------------------------------------------- placeholder sprites

func _sprite(key: String) -> Image:
	if sprites.has(key):
		return sprites[key]
	var kind := key.rstrip("0123456789")
	var v := int(key.substr(kind.length())) if key.length() > kind.length() else 0
	var s: Image
	match kind:
		"tree":
			s = _canvas(18, 28)
			_rect(s, 7, 17, 4, 9, "895654"); _rect(s, 9, 17, 2, 9, "61393b")
			_ellipse(s, 9, 11, 8, 9 - v % 2, "22896e")
			_ellipse(s, 8, 13, 7, 5, "14665b")
			_ellipse(s, 7, 8, 5, 5, "42bc7f")
			_dots(s, "8cff9b", 4 + v, 9, 9, 5, v)
			_outline(s, "0f4a4c")
		"deadtree":
			s = _canvas(14, 22)
			_rect(s, 6, 6, 2, 15, "988f64")
			_line(s, 7, 10, 2, 4, "988f64"); _line(s, 7, 8, 12, 3, "988f64"); _line(s, 7, 13, 11 - v, 9, "5c5d41")
			_outline(s, "353f23")
		"bush":
			s = _canvas(12, 9)
			_ellipse(s, 6, 5, 5, 3, "919b45"); _ellipse(s, 5, 4, 3, 2, "afd370")
			if v == 1: _dots(s, "ff6675", 3, 6, 5, 3, v)
			_outline(s, "5c5d41")
		"tuft", "drytuft":
			s = _canvas(7, 6)
			var c := "919b45" if kind == "tuft" else "cc817a"
			var c2 := "afd370" if kind == "tuft" else "ffd3ad"
			for i in 3:
				_rect(s, 1 + i * 2, 2 + (i + v) % 2, 1, 4 - (i + v) % 2, c)
			_rect(s, 3, 1, 1, 2, c2)
		"flower":
			s = _canvas(5, 6)
			_rect(s, 2, 3, 1, 3, "42bc7f")
			_ellipse(s, 2, 2, 1, 1, ["ffe091", "ff6675", "b483ef"][v])
			s.set_pixel(2, 2, Color("ffffff"))
		"puddle":
			s = _canvas(16, 8)
			_ellipse(s, 8, 4, 7 - v, 3, "3b768f"); _ellipse(s, 6, 3, 3, 1, "53a1ad")
			_outline(s, "21526b")
		"reeds":
			s = _canvas(9, 12)
			for i in 4:
				_rect(s, 1 + i * 2, 3 + (i * 3 + v) % 4, 1, 9 - (i * 3 + v) % 4, "919b45")
			_rect(s, 3, 2, 1, 3, "895654")
		"shard":
			s = _canvas(10, 14)
			_triangle(s, 5, 1, 4, 13, "c1d9f2"); _triangle(s, 4, 3, 2, 13, "ffffff"); _rect(s, 6, 7, 2, 6, "909edd")
			_outline(s, "6b74b2")
		"snow":
			s = _canvas(14, 7)
			_ellipse(s, 7, 4, 6, 2, "ffffff"); _rect(s, 3, 5, 8, 1, "c1d9f2")
			_outline(s, "909edd")
		"rock", "dryrock":
			s = _canvas(12, 9)
			var cs := ["a293c4", "7b6aa5", "53427f", "3c2c68"] if kind == "rock" else ["ffd3ad", "cdc599", "988f64", "5c5d41"]
			_ellipse(s, 6, 5, 5 - v % 2, 3, cs[1]); _ellipse(s, 5, 4, 3, 2, cs[0]); _rect(s, 3, 7, 7, 1, cs[2])
			_outline(s, cs[3])
		"peak":
			s = _canvas(22, 30)
			_triangle(s, 11, 1, 10, 29, "7b6aa5")
			_triangle(s, 13, 5, 7, 29, "53427f")
			_triangle(s, 11, 1, 4, 9 + v, "ffffff"); _rect(s, 12, 6, 2, 3 + v, "c1d9f2")
			_outline(s, "293268")
		"obsidian":
			s = _canvas(9, 16)
			_triangle(s, 4, 1, 3, 15, "322d89"); _rect(s, 3, 5, 1, 9, "464b8c"); _rect(s, 5, 9, 2, 6, "12173d")
			_outline(s, "000000")
		"wizard":
			s = _canvas(18, 30)
			_triangle(s, 9, 0, 5, 11, "5d2f8c"); _rect(s, 3, 10, 13, 2, "3c2c68")
			_rect(s, 6, 12, 7, 5, "ffd3ad"); _rect(s, 7, 14, 1, 1, "000000"); _rect(s, 11, 14, 1, 1, "000000")
			_triangle(s, 9, 15, 4, 21, "ffffff")
			_triangle(s, 9, 12, 7, 29, "854cbf"); _rect(s, 9, 18, 4, 11, "5d2f8c"); _rect(s, 7, 21, 4, 1, "ffe091")
			_rect(s, 15, 8, 1, 21, "895654"); _ellipse(s, 15, 7, 1, 1, "27d3cb")
			_outline(s, "431e66")
		"boss":
			s = _canvas(52, 58)
			_ellipse(s, 26, 34, 22, 21, "431e66"); _ellipse(s, 24, 30, 16, 14, "5d2f8c")
			_triangle(s, 12, 2, 4, 16, "cdc599"); _triangle(s, 40, 2, 4, 16, "cdc599")
			_rect(s, 17, 26, 5, 3, "ff695a"); _rect(s, 30, 26, 5, 3, "ff695a"); _rect(s, 18, 26, 2, 1, "ffaa6e"); _rect(s, 31, 26, 2, 1, "ffaa6e")
			_rect(s, 19, 38, 14, 3, "12173d"); _rect(s, 21, 38, 2, 2, "ffffff"); _rect(s, 29, 38, 2, 2, "ffffff")
			_rect(s, 8, 50, 9, 6, "322d89"); _rect(s, 35, 50, 9, 6, "322d89")
			_outline(s, "12173d")
	sprites[key] = s
	return s


func _canvas(w: int, h: int) -> Image:
	var s := Image.create_empty(w, h, false, Image.FORMAT_RGBA8)
	s.fill(Color(0, 0, 0, 0))
	return s


func _plot(s: Image, x: int, y: int, c: String) -> void:
	if x >= 0 and y >= 0 and x < s.get_width() and y < s.get_height():
		s.set_pixel(x, y, Color(c))


func _rect(s: Image, x: int, y: int, w: int, h: int, c: String) -> void:
	for yy in range(y, y + h):
		for xx in range(x, x + w):
			_plot(s, xx, yy, c)


func _ellipse(s: Image, cx: int, cy: int, rx: int, ry: int, c: String) -> void:
	for y in range(cy - ry, cy + ry + 1):
		for x in range(cx - rx, cx + rx + 1):
			if pow(float(x - cx) / (rx + 0.5), 2) + pow(float(y - cy) / (ry + 0.5), 2) <= 1.0:
				_plot(s, x, y, c)


## An upright triangle: apex at (cx, top), half-width `hw` at row `bottom`.
func _triangle(s: Image, cx: int, top: int, hw: int, bottom: int, c: String) -> void:
	for y in range(top, bottom + 1):
		var w := roundi(hw * float(y - top) / maxf(1.0, bottom - top))
		_rect(s, cx - w, y, 2 * w + 1, 1, c)


func _line(s: Image, x0: int, y0: int, x1: int, y1: int, c: String) -> void:
	var n := maxi(absi(x1 - x0), absi(y1 - y0))
	for i in n + 1:
		_plot(s, roundi(lerpf(x0, x1, float(i) / maxi(1, n))), roundi(lerpf(y0, y1, float(i) / maxi(1, n))), c)


func _dots(s: Image, c: String, count: int, cx: int, cy: int, r: int, v: int) -> void:
	for i in count:
		var x := cx + int(_hash(i, v, 21) * 2 * r) - r
		var y := cy + int(_hash(i, v, 22) * 2 * r) - r
		if s.get_pixel(clampi(x, 0, s.get_width() - 1), clampi(y, 0, s.get_height() - 1)).a > 0.0:
			_plot(s, x, y, c)


## A coloured outline: every empty pixel touching the sprite takes a darker shade of it.
func _outline(s: Image, c: String) -> void:
	var edge := []
	for y in s.get_height():
		for x in s.get_width():
			if s.get_pixel(x, y).a > 0.0:
				continue
			for o: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var nx := x + o.x
				var ny := y + o.y
				if nx >= 0 and ny >= 0 and nx < s.get_width() and ny < s.get_height() and s.get_pixel(nx, ny).a > 0.0:
					edge.append(Vector2i(x, y))
					break
	for p: Vector2i in edge:
		s.set_pixel(p.x, p.y, Color(c))


# ---------------------------------------------------------------- night, held to the palette

## Darkness and the wizard's staff light, every lit pixel then snapped back to the nearest BLK NX64 colour.
## Light falls in steps, mixed by an ordered dither where two steps meet.
func _night(day: Image) -> Image:
	var bayer := [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5]
	var light_at := Vector2(VIEW_W / 2 - 14, VIEW_H / 2 - 18)  # the wizard's staff
	var snap := {}
	var out := Image.create_empty(VIEW_W, VIEW_H, false, Image.FORMAT_RGB8)
	for y in VIEW_H:
		for x in VIEW_W:
			var d := Vector2(x, y).distance_to(light_at)
			var lit := clampf(1.0 - d / 120.0, 0.0, 1.0)
			var level := 0.28 + 0.72 * lit * lit
			level = floorf(level * 6.0 + bayer[(y % 4) * 4 + x % 4] / 16.0) / 6.0
			var c := day.get_pixel(x, y)
			var key := "%s%.3f" % [c.to_html(false), level]
			if not snap.has(key):
				var warm := lit * 0.25
				var t := Color(c.r * level * (1.0 + warm), c.g * level, c.b * level * (1.0 - warm) + 0.04 * (1.0 - lit))
				snap[key] = _nearest(t)
			out.set_pixel(x, y, snap[key])
	return out


func _nearest(c: Color) -> Color:
	var best := pal[0]
	var best_d := INF
	for p in pal:
		var rm := (c.r + p.r) * 0.5
		var d := (2.0 + rm) * pow(c.r - p.r, 2) + 4.0 * pow(c.g - p.g, 2) + (3.0 - rm) * pow(c.b - p.b, 2)
		if d < best_d:
			best_d = d
			best = p
	return best


# ---------------------------------------------------------------- checks and helpers

func _off_palette(img: Image) -> int:
	var allowed := {"202020": true}
	for p in pal:
		allowed[p.to_html(false)] = true
	var off := 0
	for y in img.get_height():
		for x in img.get_width():
			if not allowed.has(img.get_pixel(x, y).to_html(false)):
				off += 1
	return off


func _hash(x: int, y: int, salt: int) -> float:
	var h := (x * 374761393 + y * 668265263 + salt * 2147483647) & 0xffffffff
	h = ((h ^ (h >> 13)) * 1274126177) & 0xffffffff
	return float((h ^ (h >> 16)) & 0xffff) / 65536.0
