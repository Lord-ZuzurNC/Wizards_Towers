extends TestCase
## Every colour the client draws with comes from BLK NX64 (ART_DIRECTION.md, Palettes).

const BLK_NX64 := (
	"000000 12173d 293268 464b8c 6b74b2 909edd c1d9f2 ffffff a293c4 7b6aa5 53427f 3c2c68 "
	+ "431e66 5d2f8c 854cbf b483ef 8cff9b 42bc7f 22896e 14665b 0f4a4c 0a2a33 1d1a59 322d89 "
	+ "354ab2 3e83d1 50b9eb 8cdaff 53a1ad 3b768f 21526b 163755 008782 00aaa5 27d3cb 78fae6 "
	+ "cdc599 988f64 5c5d41 353f23 919b45 afd370 ffe091 ffaa6e ff695a b23c40 ff6675 dd3745 "
	+ "a52639 721c2f b22e69 e54286 ff6eaf ffa5d5 ffd3ad cc817a 895654 61393b 3f1f3c 723352 "
	+ "994c69 c37289 f29faa ffccd0"
)


func test_the_palette_has_64_colours() -> void:
	assert_eq(_palette().size(), 64)


func test_the_client_colour_constants_are_in_the_palette() -> void:
	for script: Script in [ClientWorld, Hud, Rarity]:
		_check_constants(script)


func test_the_placeholder_spells_are_in_the_palette() -> void:
	var palette := _palette()
	for spell in PlaceholderValues.new().spells:
		assert_true(palette.has(spell.color.to_html(false)), spell.color.to_html(false))


func _check_constants(script: Script) -> void:
	var palette := _palette()
	var constants := script.get_script_constant_map()
	for name: String in constants:
		var value: Variant = constants[name]
		var colors: Array = []
		if value is Color:
			colors = [value]
		elif value is Array:
			var list: Array = value
			colors = list.filter(_is_color)
		for color: Color in colors:
			# Translucent shades are an overlay on palette colours, not colours of their own.
			if color.a < 1.0:
				continue
			assert_true(
				palette.has(color.to_html(false)),
				"%s.%s = %s" % [script.resource_path, name, color.to_html(false)],
			)


static func _is_color(value: Variant) -> bool:
	return value is Color


func _palette() -> PackedStringArray:
	return BLK_NX64.split(" ", false)
