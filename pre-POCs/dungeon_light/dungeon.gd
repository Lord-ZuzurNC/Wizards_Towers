## Pre-POC: one dungeon room in the dark, lit by torches and a wizard's staff, held to a palette.
## Run: godot --headless --script dungeon.gd -- <output_dir>
## Draws the same room four times: lit, then dark in BLK NX64, in APOLLO, and in BLK NX64 with APOLLO's darkest tones.
## Every shape is a placeholder drawn by code; only the palettes and the light are under test.
extends SceneTree

const W := 640
const H := 360
const TILE := 16
const ROOM_H := 320  # 20 tiles; the bottom 40 pixels hold the HUD
const SCALE := 3

const BLK := "000000 12173d 293268 464b8c 6b74b2 909edd c1d9f2 ffffff a293c4 7b6aa5 53427f 3c2c68 431e66 5d2f8c 854cbf b483ef 8cff9b 42bc7f 22896e 14665b 0f4a4c 0a2a33 1d1a59 322d89 354ab2 3e83d1 50b9eb 8cdaff 53a1ad 3b768f 21526b 163755 008782 00aaa5 27d3cb 78fae6 cdc599 988f64 5c5d41 353f23 919b45 afd370 ffe091 ffaa6e ff695a b23c40 ff6675 dd3745 a52639 721c2f b22e69 e54286 ff6eaf ffa5d5 ffd3ad cc817a 895654 61393b 3f1f3c 723352 994c69 c37289 f29faa ffccd0"
const APOLLO := "172038 253a5e 3c5e8b 4f8fba 73bed3 a4dddb 19332d 25562e 468232 75a743 a8ca58 d0da91 4d2b32 7a4841 ad7757 c09473 d7b594 e7d5b3 341c27 602c2c 884b2b be772b de9e41 e8c170 241527 411d31 752438 a53030 cf573c da863e 1e1d39 402751 7a367b a23e8c c65197 df84a5 090a14 10141f 151d28 202e37 394a50 577277 819796 a8b5b2 c7cfcc ebede9"
## APOLLO colours this dark or darker (CIELAB lightness, 0 to 100) reinforce BLK NX64 in the third version.
const REINFORCE_BELOW := 30.0

var base := Image.create_empty(W, H, false, Image.FORMAT_RGBA8)
var emissive := PackedByteArray()  # 1 where a pixel gives its own light: flames, eyes, the staff's gem
var hud := PackedByteArray()        # 1 for the HUD, never darkened
## Lights: position, radius, colour.
var lights := [
	[Vector2(150, 44), 150.0, Vector3(1.0, 0.72, 0.42)],
	[Vector2(490, 44), 150.0, Vector3(1.0, 0.72, 0.42)],
	[Vector2(96, 262), 120.0, Vector3(1.0, 0.62, 0.35)],
	[Vector2(338, 196), 95.0, Vector3(0.6, 0.95, 1.0)],
]
const AMBIENT := 0.07


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		printerr("usage: -- <output_dir>")
		quit(1)
		return
	var out_dir: String = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	emissive.resize(W * H)
	hud.resize(W * H)
	_draw_room()

	var blk := _palette(BLK)
	var apollo := _palette(APOLLO)
	var reinforced := blk.duplicate()
	var added := 0
	for c: Color in apollo:
		if _lab(c).x <= REINFORCE_BELOW:
			reinforced.append(c)
			added += 1

	var lit := base.duplicate()
	lit.convert(Image.FORMAT_RGB8)
	var versions := [
		["lit, BLK NX64", lit, blk],
		["dark, BLK NX64", _light(base, blk), blk],
		["dark, APOLLO", _light(_remap(base, apollo), apollo), apollo],
		["dark, BLK NX64 + %d APOLLO darks" % added, _light(base, reinforced), reinforced],
	]
	var stamp := Time.get_datetime_string_from_system().replace("T", "-").replace(":", "-")
	var sheet := Image.create_empty(2 * W * 2 + 18, 2 * H * 2 + 18, false, Image.FORMAT_RGB8)
	sheet.fill(Color("202020"))
	var lines := PackedStringArray()
	for k in versions.size():
		var v: Array = versions[k]
		var img: Image = v[1]
		var big := img.duplicate()
		big.resize(W * 2, H * 2, Image.INTERPOLATE_NEAREST)
		sheet.blit_rect(big, Rect2i(0, 0, W * 2, H * 2), Vector2i(6 + (k % 2) * (W * 2 + 6), 6 + (k / 2) * (H * 2 + 6)))
		var x3 := img.duplicate()
		x3.resize(W * SCALE, H * SCALE, Image.INTERPOLATE_NEAREST)
		x3.save_png("%s/room%d_1080p_%s.png" % [out_dir, k + 1, stamp])
		lines.append("%d  %-32s  palette %2d colours, outside it: %d px, colours in the dim area: %2d, below lightness 15: %2d" % [
			k + 1, v[0], (v[2] as Array).size(), _outside(img, v[2]), _dim_colours(img), _darks(img)])
	sheet.save_png("%s/rooms_%s.png" % [out_dir, stamp])
	var f := FileAccess.open("%s/run_%s.txt" % [out_dir, stamp], FileAccess.WRITE)
	f.store_string("\n".join(lines) + "\n")
	f.close()
	print("\n".join(lines))
	print("written: rooms_%s.png, room1..4_1080p_%s.png, run_%s.txt" % [stamp, stamp, stamp])
	quit(0)


