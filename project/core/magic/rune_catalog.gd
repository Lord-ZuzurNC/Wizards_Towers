class_name RuneCatalog
extends RefCounted
## Every rune of the game, authored from the tables of RUNES.md, by id.
##
## Values are the common-rarity ones; see [Rune]. Built once, the first time the class
## is used, and never changed afterwards.

static var _runes: Dictionary[StringName, Rune] = { }


static func _static_init() -> void:
	_shape(&"bolt", 1, Rune.Reach.RANGED)
	_shape(&"lance", 2, Rune.Reach.RANGED)
	_shape(&"spray", 2, Rune.Reach.MELEE)
	_shape(&"slash", 2, Rune.Reach.MELEE)
	_shape(&"beam", 3, Rune.Reach.RANGED)
	_shape(&"nova", 3, Rune.Reach.SELF)
	_shape(&"orb", 3, Rune.Reach.RANGED)
	_shape(&"seed", 3, Rune.Reach.PLACED)
	_shape(&"footprints", 3, Rune.Reach.SELF)
	_shape(&"boulder", 3, Rune.Reach.RANGED)
	_shape(&"trident", 3, Rune.Reach.RANGED)
	_shape(&"pool", 3, Rune.Reach.PLACED)
	_shape(&"rain", 4, Rune.Reach.PLACED)
	_shape(&"wall", 4, Rune.Reach.PLACED)
	_shape(&"aura", 4, Rune.Reach.SELF)
	_shape(&"tether", 4, Rune.Reach.RANGED)
	_shape(&"satellite", 4, Rune.Reach.SELF)
	_shape(&"swarm", 5, Rune.Reach.RANGED)
	_shape(&"vortex", 5, Rune.Reach.PLACED)
	_shape(&"judgement", 6, Rune.Reach.PLACED)
	_shape(&"bombardment", 6, Rune.Reach.PLACED)

	_element(&"ember", 2, 12)
	_element(&"rime", 2, 12)
	_element(&"spark", 2, 12)
	_element(&"gale", 2, 12)
	_element(&"stone", 3, 16)
	_element(&"verdure", 3, 16)
	_element(&"brine", 3, 16)
	_element(&"gloom", 3, 16)
	_element(&"toxin", 3, 16)
	_element(&"radiance", 4, 20)
	_element(&"ichor", 4, 20)
	_element(&"null", 5, 24)
	_element(&"unmaking", 5, 24)
	_element(&"rust", 5, 24)

	_add(&"instant", RuneAttribute.DURATION, 1)
	_add(&"brief", RuneAttribute.DURATION, 2)
	_add(&"delayed", RuneAttribute.DURATION, 2)
	_add(&"sustained", RuneAttribute.DURATION, 3)
	_add(&"lingering", RuneAttribute.DURATION, 3)
	_add(&"echoing", RuneAttribute.DURATION, 4)
	_add(&"eternal", RuneAttribute.DURATION, 5)

	_add(&"pierce", RuneAttribute.EFFECT, 2)
	_add(&"knockback", RuneAttribute.EFFECT, 2)
	_add(&"pull", RuneAttribute.EFFECT, 2)
	_add(&"slow", RuneAttribute.EFFECT, 2)
	_add(&"anchor", RuneAttribute.EFFECT, 2)
	_add(&"humility", RuneAttribute.EFFECT, 2)
	_add(&"covet", RuneAttribute.EFFECT, 2)
	_add(&"reverence", RuneAttribute.EFFECT, 2)
	_add(&"chain", RuneAttribute.EFFECT, 3)
	_add(&"split", RuneAttribute.EFFECT, 3)
	_add(&"bounce", RuneAttribute.EFFECT, 3)
	_add(&"seek", RuneAttribute.EFFECT, 3)
	_add(&"root", RuneAttribute.EFFECT, 3)
	_add(&"blind", RuneAttribute.EFFECT, 3)
	_add(&"mend", RuneAttribute.EFFECT, 3)
	_add(&"ward", RuneAttribute.EFFECT, 3)
	_add(&"haste", RuneAttribute.EFFECT, 3)
	_add(&"mark", RuneAttribute.EFFECT, 3)
	_add(&"waning", RuneAttribute.EFFECT, 3)
	_add(&"sacrifice", RuneAttribute.EFFECT, 3)
	_add(&"greed", RuneAttribute.EFFECT, 3)
	_add(&"patience", RuneAttribute.EFFECT, 3)
	_add(&"spite", RuneAttribute.EFFECT, 3)
	_add(&"mute", RuneAttribute.EFFECT, 4)
	_add(&"drain", RuneAttribute.EFFECT, 4)
	_add(&"leech", RuneAttribute.EFFECT, 4)
	_add(&"detonate", RuneAttribute.EFFECT, 4)
	_add(&"fracture", RuneAttribute.EFFECT, 4)
	_add(&"reprise", RuneAttribute.EFFECT, 4)
	_add(&"growth", RuneAttribute.EFFECT, 4)
	_add(&"toll", RuneAttribute.EFFECT, 4)
	_add(&"kindle", RuneAttribute.EFFECT, 4)
	_add(&"unbinding", RuneAttribute.EFFECT, 4)
	_add(&"siphon", RuneAttribute.EFFECT, 5)
	_add(&"hunger", RuneAttribute.EFFECT, 5)


## The rune named [param rune_id], or [code]null[/code] when no rune has that id.
static func find(rune_id: StringName) -> Rune:
	return _runes.get(rune_id)


## The ids of every rune of [param attribute], a [RuneAttribute] value, in RUNES.md order.
static func ids_of(attribute: int) -> Array[StringName]:
	var ids: Array[StringName] = []
	for rune: Rune in _runes.values():
		if rune.attribute == attribute:
			ids.append(rune.id)
	return ids


static func _shape(rune_id: StringName, weight: int, reach: Rune.Reach) -> void:
	_runes[rune_id] = Rune.new(rune_id, RuneAttribute.SHAPE, weight, 0, reach)


static func _element(rune_id: StringName, weight: int, magnitude: int) -> void:
	_runes[rune_id] = Rune.new(rune_id, RuneAttribute.ELEMENT, weight, magnitude)


static func _add(rune_id: StringName, attribute: int, weight: int) -> void:
	_runes[rune_id] = Rune.new(rune_id, attribute, weight)
