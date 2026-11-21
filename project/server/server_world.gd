class_name ServerWorld
extends Node
## The authoritative world, advanced one simulation tick at a time.
##
## Each tick, in this order: the season moves on, and the run ends when winter runs out;
## every living wizard takes what its ground deals, applies at most one movement input,
## walks through any exit and gets mana back; spells in flight move and hit; destroyed
## training dummies stand up again. Then every client gets a [StateUpdate] of its room, with the
## sequence number of the last input applied so it can reconcile its prediction.
##
## When a run ends, every wizard starts a new one in the start room, as a newcomer: a
## wizard lives one run at most (GLOSSARY.md, run).
##
## A cast, a card taken and a village bought arrive as requests: each is checked here before
## anything changes.

## Rooms by id. Loaded from [constant RoomCatalog.DEFAULT_FOLDER] unless a test sets them.
var rooms: Dictionary[StringName, RoomData] = { }
## Cards by id. Loaded from [constant CardCatalog.DEFAULT_FOLDER] unless a test sets them.
var cards: Dictionary[StringName, Card] = { }
## Every number the design has not settled; see [PlaceholderValues].
var values: PlaceholderValues
## The room every new wizard starts in. `first_room` is still a quick two-room sanity
## test (`server/run-server.sh`, then setting this back by hand) — it is just no longer
## the default now that a populated world map exists to spawn into.
var start_room := &"world_map"
var tick := 0
## The tick the current run began.
var run_start_tick := 0
## The current [enum Season.Kind].
var season := Season.Kind.SPRING as int

var _channel: WorldChannel
var _wizards: Dictionary[int, WizardState] = { }
var _dummies: Dictionary[StringName, Array] = { }
var _villages: Dictionary[StringName, Array] = { }
var _projectiles: Array[Projectile] = []


static func _rarer_after(a: Card, b: Card) -> bool:
	return a.rarity < b.rarity


func _init() -> void:
	name = "World"


func _physics_process(_delta: float) -> void:
	# Nothing runs before setup(): no channel, no values, no rooms.
	if _channel == null:
		return
	tick += 1
	if not _advance_season():
		_end_run(WorldEnding.Kind.WORLD_COLLAPSE)
	for peer_id: int in _wizards:
		var wizard_state := _wizards[peer_id]
		# A dead wizard only stays where it fell, seen by its room, until the run ends.
		if wizard_state.is_dead:
			continue
		_suffer_ground(peer_id, wizard_state)
		_walk(wizard_state)
		_regain_mana(wizard_state)
		if wizard_state.pending_purchase >= 0:
			if wizard_state.inputs.last_applied >= wizard_state.purchase_after:
				_buy_village(peer_id, wizard_state.pending_purchase)
				wizard_state.pending_purchase = -1
	_move_projectiles()
	for room_dummies: Array in _dummies.values():
		for dummy: TrainingDummy in room_dummies:
			dummy.update(tick)
	_send_state_updates()


## Connects the world to the channel its messages travel on, and loads whatever no one
## set. Returns false when the start room is missing.
func setup(channel: WorldChannel) -> bool:
	_channel = channel
	_channel.move_requested.connect(_on_move_requested)
	_channel.cast_requested.connect(_on_cast_requested)
	_channel.take_card_requested.connect(_on_take_card_requested)
	_channel.buy_village_requested.connect(_on_buy_village_requested)
	_channel.edit_spell_requested.connect(_on_edit_spell_requested)
	if rooms.is_empty():
		rooms = RoomCatalog.load_folder()
	if cards.is_empty():
		cards = CardCatalog.load_folder()
	if values == null:
		values = PlaceholderValues.load_default()
	if not rooms.has(start_room):
		push_error("the start room '%s' does not exist" % start_room)
		return false
	for room_id: StringName in rooms:
		_dummies[room_id] = _place_dummies(rooms[room_id])
		_villages[room_id] = _place_villages(rooms[room_id])
	run_start_tick = tick
	_set_season(Season.Kind.SPRING)
	return true


func add_wizard(peer_id: int) -> void:
	_wizards[peer_id] = _newcomer()


## Ticks left before the season changes, or the run ends after winter.
func season_ticks_left() -> int:
	return Season.ticks_left(tick - run_start_tick, values.season_ticks)


