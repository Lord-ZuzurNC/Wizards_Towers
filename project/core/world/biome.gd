class_name Biome
extends RefCounted
## The eight zones of a world map, and the features that change how their ground walks.
## See GLOSSARY.md, World map, and WORLD_MAP.md.

enum Kind {
	PLAINS,
	FOREST,
	MARSH,
	GLACIER,
	DESERT,
	MOUNTAIN,
	VOLCANIC,
	COAST,
}

## What stands on a tile besides its biome. Only plain ground and a rift bank are walkable.
## Water is the sea, or the glacier's lake; it freezes in winter, which comes with seasons.
enum Feature {
	GROUND,
	SPINE,
	CRATER,
	RIFT_CORE,
	RIFT_BANK,
	WATER,
}

const NAMES: Array[String] = [
	"Plains",
	"Forest",
	"Marsh",
	"Glacier",
	"Desert",
	"Mountain",
	"Volcanic",
	"Coast",
]


## [param kind] is a [enum Kind].
static func label(kind: int) -> String:
	return NAMES[kind]


## Whether a wizard may stand on [param feature]. Seasons will make water walkable in winter.
## [param feature] is a [enum Feature].
static func is_walkable(feature: int) -> bool:
	return feature == Feature.GROUND or feature == Feature.RIFT_BANK
