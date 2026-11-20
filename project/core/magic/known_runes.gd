class_name KnownRunes
extends RefCounted
## The runes one wizard may use in a spell (GLOSSARY.md, known rune): found or bought at
## least once this run, kept at the best [Rarity] grade found. No slot, no count, no cap.

var _best_grade: Dictionary[StringName, int] = { }


## PLACEHOLDER (GLOSSARY.md, known rune, Milestone 1): every rune known at common rarity,
## since nothing in the game grants one yet — no loot, no NPC shop, no quest reward. Rare
## and legendary stay locked behind that acquisition system once it exists.
static func starter() -> KnownRunes:
	var known := KnownRunes.new()
	for rune_id in RuneCatalog.ids_of(RuneAttribute.SHAPE) \
			+ RuneCatalog.ids_of(RuneAttribute.ELEMENT) \
			+ RuneCatalog.ids_of(RuneAttribute.DURATION) \
			+ RuneCatalog.ids_of(RuneAttribute.EFFECT):
		known.learn(rune_id, Rarity.COMMON)
	return known


## Raises [param rune_id]'s known grade to [param grade] if that is higher than before.
func learn(rune_id: StringName, grade: int) -> void:
	_best_grade[rune_id] = maxi(best_grade(rune_id), grade)


## The best [Rarity] grade [param rune_id] is known at; -1 when it is not known at all.
func best_grade(rune_id: StringName) -> int:
	if not _best_grade.has(rune_id):
		return -1
	return _best_grade[rune_id]


## Whether [param rune_id] is known at [param grade] or better.
func knows(rune_id: StringName, grade: int) -> bool:
	return best_grade(rune_id) >= grade
