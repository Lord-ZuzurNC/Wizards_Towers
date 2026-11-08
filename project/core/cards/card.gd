class_name Card
extends Resource
## One card a wizard can take at a level-up. See CARDS.md.

enum Family {
	STAT,
	MANA,
	RUNE,
	WEAPON,
	SPECIAL,
}

## Unique across all cards; this is what travels over the network.
@export var id: StringName
@export var title := ""
@export var family := Family.STAT
## A [Rarity] grade.
@export_enum("common", "rare", "legendary") var rarity := 0
## What the card does once taken. Empty for the test cards, which do nothing.
@export_multiline var text := ""
