# Pre-POC: terrain from a mask

## Question

Can a biome mask be turned into terrain of 16-pixel tiles that reads well at the native resolution, in the BLK NX64 palette, with light held to the palette?

## Method

`terrain.gd` reads one mask from a `pre-POCs/map_mask` sheet and draws views of 640 × 360 pixels, the native resolution of `docs/ART_DIRECTION.md`:

1. Each mask point covers 10 × 10 tiles, as in `docs/WORLD_MAP.md`.
2. Borders between biomes are bent by noise at the scale of a few tiles, then settled on 4-pixel steps, roughly what a set of transition tiles would give.
3. A biome lying over a lower layer gets a coloured outline, a darker shade of its own ground.
4. Ground and decor are placeholders drawn by code from BLK NX64 colours only; decor stands on tiles lying wholly in one biome, drawn from the back to the front, each sprite with a coloured outline and a ground shadow.
5. A wizard 30 pixels tall and a world boss 58 pixels tall stand in the first view for scale.
6. The same view is drawn again at night: darkness and the light of the wizard's staff are computed, then every pixel is snapped to the nearest BLK NX64 colour, light falling in steps blended by an ordered dither.
7. Every pixel of every image is checked against the palette.

## Run it

```sh
godot --headless --script terrain.gd -- ../map_mask/results/<sheet>.png <mask number 1-10> results
```

With `full [step]` after the output folder, the whole map is drawn instead, keeping one world pixel out of every `step` on each axis, sprites shrunk the same way, with a black marker where the Monolith stands:

```sh
godot --headless --script terrain.gd -- ../map_mask/results/<sheet>.png 3 results full 8
```

Otherwise, each run writes `views_<date-time>.png`, the views at ×2, `day_1080p_<date-time>.png` and `night_1080p_<date-time>.png`, the first view at ×3, and `run_<date-time>.txt`.

## Results

Run on mask 1 of `sheet_2026-11-07-22-57-23.png`, with Godot 4.7.2 headless:

| Measure                 | Result                                                                                        |
| ----------------------- | --------------------------------------------------------------------------------------------- |
| Views                   | 7: plains and forest, forest and marsh, glacier, desert, mountain spine, volcanic rift, coast |
| Pixels outside BLK NX64 | 0, day and night                                                                              |
| Time for the whole run  | About 6 s                                                                                     |
| Tiles on screen         | 40 × 22.5                                                                                     |

Whole map, mask 3 of the same sheet:

| Measure                 | 1/16                          | 1/8               |
| ----------------------- | ----------------------------- | ----------------- |
| Image                   | 2560 × 2560, one pixel a tile | 5120 × 5120       |
| Decor sprites placed    | About 2.8 million             | About 2.8 million |
| Pixels outside BLK NX64 | 0                             | 0                 |
| Time                    | 24 s                          | 65 s              |
| PNG                     | 2.8 MB                        | 11.1 MB           |

At full scale the map is 40,960 pixels a side, about 7,300 screens of 640 × 360: too large for one image, hence the reduced versions.
Shrinking by keeping one pixel out of 8 or 16 creates a fine moiré on textured ground and turns sprites into specks; neither happens in the game, which is drawn at full scale.

## Conclusions

At 16-pixel tiles, a 24 to 32 pixel character and a 48 to 64 pixel boss read clearly at 640 × 360.
BLK NX64 is enough to tell the eight biomes apart, and light held to the palette reads as night, with visible steps around the light.
The art itself proves nothing: every tile and sprite is a placeholder, and the borders still show their 4-pixel steps; real transition tiles and real art are for the artists.
