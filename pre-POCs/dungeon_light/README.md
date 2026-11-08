# Pre-POC: a dungeon room in the dark

## Question

Which palette keeps a dark dungeon readable when light is held to the palette: BLK NX64, APOLLO, or BLK NX64 reinforced with APOLLO's darkest tones?

## Method

`dungeon.gd` draws one room of 40 × 20 tiles, with a HUD below it filling the 640 × 360 screen:

1. The room is drawn in BLK NX64: flagstones, a brick back wall in three-quarter view, four pillars, a chest, bones, three enemies and a wizard; every shape is a placeholder drawn by code.
2. The lights: two torches on the back wall, a brazier, and the wizard's staff, over an ambient light of 7 %.
3. Light falls in eighths blended by an ordered dither, then every pixel is snapped to the nearest colour of the palette under test, measured in CIELAB so dark tones match as the eye sees them.
4. Flames, eyes, the staff's gem and the HUD give their own light and are never darkened.
5. Four versions: the room fully lit; dark in BLK NX64; dark in APOLLO, the room's colours first replaced by their nearest APOLLO colour; dark in BLK NX64 plus every APOLLO colour of lightness 30 or less, out of 100.

## Run it

```sh
godot --headless --script dungeon.gd -- results
```

Each run writes `rooms_<date-time>.png`, the four versions at ×2, `room1_1080p_<date-time>.png` to `room4_…`, each at ×3, and `run_<date-time>.txt`.

## Results

Run with Godot 4.7.2 headless, in about 3 s:

| Version | Palette                                | Pixels outside it | Colours in the dim parts of the room | Colours darker than lightness 15 |
| ------- | -------------------------------------- | ----------------- | ------------------------------------ | -------------------------------- |
| Lit     | BLK NX64, 64 colours                   | 0                 | 17                                   | 2                                |
| Dark    | BLK NX64, 64 colours                   | 0                 | 6                                    | 3                                |
| Dark    | APOLLO, 46 colours                     | 0                 | 8                                    | 7                                |
| Dark    | BLK NX64 + 15 APOLLO darks, 79 colours | 0                 | 14                                   | 10                               |

The dim parts are those farther than 60 % of every light's reach.

## Conclusions

BLK NX64 alone runs out of dark tones: away from the lights, floor, walls and pillars fall to a few blues and black.
APOLLO alone keeps a little more, but it shifts the room's colours, since the room is authored in BLK NX64.
BLK NX64 reinforced with APOLLO's 15 darkest colours keeps more than twice the shading of BLK NX64 alone in the dim parts, and the room's colours where the light falls.

One room authored in BLK NX64 does not settle it for good: the ambient light chosen, and art drawn directly in APOLLO, would move these figures.