# ---------------------------------------------------------------- the room, in BLK NX64

func _draw_room() -> void:
	base.fill(Color("000000"))
	# Floor: flagstones, 16-pixel tiles.
	for ty in range(3, 19):
		for tx in range(1, 39):
			_flagstone(tx * TILE, ty * TILE, tx, ty)
	# Back wall: a cap, then two tiles of brick face seen in three-quarter view.
	_rect(0, 0, W, 16, "1d1a59")
	_rect(0, 14, W, 2, "293268")
	for ty in range(1, 3):
		for tx in 40:
			_bricks(tx * TILE, ty * TILE, tx, ty)
	_rect(0, 46, W, 2, "1d1a59")  # where the wall meets the floor
	# Side walls and the near wall, seen from above: caps only.
	_rect(0, 0, 16, ROOM_H, "1d1a59")
	_rect(14, 16, 2, ROOM_H - 32, "293268")
	_rect(W - 16, 0, 16, ROOM_H, "1d1a59")
	_rect(W - 16, 16, 2, ROOM_H - 32, "293268")
	_rect(0, ROOM_H - 16, W, 16, "1d1a59")
	_rect(0, ROOM_H - 16, W, 2, "293268")
	# Doorways: north, into the dark, and south.
	_rect(304, 8, 32, 40, "000000")
	_rect(302, 6, 36, 2, "6b74b2")
	_rect(302, 6, 2, 42, "6b74b2")
	_rect(336, 6, 2, 42, "6b74b2")
	_rect(304, ROOM_H - 16, 32, 16, "000000")
	# Torches on the back wall.
	for x: int in [150, 490]:
		_torch(x, 30)
	# Props and characters, from the back to the front.
	var props := [
		[112, 132, "pillar"], [528, 132, "pillar"], [112, 252, "pillar"], [528, 252, "pillar"],
		[96, 270, "brazier"], [440, 84, "chest"], [230, 110, "bones"], [470, 230, "bones"],
		[300, 170, "husk"], [400, 150, "husk"], [430, 205, "husk"], [330, 215, "wizard"],
	]
	props.sort_custom(func(a: Array, b: Array) -> bool: return a[1] < b[1])
	for p: Array in props:
		call("_" + p[2], p[0], p[1])
	# Moss and cracks.
	for i in 60:
		var x := 24 + int(_hash(i, 1) * 590)
		var y := 56 + int(_hash(i, 2) * 240)
		if _hash(i, 3) < 0.5:
			_rect(x, y, 2, 1, "5c5d41")
			_rect(x + 1, y + 1, 1, 1, "353f23")
		else:
			_px(x, y, "1d1a59"); _px(x + 1, y + 1, "1d1a59"); _px(x + 1, y + 2, "1d1a59")
	_hud()