## A wizard as it enters a run: in the start room, at level 1. On a world map, it appears
## on a random walkable tile rather than always the same spot — a world map has no one
## "right" place to start, unlike a room with a doorway.
func _newcomer() -> WizardState:
	var wizard := WizardState.new()
	wizard.room_id = start_room
	var start := rooms[start_room]
	var world_map := start as WorldMapData
	var random := world_map != null and world_map.random_spawn
	var tile := world_map.random_walkable_tile() if random else start.spawn_tile
	wizard.position = start.tile_center(tile)
	wizard.gold = values.starting_gold
	return wizard


## Moves the season on when its time has come. Returns false once winter has run out.
func _advance_season() -> bool:
	var now := Season.at(tick - run_start_tick, values.season_ticks)
	if now < 0:
		return false
	if now != season:
		_set_season(now)
	return true


func _set_season(kind: int) -> void:
	season = kind
	for room: RoomData in rooms.values():
		var world_map := room as WorldMapData
		if world_map != null:
			world_map.season = kind


## Ends the run for everybody, then starts the next one at once. Every wizard is told how
## the run ended, then becomes a newcomer in the start room; villages, dummies and spells in
## flight start over too. On the real world map, the map itself is torn down and regrown —
## a fresh world for the fresh run, not the same one forever.
func _end_run(ending: WorldEnding.Kind) -> void:
	_regrow_world_map()
	for peer_id: int in _wizards.keys():
		_channel.send_world_ending(peer_id, ending)
		var newcomer := _newcomer()
		# The same input stream goes on: the client keeps numbering its inputs from where it was.
		newcomer.inputs = _wizards[peer_id].inputs
		_wizards[peer_id] = newcomer
		_send_card_choices(peer_id)
	for room_id: StringName in rooms:
		_dummies[room_id] = _place_dummies(rooms[room_id])
		_villages[room_id] = _place_villages(rooms[room_id])
	_projectiles.clear()
	run_start_tick = tick
	_set_season(Season.Kind.SPRING)


## Replaces the real world map with a freshly generated one, and points its dungeon doors
## back at the right spot — a no-op everywhere else (test fixtures never use these ids).
func _regrow_world_map() -> void:
	var dungeon_exits: Array[StringName] = [&"dungeon_1_exit", &"dungeon_2_exit"]
	var dungeon_entrances: Array[StringName] = [&"dungeon_1_entrance", &"dungeon_2_entrance"]
	if not rooms.has(&"world_map"):
		return
	for room_id in dungeon_exits + dungeon_entrances:
		if not rooms.has(room_id):
			return
	var rng := RandomNumberGenerator.new()
	var fresh := WorldMapGenerator.generate_terrain(rng)
	var doors := WorldMapGenerator.place_points_of_interest(fresh, rng, dungeon_entrances)
	for i in dungeon_exits.size():
		var landing := WorldMapGenerator.nearby_open_tile(fresh, doors[i])
		(rooms[dungeon_exits[i]] as RoomData).exits[0].target_tile = landing
	rooms[&"world_map"] = fresh


## The hazard under a wizard's feet hits on its beat, twice a second: its damage, and its
## side effect renewed. Ember's burn then keeps hurting on the same beat after the wizard
## steps off; Rime's slow keeps slowing.
func _suffer_ground(peer_id: int, wizard_state: WizardState) -> void:
	if tick % Hazard.INTERVAL_TICKS == 0:
		var world_map := rooms[wizard_state.room_id] as WorldMapData
		var hazard := Hazard.Kind.NONE
		if world_map != null:
			hazard = world_map.hazard_at(world_map.tile_at(wizard_state.position))
		if hazard != Hazard.Kind.NONE:
			_hurt(peer_id, wizard_state, values.hazard_raw_damage)
		if hazard == Hazard.Kind.EMBER:
			wizard_state.burning_until = tick + values.burn_ticks
		elif hazard == Hazard.Kind.RIME:
			wizard_state.slowed_until = tick + values.slow_ticks
		elif wizard_state.is_burning(tick):
			_hurt(peer_id, wizard_state, values.burn_raw_damage)
	wizard_state.speed = Simulation.BASE_SPEED
	if wizard_state.is_slowed(tick):
		wizard_state.speed = roundi(Simulation.BASE_SPEED * (1.0 - values.slow_share))


