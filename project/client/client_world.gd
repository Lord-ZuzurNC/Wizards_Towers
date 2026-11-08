class_name ClientWorld
extends Node2D
## What the player sees of the world: the room, the wizards, the dummies, the spells and
## the villages.
##
## The player's wizard is predicted, see [MovementPredictor]. Every other wizard is drawn
## [constant INTERPOLATION_TICKS] simulation ticks in the past, between two positions
## already received, so a late or lost update never makes it stutter (TECH_STACK.md,
## Netcode). Spells and dummies are drawn where the last update put them: nothing about
## them is predicted.
##
## Everything is a flat coloured shape from the BLK NX64 palette, standing in until its art
## exists. A world map is coloured by biome; a camera follows the player's wizard across
## anything larger than the screen.

## The player's own numbers changed: health, mana, level or XP.
signal status_changed
## The pending card choices changed.
signal card_choices_changed

## How far in the past other wizards are drawn: 3 ticks, 100 ms.
const INTERPOLATION_TICKS := 3.0
const WALL_COLOR := Color("12173d")
const FLOOR_COLOR := Color("293268")
const EXIT_COLOR := Color("3e83d1")
const OWN_COLOR := Color("ffaa6e")
const OTHER_COLOR := Color("8cff9b")
const DUMMY_COLOR := Color("cdc599")
const HEALTH_COLOR := Color("ff695a")
const SPELL_COLOR := Color("ff695a")
const VILLAGE_WALL_COLOR := Color("895654")
const VILLAGE_ROOF_COLOR := Color("b23c40")
## The flag under a village no one holds; a held one flies its holder's colour.
const FREE_FLAG_COLOR := Color("909edd")
## A village drawn around its tile centre: walls, then a roof on top.
const VILLAGE_WALLS := Rect2(-10.0, -6.0, 20.0, 12.0)
const VILLAGE_ROOF := Rect2(-12.0, -12.0, 24.0, 6.0)
const VILLAGE_FLAG := Rect2(-10.0, 7.0, 20.0, 2.0)
## Each biome's ground in [enum Biome.Kind] order, and a second shade scattered over it so
## walking shows on wide open ground. From the terrain pre-POC.
## Two flat lists rather than a list of pairs: in Godot 4.7.2, reading a Color out of a
## constant Array[PackedColorArray] gives an empty Color.
const BIOME_GROUND: Array[Color] = [
	Color("afd370"),
	Color("22896e"),
	Color("5c5d41"),
	Color("c1d9f2"),
	Color("ffe091"),
	Color("7b6aa5"),
	Color("3f1f3c"),
	Color("3e83d1"),
]
const BIOME_SCATTER: Array[Color] = [
	Color("919b45"),
	Color("14665b"),
	Color("353f23"),
	Color("909edd"),
	Color("ffaa6e"),
	Color("53427f"),
	Color("61393b"),
	Color("354ab2"),
]
const SPINE_COLOR := Color("3c2c68")
const CRATER_COLOR := Color("ff695a")
const RIFT_CORE_COLOR := Color("ff695a")
const RIFT_BANK_COLOR := Color("723352")
const LAKE_COLOR := Color("50b9eb")
## The screen in art pixels, and the HUD band along its bottom that the map scrolls above.
const SCREEN := Vector2i(640, 360)
const HUD_HEIGHT := 40
## A correction larger than this, in pixels, is a jump rather than a nudge: the wizard is
## placed there at once instead of gliding.
const SNAP_DISTANCE := 8.0