func _flagstone(x: int, y: int, tx: int, ty: int) -> void:
	var shade := "464b8c" if _hash(tx, ty) > 0.35 else "53427f"
	_rect(x, y, TILE, TILE, shade)
	_rect(x, y, TILE, 1, "293268")
	_rect(x, y, 1, TILE, "293268")
	_rect(x + 1, y + 1, TILE - 2, 1, "6b74b2")
	if _hash(tx, ty + 99) > 0.8:
		_rect(x + 4, y + 6, 5, 1, "293268")


func _bricks(x: int, y: int, tx: int, ty: int) -> void:
	_rect(x, y, TILE, TILE, "53427f")
	for row in 2:
		var by := y + row * 8
		_rect(x, by, TILE, 1, "3c2c68")
		var off := 8 if (ty * 2 + row) % 2 == 1 else 0
		_rect(x + off, by, 1, 8, "3c2c68")
		_rect(x + off + 1, by + 1, 6, 1, "7b6aa5")
	if _hash(tx, ty) > 0.85:
		_rect(x + 3, y + 10, 3, 2, "5c5d41")


func _torch(x: int, y: int) -> void:
	_rect(x - 2, y, 4, 6, "61393b")
	_rect(x - 3, y, 6, 1, "895654")
	_glow_rect(x - 2, y - 6, 4, 6, "ff695a")
	_glow_rect(x - 1, y - 8, 2, 6, "ffaa6e")
	_glow_rect(x, y - 5, 1, 3, "ffe091")


func _pillar(x: int, y: int) -> void:
	_rect(x - 9, y - 4, 18, 6, "1d1a59")  # shadow
	_rect(x - 7, y - 50, 14, 50, "7b6aa5")
	_rect(x + 2, y - 50, 5, 50, "53427f")
	_rect(x - 9, y - 54, 18, 6, "a293c4")
	_rect(x - 9, y - 4, 18, 4, "a293c4")
	_frame(x - 9, y - 54, 18, 54, "293268")


func _brazier(x: int, y: int) -> void:
	_rect(x - 9, y - 2, 18, 4, "1d1a59")
	_rect(x - 8, y - 12, 16, 10, "61393b")
	_rect(x - 8, y - 12, 16, 2, "895654")
	_frame(x - 8, y - 12, 16, 12, "3f1f3c")
	_glow_rect(x - 6, y - 20, 12, 8, "ff695a")
	_glow_rect(x - 4, y - 24, 8, 8, "ffaa6e")
	_glow_rect(x - 2, y - 22, 4, 5, "ffe091")


func _chest(x: int, y: int) -> void:
	_rect(x - 11, y - 1, 22, 3, "1d1a59")
	_rect(x - 10, y - 14, 20, 14, "895654")
	_rect(x - 10, y - 14, 20, 4, "cc817a")
	_rect(x - 10, y - 9, 20, 2, "ffe091")
	_rect(x - 1, y - 9, 2, 4, "ffe091")
	_frame(x - 10, y - 14, 20, 14, "3f1f3c")


func _bones(x: int, y: int) -> void:
	_rect(x - 6, y - 1, 9, 2, "cdc599")
	_rect(x + 1, y - 4, 2, 6, "cdc599")
	_rect(x + 4, y - 4, 5, 4, "ffffff")
	_px(x + 5, y - 3, "1d1a59"); _px(x + 7, y - 3, "1d1a59")