## A hit through the wizard's magic_defence (FORMULAS.md, Combat). At 0 health the wizard
## dies, and its client is told its wizard ending once. A dead wizard takes no more hits.
func _hurt(peer_id: int, wizard_state: WizardState, raw_damage: int) -> void:
	if wizard_state.is_dead:
		return
	var dealt := Damage.dealt(raw_damage, Levels.magic_defence(wizard_state.wizard_level))
	wizard_state.health = maxi(0, wizard_state.health - dealt)
	if wizard_state.health > 0:
		return
	wizard_state.is_dead = true
	# Hazard damage (a burning rift bank, a freezing glacier) is the only lethal damage so
	# far, and no enemy exists yet to blame for MURDERED, CLAIMED_BY or the others. Death in
	# the open world is the closest of the seven until the bestiary (Milestone 2) gives
	# hazard death a more specific cause, or a real one.
	wizard_state.ending = WizardEnding.Kind.DEVOURED_WILDS
	_channel.send_wizard_died(peer_id, wizard_state.ending)


func remove_wizard(peer_id: int) -> void:
	_wizards.erase(peer_id)


func has_wizard(peer_id: int) -> bool:
	return _wizards.has(peer_id)


func wizard(peer_id: int) -> WizardState:
	return _wizards[peer_id]


func wizard_position(peer_id: int) -> Vector2:
	return _wizards[peer_id].position


func wizard_room(peer_id: int) -> StringName:
	return _wizards[peer_id].room_id


## The biome under a wizard's feet; -1 outside a world map. Hazards will hang on it.
func wizard_biome(peer_id: int) -> int:
	var wizard_state := _wizards[peer_id]
	var world_map := rooms[wizard_state.room_id] as WorldMapData
	if world_map == null:
		return -1
	return world_map.biome_at(world_map.tile_at(wizard_state.position))


func dummies_in(room_id: StringName) -> Array:
	return _dummies.get(room_id, [])


func villages_in(room_id: StringName) -> Array:
	return _villages.get(room_id, [])


## How many villages [param peer_id] holds, in every room.
func villages_held(peer_id: int) -> int:
	var held := 0
	for room_villages: Array in _villages.values():
		for village: VillageState in room_villages:
			if village.owner_peer_id == peer_id:
				held += 1
	return held


func _place_dummies(room: RoomData) -> Array:
	var placed: Array = []
	for tile in room.dummy_tiles:
		var dummy := TrainingDummy.new()
		dummy.position = room.tile_center(tile)
		dummy.max_health = values.dummy_health
		dummy.health = values.dummy_health
		dummy.magic_defence = values.dummy_magic_defence
		placed.append(dummy)
	return placed


## How many Grimoire positions a wizard may cast from.
func _open_positions(wizard_state: WizardState) -> int:
	if values.open_every_grimoire_position:
		return Grimoire.MAX_POSITIONS
	return Grimoire.positions(wizard_state.wizard_level)


func _place_villages(room: RoomData) -> Array:
	var placed: Array = []
	for site in room.villages:
		var village := VillageState.new()
		village.site = site
		village.position = room.tile_center(site.tile)
		placed.append(village)
	return placed


func _walk(wizard_state: WizardState) -> void:
	var code := wizard_state.inputs.take()
	if code < 0:
		return
	var room := rooms[wizard_state.room_id]
	wizard_state.position = Movement.step(wizard_state.position, code, wizard_state.speed, room)
	var room_exit := room.exit_at(wizard_state.position)
	if room_exit != null:
		wizard_state.room_id = room_exit.target_room
		wizard_state.position = rooms[wizard_state.room_id].tile_center(room_exit.target_tile)
		if rooms[wizard_state.room_id].is_dungeon:
			wizard_state.break_peace_shield()


func _regain_mana(wizard_state: WizardState) -> void:
	wizard_state.mana_carry += float(values.mana_per_second) / Simulation.TICK_RATE
	var whole := floori(wizard_state.mana_carry)
	wizard_state.mana_carry -= whole
	wizard_state.mana = mini(wizard_state.mana + whole, wizard_state.mana_pool())


func _move_projectiles() -> void:
	var still_flying: Array[Projectile] = []
	for projectile in _projectiles:
		if projectile.advance(rooms[projectile.room_id]) and not _strike(projectile):
			still_flying.append(projectile)
	_projectiles = still_flying


## Hits the first standing dummy the projectile touches. Returns whether it hit one.
## Wizards are not hit yet: fights between wizards come with a later step.
func _strike(projectile: Projectile) -> bool:
	for dummy: TrainingDummy in _dummies.get(projectile.room_id, []):
		if dummy.is_destroyed() or not projectile.hits(dummy.position):
			continue
		if dummy.take_hit(projectile.raw_damage, tick, values.dummy_respawn_ticks):
			_reward(projectile.caster_peer_id, values.dummy_xp, values.dummy_gold)
		return true
	return false


