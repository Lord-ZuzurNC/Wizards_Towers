class_name StateUpdate
extends RefCounted
## What the server tells one client after a simulation tick: the room its wizard stands in,
## everything visible there, and the wizard's own status.
##
## It travels as a plain array, and [method from_message] checks every element's type
## before using it, so a malformed message is dropped rather than half-read.

const _FIELD_TYPES: Array[int] = [
	TYPE_INT, # tick
	TYPE_STRING_NAME, # room_id
	TYPE_INT, # acknowledged
	TYPE_PACKED_INT32_ARRAY, # wizard_ids
	TYPE_PACKED_VECTOR2_ARRAY, # wizard_positions
	TYPE_PACKED_VECTOR2_ARRAY, # dummy_positions
	TYPE_PACKED_INT32_ARRAY, # dummy_health
	TYPE_PACKED_INT32_ARRAY, # dummy_max_health
	TYPE_PACKED_VECTOR2_ARRAY, # projectile_positions
	TYPE_PACKED_INT32_ARRAY, # projectile_spells
	TYPE_PACKED_VECTOR2_ARRAY, # village_positions
	TYPE_PACKED_INT32_ARRAY, # village_owners
	TYPE_PACKED_INT32_ARRAY, # the player's own numbers, in the order of _STATUS_SIZE's comment
	TYPE_PACKED_INT32_ARRAY, # cooldowns
]
## health, max_health, mana, mana_pool, wizard_level, xp, xp_to_next, gold, village_price,
## villages_held, grimoire_positions.
const _STATUS_SIZE := 11

var tick := 0
var room_id: StringName
## The sequence number of the last movement input the server applied for this client.
var acknowledged := 0
var wizard_ids: PackedInt32Array = []
var wizard_positions: PackedVector2Array = []
var dummy_positions: PackedVector2Array = []
## 0 for a destroyed dummy.
var dummy_health: PackedInt32Array = []
var dummy_max_health: PackedInt32Array = []
var projectile_positions: PackedVector2Array = []
## The Grimoire position each projectile was cast from.
var projectile_spells: PackedInt32Array = []
## The villages of the room, in the room's order.
var village_positions: PackedVector2Array = []
## The peer id holding each village; 0 for none.
var village_owners: PackedInt32Array = []
var health := 0
var max_health := 0
var mana := 0
var mana_pool := 0
var wizard_level := 1
var xp := 0
var xp_to_next := 0
var gold := 0
## What the next village would cost this wizard.
var village_price := 0
var villages_held := 0
## How many Grimoire positions the wizard may cast from.
var grimoire_positions := 0
## For each Grimoire position, index 0 for position 1: ticks before it may cast again.
var cooldowns: PackedInt32Array = []


## Reads a message; null when it is malformed.
static func from_message(message: Array) -> StateUpdate:
	if message.size() != _FIELD_TYPES.size():
		return null
	for i in message.size():
		if typeof(message[i]) != _FIELD_TYPES[i]:
			return null
	var status: PackedInt32Array = message[12]
	if status.size() != _STATUS_SIZE:
		return null
	var update := StateUpdate.new()
	update.tick = message[0]
	update.room_id = message[1]
	update.acknowledged = message[2]
	update.wizard_ids = message[3]
	update.wizard_positions = message[4]
	update.dummy_positions = message[5]
	update.dummy_health = message[6]
	update.dummy_max_health = message[7]
	update.projectile_positions = message[8]
	update.projectile_spells = message[9]
	update.village_positions = message[10]
	update.village_owners = message[11]
	update.cooldowns = message[13]
	update.health = status[0]
	update.max_health = status[1]
	update.mana = status[2]
	update.mana_pool = status[3]
	update.wizard_level = status[4]
	update.xp = status[5]
	update.xp_to_next = status[6]
	update.gold = status[7]
	update.village_price = status[8]
	update.villages_held = status[9]
	update.grimoire_positions = status[10]
	var sizes_match := (
		update.wizard_ids.size() == update.wizard_positions.size()
		and update.dummy_positions.size() == update.dummy_health.size()
		and update.dummy_health.size() == update.dummy_max_health.size()
		and update.village_positions.size() == update.village_owners.size()
		and update.projectile_positions.size() == update.projectile_spells.size()
		and update.cooldowns.size() <= Grimoire.MAX_POSITIONS
	)
	return update if sizes_match else null


func to_message() -> Array:
	return [
		tick,
		room_id,
		acknowledged,
		wizard_ids,
		wizard_positions,
		dummy_positions,
		dummy_health,
		dummy_max_health,
		projectile_positions,
		projectile_spells,
		village_positions,
		village_owners,
		PackedInt32Array(
			[
				health,
				max_health,
				mana,
				mana_pool,
				wizard_level,
				xp,
				xp_to_next,
				gold,
				village_price,
				villages_held,
				grimoire_positions,
			],
		),
		cooldowns,
	]