## Rooms by id. Loaded from [constant RoomCatalog.DEFAULT_FOLDER] unless a test sets them.
var rooms: Dictionary[StringName, RoomData] = { }
## Cards by id, to show a choice. Loaded from [constant CardCatalog.DEFAULT_FOLDER] unless a
## test sets them.
var cards: Dictionary[StringName, Card] = { }
## Every number the design has not settled; see [PlaceholderValues]. The client needs the
## village reach to say when a village can be bought.
var values: PlaceholderValues
## Stands in for the keyboard when set to a direction code from 0 to 8; tests use it.
var input_override := -1
## True while a panel takes the mouse, so a click on it casts nothing.
var ui_has_mouse := false
var room: RoomData
## The latest numbers the server sent about the player's own wizard.
var status := StateUpdate.new()
## How many card choices wait to be opened.
var pending_choices := 0
## The cards of the oldest waiting choice, the one opened next.
var offered_cards: Array[Card] = []

var _channel: WorldChannel
var _own_peer_id := 0
var _predictor := MovementPredictor.new()
var _own_marker: WizardMarker
var _others: Dictionary[int, WizardMarker] = { }
var _overlay := Overlay.new()
var _camera := Camera2D.new()
## The wizard's position on the tick before, to place the camera between two ticks.
var _own_drawn_from := Vector2.ZERO
var _village_owners: PackedInt32Array = []
var _latest_tick := 0
var _render_tick := 0.0


func _init() -> void:
	name = "World"
	_overlay.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	_overlay.z_index = 2
	add_child(_overlay)
	# Placed every frame on the wizard as drawn, so it needs no smoothing of its own.
	_camera.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	_camera.limit_left = 0
	_camera.limit_top = 0
	add_child(_camera)


func _process(delta: float) -> void:
	if _latest_tick == 0:
		return
	_render_tick += delta * Simulation.TICK_RATE
	var target := _latest_tick - INTERPOLATION_TICKS
	if absf(_render_tick - target) > INTERPOLATION_TICKS * 2.0:
		_render_tick = target
	for marker: WizardMarker in _others.values():
		marker.position = marker.position_at(_render_tick)
	if _own_marker != null:
		# Where the engine draws the wizard between two ticks: the camera stays on it.
		var fraction := Engine.get_physics_interpolation_fraction()
		_camera.position = _own_drawn_from.lerp(_own_marker.position, fraction)


func _physics_process(_delta: float) -> void:
	if _predictor.room == null:
		return
	_predictor.apply_local(_read_input())
	_channel.send_move(
		_predictor.first_unacknowledged(Protocol.INPUTS_SENT_PER_MESSAGE),
		_predictor.unacknowledged_codes(Protocol.INPUTS_SENT_PER_MESSAGE),
	)
	_own_drawn_from = _own_marker.position
	_own_marker.position = _predictor.position
	if input_override < 0 and not ui_has_mouse:
		var aim := get_global_mouse_position() - (_predictor.position + Projectile.BODY_OFFSET)
		for grimoire_position in range(1, Grimoire.MAX_POSITIONS + 1):
			# Exact match: Shift with the left button casts from 6, never from 1 as well.
			if Input.is_action_just_pressed(cast_action(grimoire_position), true):
				cast(grimoire_position, aim)
	if input_override < 0 and Input.is_action_just_pressed(&"interact"):
		var village := village_in_reach()
		if village >= 0:
			buy_village(village)


func _draw() -> void:
	if room == null:
		return
	var tile := Vector2(Simulation.TILE_SIZE, Simulation.TILE_SIZE)
	var size := room.size()
	var world_map := room as WorldMapData
	for y in size.y:
		for x in size.x:
			var color: Color
			if world_map != null:
				color = terrain_color(world_map, Vector2i(x, y))
			else:
				color = WALL_COLOR if room.is_solid(Vector2i(x, y)) else FLOOR_COLOR
			draw_rect(Rect2(Vector2(x, y) * tile, tile), color)
	for room_exit in room.exits:
		draw_rect(
			Rect2(Vector2(room_exit.area.position) * tile, Vector2(room_exit.area.size) * tile),
			EXIT_COLOR,
		)
	for i in room.villages.size():
		var at := room.tile_center(room.villages[i].tile)
		draw_rect(Rect2(at + VILLAGE_WALLS.position, VILLAGE_WALLS.size), VILLAGE_WALL_COLOR)
		draw_rect(Rect2(at + VILLAGE_ROOF.position, VILLAGE_ROOF.size), VILLAGE_ROOF_COLOR)
		draw_rect(Rect2(at + VILLAGE_FLAG.position, VILLAGE_FLAG.size), _flag_color(i))