## The reward for a kill goes to whoever dealt the destroying hit, if still in the world.
func _reward(peer_id: int, xp: int, gold: int) -> void:
	if not _wizards.has(peer_id):
		return
	var wizard_state := _wizards[peer_id]
	wizard_state.gold += gold
	var levels_gained := wizard_state.gain_xp(xp, values.xp_per_level)
	for i in levels_gained:
		wizard_state.card_choices.append(_draw_card_choice())
	if levels_gained > 0:
		_send_card_choices(peer_id)


## Until run decks exist, every choice offers all the test cards, in rarity order.
func _draw_card_choice() -> PackedStringArray:
	var offered: Array[Card] = []
	offered.assign(cards.values())
	offered.sort_custom(_rarer_after)
	var ids := PackedStringArray()
	for card: Card in offered.slice(0, 3):
		ids.append(String(card.id))
	return ids


func _send_card_choices(peer_id: int) -> void:
	var choices := _wizards[peer_id].card_choices
	var first := choices[0] if not choices.is_empty() else PackedStringArray()
	_channel.send_card_choices(peer_id, choices.size(), first)


func _send_state_updates() -> void:
	var by_room: Dictionary[StringName, PackedInt32Array] = { }
	for peer_id: int in _wizards:
		var room_id := _wizards[peer_id].room_id
		if not by_room.has(room_id):
			by_room[room_id] = PackedInt32Array()
		by_room[room_id].append(peer_id)
	for room_id: StringName in by_room:
		var shared := _room_state(room_id, by_room[room_id])
		for peer_id in by_room[room_id]:
			var wizard_state := _wizards[peer_id]
			shared.acknowledged = wizard_state.inputs.last_applied
			shared.health = wizard_state.health
			shared.max_health = wizard_state.max_health()
			shared.mana = wizard_state.mana
			shared.mana_pool = wizard_state.mana_pool()
			shared.wizard_level = wizard_state.wizard_level
			shared.xp = wizard_state.xp
			shared.xp_to_next = values.xp_per_level
			shared.gold = wizard_state.gold
			shared.village_price = wizard_state.village_price(values)
			shared.villages_held = villages_held(peer_id)
			shared.grimoire_positions = _open_positions(wizard_state)
			var cooldowns := PackedInt32Array()
			for ready in wizard_state.ready_ticks:
				cooldowns.append(maxi(0, ready - tick))
			shared.cooldowns = cooldowns
			shared.speed = wizard_state.speed
			shared.effects = 0
			if wizard_state.is_burning(tick):
				shared.effects |= StateUpdate.BURNING
			if wizard_state.is_slowed(tick):
				shared.effects |= StateUpdate.SLOWED
			_channel.send_state_update(peer_id, shared)


## The part of a state update every client in the room shares.
func _room_state(room_id: StringName, peer_ids: PackedInt32Array) -> StateUpdate:
	var update := StateUpdate.new()
	update.tick = tick
	update.room_id = room_id
	update.season = season
	update.season_ticks_left = season_ticks_left()
	update.wizard_ids = peer_ids
	for peer_id in peer_ids:
		update.wizard_positions.append(_wizards[peer_id].position)
	for dummy: TrainingDummy in _dummies.get(room_id, []):
		update.dummy_positions.append(dummy.position)
		update.dummy_health.append(dummy.health)
		update.dummy_max_health.append(dummy.max_health)
	for projectile in _projectiles:
		if projectile.room_id == room_id:
			update.projectile_positions.append(projectile.position)
			update.projectile_spells.append(projectile.grimoire_position)
	for village: VillageState in _villages.get(room_id, []):
		update.village_positions.append(village.position)
		update.village_owners.append(village.owner_peer_id)
	return update


func _on_move_requested(peer_id: int, first_sequence: int, codes: PackedByteArray) -> void:
	if _wizards.has(peer_id) and not _wizards[peer_id].is_dead:
		_wizards[peer_id].inputs.receive(first_sequence, codes)


