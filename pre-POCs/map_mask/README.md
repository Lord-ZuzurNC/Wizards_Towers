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

1. The plains around the Monolith, at the exact centre.
2. The coast, a band along one map edge with noise-bent depth and tapered ends.
3. The mountain chain, a random walk steered away from the centre and from every edge but the one it may start from, with its spine marked impassable.
4. The volcanic ground: a round volcano, a winding rift, or both.
5. Plains, forest, marsh, glacier and desert share the rest as zones around seed points, with borders bent by two scales of noise; forest and glacier are refused near volcanic ground.
6. Stray fragments join the zone around them, so each biome is one zone.
7. Every rule is checked, including that all walkable ground is reachable from the Monolith; a mask breaking one is thrown away and the next seed is tried.
8. Half the time, Frostfang Caverns is assumed drawn: an island off the coast, or a lake with an island inside the glacier.

## Results

Measured on 2026-11-07 with Godot 4.7.2 headless; `results/sheet.png` holds the ten masks, `results/run.log` the output.

| Measure                     | Result                                                       |
| --------------------------- | ------------------------------------------------------------ |
| Valid masks                 | 10 of 10                                                     |
| Masks generated to get them | 43, so about 4 per valid mask                                |
| Most common rejection       | Plains split in two by the mountain chain, 20 times          |
| Time for the whole run      | About 3 s                                                    |
| Same seeds run twice        | Identical images                                             |
| Plains share                | 26 % to 54 %; the largest zone every time                    |
| Frostfang                   | 3 islands off the coast, 2 lakes in the glacier, 5 not drawn |

The mask colours follow `docs/WORLD_MAP.md`; the dark grey line in each mountain chain is its spine, light blue is a Frostfang lake, sand is a Frostfang island, and the black dot and ring are the Monolith and its Outer Ring.

## Conclusions

The rules are cheap to satisfy by generating and checking: a valid mask costs a fraction of a second.
Generation is deterministic for a given seed, so a world can be rebuilt from its seed alone.
Only the mask is covered here; the terrain pass, decor included, is the next step.

## Run it

```bash
/path/to/Godot_v4.7.2-stable_linux.x86_64 --headless --script mask.gd -- <output_dir> [first_seed] [count]
```
