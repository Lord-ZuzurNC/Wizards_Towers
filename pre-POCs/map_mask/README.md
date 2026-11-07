# Pre-POC — Map mask

- [Pre-POC — Map mask](#pre-poc--map-mask)
  - [Question](#question)
  - [Method](#method)
  - [Results](#results)
  - [Conclusions](#conclusions)
  - [Run it](#run-it)

## Question

Can Godot generate, with nothing but its own `FastNoiseLite`, a random biome mask that follows every rule of `docs/WORLD_MAP.md` and still looks organic?

## Method

`mask.gd` builds a 256 × 256 mask in this order, each step writing only where nothing stands yet:

1. The plains around the Monolith, placed at random within 10 % of the centre on each axis, wide enough to hold its Outer Ring.
2. The coast, a band along one map edge with noise-bent depth and tapered ends.
3. The mountain chain, a random walk steered away from the centre and from every edge but the one it may start from, with its spine marked impassable.
4. The volcanic ground: a round volcano, a winding rift, or both.
5. Plains, forest, marsh, glacier and desert share the rest as zones around one seed point each, the plains seed being the Monolith, with borders bent by two scales of noise; forest and glacier are refused near volcanic ground.
6. Stray fragments join the zone around them, so each biome is one zone; plains pieces separated only by the mountain chain are kept.
7. Every rule is checked, including that all walkable ground is reachable from the Monolith; a mask breaking one is thrown away and the next seed is tried.
8. Half the time, Frostfang Caverns is assumed drawn: an island off the coast, or a lake with an island inside the glacier.

## Results

Measured on 2026-11-07 with Godot 4.7.2 headless, after the second set of rules; `results/sheet.png` holds the ten masks, `results/run.txt` the output.

| Measure                     | Result                                                                  |
| --------------------------- | ----------------------------------------------------------------------- |
| Valid masks                 | 10 of 10                                                                |
| Masks generated to get them | 42, so about 4 per valid mask                                           |
| Rejections                  | spread over every rule; the most common, a desert split in two, 6 times |
| Time for the whole run      | About 3 s                                                               |
| Same seeds run twice        | Identical images                                                        |
| Plains share                | 50 % to 56 %; the largest zone every time                               |
| Plains cut by the chain     | 4 masks of 10, into 2 or 3 pieces, all walkable from one another        |
| Monolith position           | 41 % to 60 % of the width, 41 % to 56 % of the height                   |
| Frostfang                   | 2 islands off the coast, 3 lakes in the glacier, 5 not drawn            |

The mask colours follow `docs/WORLD_MAP.md`; the dark grey line in each mountain chain is its spine, light blue is a Frostfang lake, sand is a Frostfang island, and the black dot and ring are the Monolith and its Outer Ring.

## Conclusions

The rules are cheap to satisfy by generating and checking: a valid mask costs a fraction of a second.
Generation is deterministic for a given seed, so a world can be rebuilt from its seed alone.
Only the mask is covered here; the terrain pass, decor included, is the next step.
Some masks leave a zone as a thin strip between two others; a minimum zone width is the next rule to add.

## Run it

```bash
/path/to/Godot_v4.7.2-stable_linux.x86_64 --headless --script mask.gd -- <output_dir> [first_seed] [count]
```