## Connects the world to its channel, once the session has started.
func setup(channel: WorldChannel, own_peer_id: int) -> void:
	_channel = channel
	_own_peer_id = own_peer_id
	_channel.state_update_received.connect(_on_state_update_received)
	_channel.card_choices_received.connect(_on_card_choices_received)
	if rooms.is_empty():
		rooms = RoomCatalog.load_folder()
	if cards.is_empty():
		cards = CardCatalog.load_folder()
	if values == null:
		values = PlaceholderValues.load_default()


## The input action casting from [param grimoire_position], 1 to 10.
static func cast_action(grimoire_position: int) -> StringName:
	return StringName("cast_%d" % grimoire_position)


## Asks the server to cast the spell of [param grimoire_position] toward [param aim].
## Nothing appears until the server accepts it.
func cast(grimoire_position: int, aim: Vector2) -> void:
	if _channel != null:
		_channel.send_cast(grimoire_position, aim)


## Asks the server to buy village [param index] of the current room. Nothing changes until
## the server accepts it.
func buy_village(index: int) -> void:
	if _channel != null:
		_channel.send_buy_village(index, _predictor.last_sequence())


## The nearest village of the room within reach of the player's wizard, or -1.
func village_in_reach() -> int:
	if room == null or values == null:
		return -1
	var reach := values.village_reach_tiles * Simulation.TILE_SIZE
	var nearest := -1
	var nearest_distance := INF
	for i in room.villages.size():
		var distance := _predictor.position.distance_to(room.tile_center(room.villages[i].tile))
		if distance <= reach and distance < nearest_distance:
			nearest = i
			nearest_distance = distance
	return nearest


## What pressing the key would do for village [param index], by the server's own rules.
func village_verdict(index: int) -> VillagePurchase.Verdict:
	return VillagePurchase.judge(
		_predictor.position.distance_to(room.tile_center(room.villages[index].tile)),
		values.village_reach_tiles * Simulation.TILE_SIZE,
		village_owner(index),
		status.wizard_level,
		status.villages_held,
		status.gold,
		status.village_price,
	)


## The peer id holding village [param index] of the room, as last received; 0 for none.
func village_owner(index: int) -> int:
	return _village_owners[index] if index < _village_owners.size() else 0


## Whether village [param index] of the room is the player's.
func owns_village(index: int) -> bool:
	return village_owner(index) == _own_peer_id


## Takes card [param index] of the oldest waiting choice.
func take_card(index: int) -> void:
	if _channel != null and pending_choices > 0:
		_channel.send_take_card(index)


## Where the player is: the biome under their wizard's feet on a world map, the room's
## name anywhere else. Empty before the first update.
func location_name() -> String:
	if room == null:
		return ""
	var biome := current_biome()
	return Biome.label(biome) if biome >= 0 else room.display_name()


## The middle of what the camera shows, after the map's edges have stopped it.
func camera_center() -> Vector2:
	return _camera.get_screen_center_position()


## The biome under the player's wizard's feet; -1 outside a world map.
func current_biome() -> int:
	var world_map := room as WorldMapData
	if world_map == null:
		return -1
	return world_map.biome_at(world_map.tile_at(_predictor.position))


## Where the player's own wizard stands, as predicted.
func own_position() -> Vector2:
	return _predictor.position


## The peer ids of the other wizards drawn in the current room.
func other_peer_ids() -> Array[int]:
	var ids: Array[int] = []
	ids.assign(_others.keys())
	return ids


