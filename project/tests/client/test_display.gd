extends TestCase
## How the game draws: the pixel grid of ART_DIRECTION.md, at screen resolution.


func test_the_art_grid_is_640_by_360() -> void:
	assert_eq(ProjectSettings.get_setting("display/window/size/viewport_width"), 640)
	assert_eq(ProjectSettings.get_setting("display/window/size/viewport_height"), 360)


func test_the_scene_is_drawn_at_screen_resolution_by_whole_numbers() -> void:
	# canvas_items: positions finer than an art pixel, so movement stays smooth on any screen.
	assert_eq(ProjectSettings.get_setting("display/window/stretch/mode"), "canvas_items")
	assert_eq(ProjectSettings.get_setting("display/window/stretch/scale_mode"), "integer")


func test_the_frame_rate_follows_the_screen() -> void:
	assert_eq(ProjectSettings.get_setting("application/run/max_fps"), 0)


func test_the_theme_font_is_pixel_operator_at_16() -> void:
	var theme := load(str(ProjectSettings.get_setting("gui/theme/custom"))) as Theme
	assert_true(theme != null)
	assert_eq(theme.default_font.resource_path, "res://assets/fonts/PixelOperator.ttf")
	assert_eq(theme.default_font_size, 16)


func test_the_font_is_imported_without_smoothing() -> void:
	var font := load("res://assets/fonts/PixelOperator.ttf") as FontFile
	assert_eq(font.antialiasing, TextServer.FONT_ANTIALIASING_NONE)
	assert_eq(font.hinting, TextServer.HINTING_NONE)
	assert_eq(font.subpixel_positioning, TextServer.SUBPIXEL_POSITIONING_DISABLED)


func test_the_hud_never_asks_for_another_font_size() -> void:
	var source := FileAccess.get_file_as_string("res://client/hud.gd")
	assert_false(source.contains("font_size"), "hud.gd sets a font size")
