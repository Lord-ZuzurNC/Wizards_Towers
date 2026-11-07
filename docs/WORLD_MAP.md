# World map — Wizards Towers

How a world's map is laid out: a **mask** of biomes first, then the terrain generated from it.

- [World map — Wizards Towers](#world-map--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [The mask](#the-mask)
  - [Scale](#scale)
  - [Biomes](#biomes)
  - [Placement](#placement)
  - [The Frostfang exception](#the-frostfang-exception)
  - [Open questions](#open-questions)

## How to read this document

A world's map is made in two passes.
The **mask** is a coarse picture where every point belongs to one biome; the **terrain** is the playable map, generated from the mask with noise.
The mask can be painted by hand or generated at random; both go through the same terrain pass.

The rules below are checked on every generated mask, and a mask breaking one is thrown away and generated again.
A first pre-POC generating masks is in `pre-POCs/map_mask/`.

## The mask

**Each biome appears exactly once**, as a single zone.
One exception: the mountain chain may cut the plains in pieces, as long as the pieces are walkable from one another through the other zones.

**The Monolith stands near the centre**, anywhere within 10 % of it on each axis, in the plains.
Its Outer Ring stands entirely in the plains too.

**Players see the mask before they see the world.**
The queue screen shows a far minimap of the world; that minimap is the mask, so players know the shape of the land while they wait, and discover the real terrain once inside.

Borders between zones are bent by noise, so no zone has a straight edge.

## Scale

Provisional, until the art style fixes the size of a tile in pixels.

| Measure                  | Value                                               |
| ------------------------ | --------------------------------------------------- |
| Normal walk, `speed` 100 | 4 tiles a second                                    |
| Map side                 | 2 560 tiles, about 10 minutes 40 seconds of walking |
| Map corner to corner     | about 15 minutes                                    |
| Mask                     | 256 × 256 points, each covering 10 × 10 tiles       |
| Streaming chunk          | 64 × 64 tiles, so 40 × 40 chunks for the whole map  |

The ten-minute width is the one settled in the design questions, sized for fifty wizards.
Four tiles a second is a usual walk in top-down pixel-art games, quick enough that a 10 to 20 second fight can move around.
At 16 pixels a tile, `speed` 100 is 64 pixels a second and the map is 40 960 pixels wide.

## Biomes

| Biome    | Mask colour | Rule                                                                                                          |
| -------- | ----------- | ------------------------------------------------------------------------------------------------------------- |
| Plains   | yellow      | The largest zone, and the one holding the Monolith; the only one the mountain chain may cut.                  |
| Forest   | green       | Always borders the plains. Never touches volcanic ground.                                                     |
| Marsh    | brown       | Always borders the forest.                                                                                    |
| Glacier  | white       | Never touches volcanic ground.                                                                                |
| Desert   | orange      | Its decor borrows from its neighbours, dried out: dead trees beside the forest, cracked mud beside the marsh. |
| Mountain | mid grey    | A long chain that touches at most one map edge; its central spine cannot be crossed.                          |
| Volcanic | red         | A round volcano, a winding rift, or both.                                                                     |
| Coast    | blue        | Always on a map edge.                                                                                         |

**Everything walkable is reachable from the Monolith.**
Only a mountain spine blocks movement, and since a chain touches at most one edge, there is always a way around it.

## Placement

**Everything stands where its theme belongs.**
A dungeon's entrance is placed in the zone matching its theme, a world boss stands in its own territory, and villages favour the plains.

| Biome    | Holds, among others                                                                 |
| -------- | ----------------------------------------------------------------------------------- |
| Plains   | Villages, the Harrow, the Tallyman's trade roads, The Mudlark Sewers, The Millrace  |
| Forest   | The Umbral Wood, the Rift Glade, fae groves, beast warrens, The Thawroot Burrow     |
| Marsh    | The Deep Fen, the Sunken Mire, Mournwillow Fen, The Silt Cisterns                   |
| Glacier  | The Frozen Choir, Frostfang Caverns, The Meltwater Grotto                           |
| Desert   | Sunfall Mesa, Suncoil Ruins                                                         |
| Mountain | The Shattered Crag, Skyreach Spire, the mines, The Clockwork Vault, Redtusk Warcamp |
| Volcanic | The Deep Rift, Cinder Rift, Cindermaw Forge, The Void Scar                          |
| Coast    | The Sunken Abbey                                                                    |

## The Frostfang exception

When Frostfang Caverns is drawn, the map makes room for it.
Either a small island appears off the coast, or a lake appears inside the glacier with an island in its middle.
The dungeon's entrance stands on that island, and the way to it freezes over in winter, opening the passage.

## Open questions

- ⬜ **The size of a tile in pixels**, fixed with the art style.
- ⬜ **A minimum width for every zone**, so no biome ends up as a thin strip between two others.
- ⬜ **The theme of every dungeon and world boss**, assigned to a biome; the table above is a first pass.
- ⬜ **Hand-painted masks**: whether some worlds use a curated mask instead of a generated one.
