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

`mask.gd` builds a 256 × 256 mask, laying the layers of `docs/WORLD_MAP.md` from the bottom up:

1. The Monolith, placed at random within 10 % of the centre on each axis, with plains wide enough to hold its Outer Ring; no later layer may cover the ring.
2. The coast, the sea along one map edge, with noise-bent depth and tapered ends.
3. Plains, forest, marsh, glacier and desert share the rest as zones around one seed point each, the plains seed being the Monolith, with borders bent by two scales of noise; stray fragments join the zone around them.
4. Any part of a zone narrower than 8 mask points joins the zones beside it.
5. The mountain chain over them, a random walk steered away from the Monolith and from every edge but the one it may start from, its spine marked impassable; it may run out over the sea.
6. The volcanic ground over everything: a round volcano, a winding rift, or both, placed and steered away from forest and glacier, never filled in with a strip of another biome; narrow parts left by these two layers are thinned out again.
7. Every rule is checked, including that all ground is reachable on foot from the Monolith, the sea and the spine being the only obstacles; a mask breaking one is thrown away and the next seed is tried.
8. Half the time, Frostfang Caverns is assumed drawn: an island off the coast, or a lake with an island inside the glacier.

## Results

Each run writes `results/sheet_<date-time>.png` and `results/run_<date-time>.txt`, so earlier results are never overwritten.

| Run                 | Rules                                                                               |
| ------------------- | ----------------------------------------------------------------------------------- |
| 2026-11-07 18:04:37 | First pass: Monolith at the exact centre, the volcano drawn before the zones.       |
| 2026-11-07 18:36:59 | Monolith within 10 % of the centre, plains allowed to be cut by the chain.          |
| 2026-11-07 20:15:46 | Layers, the sea not walkable, volcanic ground steered away from forest and glacier. |
| 2026-11-07 22:57:23 | Minimum zone width of 8 mask points.                                                |

The second run had two faults: plains cut off with only the sea beyond them, and thin strips of plains painted between forest and volcanic ground.
Both are fixed in the third.

Third run, measured with Godot 4.7.2 headless:

| Measure                                                                       | Result                                                       |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------ |
| Valid masks                                                                   | 10 of 10                                                     |
| Masks generated to get them                                                   | 34                                                           |
| Rejected for unreachable ground                                               | 4                                                            |
| Time for the whole run                                                        | About 8 s                                                    |
| Same seeds run twice                                                          | Identical images                                             |
| Plains share                                                                  | 43 % to 60 %; the largest zone every time                    |
| Plains cut in pieces                                                          | 6 masks of 10, every piece reachable on foot                 |
| Forest or glacier touching volcanic ground, counted on the pixels             | 0                                                            |
| A thin plains strip between forest and volcanic ground, counted on the pixels | 0                                                            |
| A rift cutting through the chain                                              | 3 masks                                                      |
| The chain running out over the sea                                            | 2 masks                                                      |
| Frostfang                                                                     | 3 islands off the coast, 2 lakes in the glacier, 5 not drawn |

The mask colours follow `docs/WORLD_MAP.md`; the dark grey line in each mountain chain is its spine, light blue is a Frostfang lake, sand is a Frostfang island, and the black dot and ring are the Monolith and its Outer Ring.

## Conclusions

The rules are cheap to satisfy by generating and checking: a valid mask costs under a second.
Generation is deterministic for a given seed, so a world can be rebuilt from its seed alone.
Only the mask is covered here; the terrain pass, decor included, is the next step.
The fourth run adds a minimum zone width.
Counted on the pixels, as zone parts more than 4 points away from any part at least 8 points wide, 40 pixels or more in size: 4 such strips in the third run, 1 in the fourth, a desert sliver touching only volcanic ground, which the rule keeps on purpose.
The run takes about 21 s instead of 8 s; every other rule check still passes, and forest or glacier touching volcanic ground stays at 0.

## Run it

```bash
/path/to/Godot_v4.7.2-stable_linux.x86_64 --headless --script mask.gd -- <output_dir> [first_seed] [count]
```