func _husk(x: int, y: int) -> void:
	_rect(x - 7, y - 2, 14, 3, "1d1a59")
	_rect(x - 5, y - 22, 10, 8, "919b45")
	_rect(x - 6, y - 15, 12, 13, "61393b")
	_rect(x - 6, y - 15, 3, 13, "895654")
	_rect(x - 8, y - 14, 2, 8, "919b45"); _rect(x + 6, y - 14, 2, 8, "919b45")
	_rect(x - 4, y - 3, 3, 3, "5c5d41"); _rect(x + 1, y - 3, 3, 3, "5c5d41")
	_frame(x - 6, y - 22, 12, 22, "353f23")
	_glow_rect(x - 3, y - 19, 2, 2, "ff695a")
	_glow_rect(x + 1, y - 19, 2, 2, "ff695a")


func _wizard(x: int, y: int) -> void:
	_rect(x - 7, y - 1, 14, 3, "1d1a59")
	for r in 11:
		_rect(x - r / 2, y - 29 + r, r + 1, 1, "5d2f8c")
	_rect(x - 6, y - 19, 13, 2, "3c2c68")
	_rect(x - 3, y - 17, 7, 5, "ffd3ad")
	_px(x - 2, y - 15, "000000"); _px(x + 2, y - 15, "000000")
	_rect(x - 2, y - 13, 5, 4, "ffffff")
	for r in 13:
		_rect(x - 2 - r / 3, y - 12 + r, 5 + 2 * (r / 3), 1, "854cbf")
	_rect(x + 1, y - 10, 3, 10, "5d2f8c")
	_rect(x + 7, y - 22, 1, 22, "895654")
	_glow_rect(x + 6, y - 25, 3, 3, "27d3cb")


func _hud() -> void:
	_rect(0, ROOM_H, W, H - ROOM_H, "12173d", true)
	_rect(0, ROOM_H, W, 1, "464b8c", true)
	for i in 10:
		var x := 160 + i * 32
		_rect(x, ROOM_H + 10, 26, 26, "293268", true)
		_rect(x, ROOM_H + 10, 26, 1, "6b74b2", true)
		_rect(x + 2, ROOM_H + 12, 22, 22, "1d1a59", true)
		if i < 6:
			_rect(x + 8, ROOM_H + 18, 10, 10, ["dd3745", "3e83d1", "42bc7f", "ffe091", "b483ef", "ff695a"][i], true)
	_rect(12, ROOM_H + 12, 130, 8, "721c2f", true)
	_rect(12, ROOM_H + 12, 96, 8, "dd3745", true)
	_rect(12, ROOM_H + 26, 130, 8, "163755", true)
	_rect(12, ROOM_H + 26, 110, 8, "3e83d1", true)


# ---------------------------------------------------------------- light, held to a palette

## Darkness plus every light, then each pixel snapped to the nearest colour of `pal`.
## Light falls in steps, blended by an ordered dither where two steps meet.
func _light(src: Image, pal: Array) -> Image:
	var bayer := [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5]
	var cache := {}
	var out := Image.create_empty(W, H, false, Image.FORMAT_RGB8)
	for y in H:
		for x in W:
			var i := y * W + x
			var c := src.get_pixel(x, y)
			if emissive[i] == 1 or hud[i] == 1:
				out.set_pixel(x, y, _nearest(c, pal, cache))
				continue
			var l := Vector3(AMBIENT, AMBIENT, AMBIENT * 1.4)
			for li: Array in lights:
				var d := Vector2(x, y).distance_to(li[0])
				var f := clampf(1.0 - d / float(li[1]), 0.0, 1.0)
				l += (li[2] as Vector3) * f * f * 1.15
			var t: float = bayer[(y % 4) * 4 + x % 4] / 16.0
			var q := Vector3(floorf(l.x * 8.0 + t), floorf(l.y * 8.0 + t), floorf(l.z * 8.0 + t)) / 8.0
			out.set_pixel(x, y, _nearest(Color(minf(c.r * q.x, 1.0), minf(c.g * q.y, 1.0), minf(c.b * q.z, 1.0)), pal, cache))
	return out


## The same room drawn in another palette: every colour replaced by its nearest there.
func _remap(src: Image, pal: Array) -> Image:
	var cache := {}
	var out := src.duplicate()
	for y in H:
		for x in W:
			out.set_pixel(x, y, _nearest(src.get_pixel(x, y), pal, cache))
	return out