## Checked in turn: a known living wizard, a Grimoire position it has, a castable spell in it, a
## Bolt Shape (the only one whose behaviour is built so far — RUNES.md lists 20 more), an
## aim that is a real direction, that position's cooldown over, and the mana to pay.
## Anything else is ignored without a word: a well-behaved client never sends it.
##
## Damage, mana cost and cooldown come from [member WizardState.grimoire]'s real [Spell]
## (FORMULAS.md, Magic). A Bolt's flight has no formula yet (RUNES.md only says "fast"),
## so its speed and range still come from [member PlaceholderValues.spells], kept only for
## that and for the spell bar's colour.
func _on_cast_requested(peer_id: int, grimoire_position: int, aim: Vector2) -> void:
	if not _wizards.has(peer_id) or _wizards[peer_id].is_dead:
		return
	var wizard_state := _wizards[peer_id]
	if grimoire_position < 1 or grimoire_position > _open_positions(wizard_state):
		return
	if grimoire_position > values.spells.size():
		return
	if not aim.is_finite() or aim.length() < 0.001:
		return
	var slot := grimoire_position - 1
	var spell := wizard_state.grimoire[slot]
	if not spell.is_castable() or RuneCatalog.find(spell.rune_id(Spell.Slot.SHAPE)).id != &"bolt":
		return
	var mana_cost := spell.mana_cost()
	if tick < wizard_state.ready_ticks[slot] or wizard_state.mana < mana_cost:
		return
	wizard_state.mana -= mana_cost
	wizard_state.ready_ticks[slot] = tick + roundi(spell.cooldown() * Simulation.TICK_RATE)
	var kinetics := values.spells[slot]
	var projectile := Projectile.new()
	projectile.caster_peer_id = peer_id
	projectile.grimoire_position = grimoire_position
	projectile.room_id = wizard_state.room_id
	projectile.position = wizard_state.position + Projectile.BODY_OFFSET
	projectile.velocity = aim.normalized() * kinetics.projectile_speed
	projectile.distance_left = kinetics.range_tiles * Simulation.TILE_SIZE
	projectile.raw_damage = spell.raw_damage(wizard_state.power())
	_projectiles.append(projectile)


func _on_take_card_requested(peer_id: int, card_index: int) -> void:
	if not _wizards.has(peer_id):
		return
	var wizard_state := _wizards[peer_id]
	if wizard_state.card_choices.is_empty():
		return
	var offered: PackedStringArray = wizard_state.card_choices[0]
	if card_index < 0 or card_index >= offered.size():
		return
	wizard_state.cards_taken.append(offered[card_index])
	wizard_state.card_choices.pop_front()
	_send_card_choices(peer_id)


## Kept until the inputs sent before it have been applied; a newer request replaces it.
func _on_buy_village_requested(peer_id: int, village_index: int, after_sequence: int) -> void:
	if not _wizards.has(peer_id) or _wizards[peer_id].is_dead or village_index < 0:
		return
	_wizards[peer_id].pending_purchase = village_index
	_wizards[peer_id].purchase_after = after_sequence


## Checked in turn: a known living wizard, a Grimoire position it has, a valid [enum Spell.Slot],
## a rune of that slot's attribute, a grade the wizard knows that rune at. Where the editing
## wizard stands is not checked yet: "from the wizard's own tower" (GLOSSARY.md, spell
## editing) waits on territory, Milestone 4.
func _on_edit_spell_requested(
	peer_id: int,
	grimoire_position: int,
	slot: int,
	rune_id: StringName,
	grade: int,
) -> void:
	if not _wizards.has(peer_id) or _wizards[peer_id].is_dead:
		return
	var wizard_state := _wizards[peer_id]
	if grimoire_position < 1 or grimoire_position > _open_positions(wizard_state):
		return
	if slot < 0 or slot >= Spell.Slot.values().size():
		return
	if not wizard_state.known_runes.knows(rune_id, grade):
		return
	if not wizard_state.grimoire[grimoire_position - 1].set_rune(slot, rune_id, grade):
		return
	_channel.send_spell_edited(peer_id, grimoire_position, slot, rune_id, grade)


## A village of the wizard's own room, by its place in the room's list, checked by the same
## [VillagePurchase] rules the client shows. Anything refused is ignored without a word.
func _buy_village(peer_id: int, village_index: int) -> void:
	var wizard_state := _wizards[peer_id]
	var room_villages: Array = _villages.get(wizard_state.room_id, [])
	if village_index < 0 or village_index >= room_villages.size():
		return
	var village: VillageState = room_villages[village_index]
	var price := wizard_state.village_price(values)
	var verdict := VillagePurchase.judge(
		wizard_state.position.distance_to(village.position),
		values.village_reach_tiles * Simulation.TILE_SIZE,
		village.owner_peer_id,
		wizard_state.wizard_level,
		villages_held(peer_id),
		wizard_state.gold,
		price,
	)
	if verdict != VillagePurchase.Verdict.ALLOWED:
		return
	wizard_state.gold -= price
	wizard_state.village_purchases += 1
	village.owner_peer_id = peer_id