## The health of each training dummy in the room, as last received; 0 is destroyed.
func dummy_health() -> PackedInt32Array:
	return _overlay.dummy_health


## The Grimoire position each spell in flight was cast from, as last received.
func projectile_spells() -> PackedInt32Array:
	return _overlay.projectile_spells


## Where the spells in flight were, as last received.
func projectile_positions() -> PackedVector2Array:
	return _overlay.projectile_positions


func _read_input() -> int:
	if input_override >= 0:
		return input_override
	var direction := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	return Movement.encode(Vector2i(signi(roundi(direction.x)), signi(roundi(direction.y))))


func _on_state_update_received(update: StateUpdate) -> void:
	if update.tick <= _latest_tick or not rooms.has(update.room_id):
		return
	_latest_tick = update.tick
	if rooms[update.room_id] != room:
		_enter_room(rooms[update.room_id])
	for i in update.wizard_ids.size():
		if update.wizard_ids[i] == _own_peer_id:
			_reconcile(update.acknowledged, update.wizard_positions[i])
		else:
			_other_marker(update.wizard_ids[i]).add_sample(update.tick, update.wizard_positions[i])
	for peer_id: int in _others.keys():
		if not update.wizard_ids.has(peer_id):
			_others[peer_id].queue_free()
			_others.erase(peer_id)
	_overlay.show_update(update, values)
	if update.village_owners != _village_owners:
		_village_owners = update.village_owners
		queue_redraw()
	status = update
	status_changed.emit()


func _on_card_choices_received(pending: int, card_ids: PackedStringArray) -> void:
	pending_choices = maxi(0, pending)
	offered_cards.clear()
	for id in card_ids:
		if cards.has(id):
			offered_cards.append(cards[id])
	card_choices_changed.emit()


## The colour [param tile] of [param world_map] is drawn in.
static func terrain_color(world_map: WorldMapData, tile: Vector2i) -> Color:
	match world_map.feature_at(tile):
		Biome.Feature.SPINE:
			return SPINE_COLOR
		Biome.Feature.CRATER:
			return CRATER_COLOR
		Biome.Feature.RIFT_CORE:
			return RIFT_CORE_COLOR
		Biome.Feature.RIFT_BANK:
			return RIFT_BANK_COLOR
		Biome.Feature.WATER:
			if world_map.biome_at(tile) == Biome.Kind.GLACIER:
				return LAKE_COLOR
	var biome := world_map.biome_at(tile)
	# A fixed scatter of the second shade: about one tile in six.
	return BIOME_SCATTER[biome] if hash(tile) % 6 == 0 else BIOME_GROUND[biome]


func _flag_color(index: int) -> Color:
	var holder := village_owner(index)
	if holder == 0:
		return FREE_FLAG_COLOR
	return OWN_COLOR if holder == _own_peer_id else OTHER_COLOR


func _enter_room(new_room: RoomData) -> void:
	var first_room := room == null
	room = new_room
	var size := room.size() * Simulation.TILE_SIZE
	_camera.limit_right = maxi(size.x, SCREEN.x)
	# The HUD band hides the screen's bottom lines: the map may scroll on above it.
	_camera.limit_bottom = maxi(size.y + HUD_HEIGHT, SCREEN.y)
	for marker: WizardMarker in _others.values():
		marker.queue_free()
	_others.clear()
	if first_room:
		_own_marker = WizardMarker.new(OWN_COLOR)
		# Drawn above the others, so the player never loses sight of their own wizard.
		_own_marker.z_index = 1
		add_child(_own_marker)
		_camera.make_current()
	queue_redraw()


func _reconcile(acknowledged: int, server_position: Vector2) -> void:
	var before := _predictor.position
	if _predictor.room == null:
		_predictor.start(room, server_position)
	else:
		_predictor.reconcile(acknowledged, room, server_position)
	if before.distance_to(_predictor.position) > SNAP_DISTANCE:
		_own_marker.position = _predictor.position
		_own_marker.reset_physics_interpolation()
		_own_drawn_from = _predictor.position