## Nearest colour by distance in CIELAB, so dark tones are matched as the eye sees them.
func _nearest(c: Color, pal: Array, cache: Dictionary) -> Color:
	var key := c.to_html(false)
	if cache.has(key):
		return cache[key]
	var lc := _lab(c)
	var best: Color = pal[0]
	var best_d := INF
	for p: Color in pal:
		var d := lc.distance_squared_to(_lab(p))
		if d < best_d:
			best_d = d
			best = p
	cache[key] = best
	return best


func _lab(c: Color) -> Vector3:
	var lin := func(u: float) -> float: return pow((u + 0.055) / 1.055, 2.4) if u > 0.04045 else u / 12.92
	var r: float = lin.call(c.r)
	var g: float = lin.call(c.g)
	var b: float = lin.call(c.b)
	var xx := (0.4124 * r + 0.3576 * g + 0.1805 * b) / 0.95047
	var yy := 0.2126 * r + 0.7152 * g + 0.0722 * b
	var zz := (0.0193 * r + 0.1192 * g + 0.9505 * b) / 1.08883
	var f := func(t: float) -> float: return pow(t, 1.0 / 3.0) if t > 0.008856 else 7.787 * t + 16.0 / 116.0
	var fy: float = f.call(yy)
	return Vector3(116.0 * fy - 16.0, 500.0 * (f.call(xx) - fy), 200.0 * (fy - f.call(zz)))


# ---------------------------------------------------------------- measures

func _outside(img: Image, pal: Array) -> int:
	var allowed := {}
	for p: Color in pal:
		allowed[p.to_html(false)] = true
	var n := 0
	for y in H:
		for x in W:
			if not allowed.has(img.get_pixel(x, y).to_html(false)):
				n += 1
	return n


## Distinct colours where the light is weak: how much shading the dark parts of the room keep.
func _dim_colours(img: Image) -> int:
	var seen := {}
	for y in ROOM_H:
		for x in W:
			var lit := false
			for li: Array in lights:
				if Vector2(x, y).distance_to(li[0]) < float(li[1]) * 0.6:
					lit = true
					break
			if not lit:
				seen[img.get_pixel(x, y).to_html(false)] = true
	return seen.size()


func _darks(img: Image) -> int:
	var seen := {}
	for y in ROOM_H:
		for x in W:
			var c := img.get_pixel(x, y)
			if _lab(c).x < 15.0:
				seen[c.to_html(false)] = true
	return seen.size()


# ---------------------------------------------------------------- drawing helpers

func _palette(hexes: String) -> Array:
	var out := []
	for h in hexes.split(" "):
		out.append(Color(h))
	return out


func _px(x: int, y: int, c: String) -> void:
	if x >= 0 and y >= 0 and x < W and y < H:
		base.set_pixel(x, y, Color(c))


func _rect(x: int, y: int, w: int, h: int, c: String, is_hud := false) -> void:
	for yy in range(y, y + h):
		for xx in range(x, x + w):
			_px(xx, yy, c)
			if is_hud and xx >= 0 and yy >= 0 and xx < W and yy < H:
				hud[yy * W + xx] = 1


func _glow_rect(x: int, y: int, w: int, h: int, c: String) -> void:
	_rect(x, y, w, h, c)
	for yy in range(maxi(0, y), mini(H, y + h)):
		for xx in range(maxi(0, x), mini(W, x + w)):
			emissive[yy * W + xx] = 1


func _frame(x: int, y: int, w: int, h: int, c: String) -> void:
	_rect(x - 1, y - 1, w + 2, 1, c)
	_rect(x - 1, y + h, w + 2, 1, c)
	_rect(x - 1, y, 1, h, c)
	_rect(x + w, y, 1, h, c)


func _hash(x: int, y: int) -> float:
	var h := (x * 374761393 + y * 668265263) & 0xffffffff
	h = ((h ^ (h >> 13)) * 1274126177) & 0xffffffff
	return float((h ^ (h >> 16)) & 0xffff) / 65536.0
