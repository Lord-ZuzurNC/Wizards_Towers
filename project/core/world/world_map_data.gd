class_name WorldMapData
extends RoomData
## A world map: a room larger than the screen, whose tiles each belong to a [Biome], and
## where only some features block movement (WORLD_MAP.md, Biomes).
##
## Like a room, it is written as text, one character per tile:
## [codeblock lang=text]
## .  plains        f  forest       m  marsh        g  glacier
## d  desert        h  mountain     v  volcanic     ~  sea (coast)
## ^  spine         o  crater       x  rift core    r  rift bank
## =  the glacier's lake
## [/codeblock]
## Blocked: the sea, the lake, a spine, a crater and a rift core; in winter the sea and the
## lake freeze and can be walked on. The world sets [member season] as the run goes on.
## The real map, 2 560 tiles a side, will be generated from a mask; this one is written by
## hand to try walking across biomes.

## The biome and the feature of each character.
const LEGEND: Dictionary[String, Vector2i] = {
	".": Vector2i(Biome.Kind.PLAINS, Biome.Feature.GROUND),
	"f": Vector2i(Biome.Kind.FOREST, Biome.Feature.GROUND),
	"m": Vector2i(Biome.Kind.MARSH, Biome.Feature.GROUND),
	"g": Vector2i(Biome.Kind.GLACIER, Biome.Feature.GROUND),
	"d": Vector2i(Biome.Kind.DESERT, Biome.Feature.GROUND),
	"h": Vector2i(Biome.Kind.MOUNTAIN, Biome.Feature.GROUND),
	"v": Vector2i(Biome.Kind.VOLCANIC, Biome.Feature.GROUND),
	"~": Vector2i(Biome.Kind.COAST, Biome.Feature.WATER),
	"^": Vector2i(Biome.Kind.MOUNTAIN, Biome.Feature.SPINE),
	"o": Vector2i(Biome.Kind.VOLCANIC, Biome.Feature.CRATER),
	"x": Vector2i(Biome.Kind.VOLCANIC, Biome.Feature.RIFT_CORE),
	"r": Vector2i(Biome.Kind.VOLCANIC, Biome.Feature.RIFT_BANK),
	"=": Vector2i(Biome.Kind.GLACIER, Biome.Feature.WATER),
}
## WORLD_MAP.md, Scale: 2 560 tiles a side.
const MAP_MAX_SIZE := Vector2i(2560, 2560)

## The season the map is in, a [enum Season.Kind]. Set by the world, never saved.
var season := Season.Kind.SPRING as int


func is_solid(tile: Vector2i) -> bool:
	if tile.y < 0 or tile.y >= rows.size() or tile.x < 0 or tile.x >= rows[tile.y].length():
		return true
	var entry: Vector2i = LEGEND.get(rows[tile.y][tile.x], Vector2i(-1, -1))
	if entry.x < 0:
		return true
	if entry.y == Biome.Feature.WATER and season == Season.Kind.WINTER:
		return false
	return not Biome.is_walkable(entry.y)


## Whether [param tile] is frozen water: the sea or the lake, in winter.
func is_frozen_water(tile: Vector2i) -> bool:
	return season == Season.Kind.WINTER and feature_at(tile) == Biome.Feature.WATER


## The hazard of [param tile] in the current season: Ember on a rift bank in summer, Rime on
## the glacier in winter, its frozen lake included. Frozen sea is harmless.
func hazard_at(tile: Vector2i) -> Hazard.Kind:
	if season == Season.Kind.SUMMER and feature_at(tile) == Biome.Feature.RIFT_BANK:
		return Hazard.Kind.EMBER
	if season == Season.Kind.WINTER and biome_at(tile) == Biome.Kind.GLACIER:
		return Hazard.Kind.RIME
	return Hazard.Kind.NONE


## The biome of [param tile]; -1 outside the map.
func biome_at(tile: Vector2i) -> int:
	return _entry(tile).x


## The feature of [param tile]; -1 outside the map.
func feature_at(tile: Vector2i) -> int:
	return _entry(tile).y


func _entry(tile: Vector2i) -> Vector2i:
	if tile.y < 0 or tile.y >= rows.size() or tile.x < 0 or tile.x >= rows[tile.y].length():
		return Vector2i(-1, -1)
	return LEGEND.get(rows[tile.y][tile.x], Vector2i(-1, -1))


func _is_legal(character: String) -> bool:
	return LEGEND.has(character)


func _max_size() -> Vector2i:
	return MAP_MAX_SIZE
