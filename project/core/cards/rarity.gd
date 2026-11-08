class_name Rarity
extends RefCounted
## The grade shared by runes, weapons and cards: one scale, no separate ladders.

enum {
	COMMON,
	RARE,
	LEGENDARY,
}

## On-screen colour of each grade, from BLK NX64: grey-blue, blue, gold.
const COLORS: Array[Color] = [Color("909edd"), Color("3e83d1"), Color("ffe091")]
const NAMES: Array[String] = ["common", "rare", "legendary"]


static func color(grade: int) -> Color:
	return COLORS[clampi(grade, COMMON, LEGENDARY)]


static func label(grade: int) -> String:
	return NAMES[clampi(grade, COMMON, LEGENDARY)]
