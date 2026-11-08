class_name ServerWorld
extends Node
## The authoritative world, advanced one simulation tick at a time.
##
## Each tick, in this order: every wizard applies at most one movement input and walks
## through any exit; spells in flight move and hit; destroyed training dummies stand up
## again; mana comes back. Then every client gets a [StateUpdate] of its room, with the
## sequence number of the last input applied so it can reconcile its prediction.
##
## A cast, a card taken and a village bought arrive as requests: each is checked here before
## anything changes.

## Rooms by id. Loaded from [constant RoomCatalog.DEFAULT_FOLDER] unless a test sets them.
var rooms: Dictionary[StringName, RoomData] = { }
## Cards by id. Loaded from [constant CardCatalog.DEFAULT_FOLDER] unless a test sets them.
var cards: Dictionary[StringName, Card] = { }
## Every number the design has not settled; see [PlaceholderValues].
var values: PlaceholderValues
## The room every new wizard starts in.
var start_room := &"first_room"
var tick := 0

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
	tick += 1
	for peer_id: int in _wizards:
		var wizard_state := _wizards[peer_id]
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
	return true


func add_wizard(peer_id: int) -> void:
	var wizard := WizardState.new()
	wizard.room_id = start_room
	wizard.position = rooms[start_room].tile_center(rooms[start_room].spawn_tile)
	wizard.gold = values.starting_gold
	_wizards[peer_id] = wizard


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
			_channel.send_state_update(peer_id, shared)


## The part of a state update every client in the room shares.
func _room_state(room_id: StringName, peer_ids: PackedInt32Array) -> StateUpdate:
	var update := StateUpdate.new()
	update.tick = tick
	update.room_id = room_id
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
	for village: VillageState in _villages.get(room_id, []):
		update.village_positions.append(village.position)
		update.village_owners.append(village.owner_peer_id)
	return update


func _on_move_requested(peer_id: int, first_sequence: int, codes: PackedByteArray) -> void:
	if _wizards.has(peer_id):
		_wizards[peer_id].inputs.receive(first_sequence, codes)


## Checked in turn: a known wizard, Grimoire position 1 (the only spell for now), an aim
## that is a real direction, the cooldown over, and the mana to pay. Anything else is
## ignored without a word: a well-behaved client never sends it.
func _on_cast_requested(peer_id: int, grimoire_position: int, aim: Vector2) -> void:
	if not _wizards.has(peer_id) or grimoire_position != 1:
		return
	if not aim.is_finite() or aim.length() < 0.001:
		return
	var wizard_state := _wizards[peer_id]
	if tick < wizard_state.ready_tick or wizard_state.mana < values.spell_mana_cost:
		return
	wizard_state.mana -= values.spell_mana_cost
	wizard_state.ready_tick = tick + values.spell_cooldown_ticks
	var projectile := Projectile.new()
	projectile.caster_peer_id = peer_id
	projectile.room_id = wizard_state.room_id
	projectile.position = wizard_state.position + Projectile.BODY_OFFSET
	projectile.velocity = aim.normalized() * values.spell_projectile_speed
	projectile.distance_left = values.spell_range_tiles * Simulation.TILE_SIZE
	projectile.raw_damage = values.spell_raw_damage
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
	if not _wizards.has(peer_id) or village_index < 0:
		return
	_wizards[peer_id].pending_purchase = village_index
	_wizards[peer_id].purchase_after = after_sequence


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