func _other_marker(peer_id: int) -> WizardMarker:
	if not _others.has(peer_id):
		var marker := WizardMarker.new(OTHER_COLOR)
		# Moved every frame from interpolated positions, not by the physics tick.
		marker.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
		add_child(marker)
		_others[peer_id] = marker
	return _others[peer_id]


## A wizard on screen: a coloured block standing on its position, and, for others, the
## positions received for it, to draw it between two of them.
class WizardMarker:
	extends Node2D

	## The body drawn above the feet, which stand at the node's position.
	const BODY := Rect2(-6.0, -18.0, 12.0, 20.0)
	const KEPT_SAMPLES := 10

	var color: Color
	## (tick, position) pairs, oldest first.
	var _ticks: PackedFloat32Array = []
	var _positions: PackedVector2Array = []


	func _init(marker_color: Color) -> void:
		color = marker_color


	func _draw() -> void:
		draw_rect(BODY, color)


	func add_sample(tick: int, sample_position: Vector2) -> void:
		if _positions.is_empty():
			position = sample_position
		_ticks.append(tick)
		_positions.append(sample_position)
		if _ticks.size() > KEPT_SAMPLES:
			_ticks.remove_at(0)
			_positions.remove_at(0)


	## The position at [param tick], between the two samples around it; the nearest
	## sample when [param tick] lies outside them.
	func position_at(tick: float) -> Vector2:
		if _positions.is_empty():
			return position
		if tick <= _ticks[0]:
			return _positions[0]
		for i in range(1, _ticks.size()):
			if tick <= _ticks[i]:
				var weight := (tick - _ticks[i - 1]) / (_ticks[i] - _ticks[i - 1])
				return _positions[i - 1].lerp(_positions[i], weight)
		return _positions[-1]


## Training dummies, with a health bar, and spells in flight, as the last update had them.
class Overlay:
	extends Node2D

	const DUMMY_BODY := Rect2(-7.0, -20.0, 14.0, 22.0)
	const BAR := Rect2(-8.0, -25.0, 16.0, 2.0)
	const SPELL := Rect2(-2.0, -2.0, 4.0, 4.0)

	var dummy_positions: PackedVector2Array = []
	var dummy_health: PackedInt32Array = []
	var dummy_max_health: PackedInt32Array = []
	var projectile_positions: PackedVector2Array = []
	var projectile_colors: Array[Color] = []
	var projectile_spells: PackedInt32Array = []


	func _draw() -> void:
		for i in dummy_positions.size():
			if dummy_health[i] <= 0:
				continue
			var at := dummy_positions[i]
			draw_rect(Rect2(at + DUMMY_BODY.position, DUMMY_BODY.size), DUMMY_COLOR)
			var share := float(dummy_health[i]) / maxi(1, dummy_max_health[i])
			draw_rect(Rect2(at + BAR.position, BAR.size), WALL_COLOR)
			draw_rect(
				Rect2(at + BAR.position, Vector2(BAR.size.x * share, BAR.size.y)),
				HEALTH_COLOR,
			)
		for i in projectile_positions.size():
			var at := projectile_positions[i]
			draw_rect(Rect2(at + SPELL.position, SPELL.size), projectile_colors[i])


	func show_update(update: StateUpdate, values: PlaceholderValues) -> void:
		dummy_positions = update.dummy_positions
		dummy_health = update.dummy_health
		dummy_max_health = update.dummy_max_health
		projectile_positions = update.projectile_positions
		projectile_spells = update.projectile_spells
		projectile_colors.clear()
		for cast_from in update.projectile_spells:
			var known := values != null and cast_from >= 1 and cast_from <= values.spells.size()
			projectile_colors.append(values.spells[cast_from - 1].color if known else SPELL_COLOR)
		queue_redraw()
