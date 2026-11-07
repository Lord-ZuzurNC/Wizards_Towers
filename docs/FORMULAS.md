# Formulas — Wizards Towers

Every number the game computes rather than authors lives here, written once.
Other documents state the rule in words and point here for the arithmetic.

- [Formulas — Wizards Towers](#formulas--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [World and Monolith](#world-and-monolith)
  - [Wizard progression](#wizard-progression)
  - [Combat](#combat)
  - [Magic](#magic)
  - [Enemies](#enemies)
  - [World bosses](#world-bosses)
  - [Dungeons](#dungeons)
  - [Economy](#economy)
  - [Flags](#flags)
  - [Score and reincarnation points](#score-and-reincarnation-points)
  - [Endings](#endings)
  - [Missing formulas](#missing-formulas)

## How to read this document

Each formula gives its inputs, its result, and the document holding the rule it serves.
Names in `code` are the identifiers from `GLOSSARY.md`.
A ⬜ marks a formula the design needs but nobody has written yet; they are gathered in the last section.

**Integers by default.**
A result shown to the player, or compared to a threshold, is rounded down unless the formula says otherwise.

## World and Monolith

**Floors.**

```text
floor_count = current_wizards - 1
```

Source: `GLOSSARY.md`, Monolith.
A floor exists only once the population reaches it, and disappears from play if the population falls.

**Artifacts dealt at generation.**

```text
artifacts_on_floor(f) = 2   if f in {10, 20, 30, 40}
                        1   otherwise,  for f in 1..49
artifacts_per_world   = 49 + 4 = 53
```

Source: `ARTIFACTS.md`.
Every possible floor receives its Artifacts at generation; a floor not yet unlocked holds them dormant.

**World queue.**

```text
wizards_required(t) = max(10, 20 - max(0, t - 5))      t in whole minutes since the queue opened
```

Source: `GLOSSARY.md`, queue.

## Wizard progression

**Grimoire positions.**

```text
grimoire_positions = min(10, max(1, wizard_level - 1))
```

Source: `GLOSSARY.md`, Grimoire position.
Each position beyond the first costs one mana-stone to unlock.
Ten is the cap, one per number key from 1 to 0, reached at level 11.

**Target level.**

```text
the most active wizard reaches about wizard_level 15 on day 8
```

There is no level cap; the XP curve is built so this target holds, and the curve itself becomes the ceiling.
Dungeon level ranges, up to 13 – 16, are set against it.

⬜ The XP needed for each `wizard_level`.

## Combat

**Damage is multiplicative.**

```text
damage = raw_damage × K / (K + effective_magic_defence)
effective_magic_defence = magic_defence × (1 - penetration)      penetration in [0, 1]
```

Defence never brings a hit to zero, and each point of `magic_defence` adds the same amount of survival.
`K` is the defence that halves a hit.
Penetration is how Stone ignores a portion of defence and Rust ignores all of it.

⬜ `K`, set once stat growth per level is known.
⬜ `raw_damage`, from the spell's magnitude and the caster's `power`.

## Magic

**Rune rarity.**

| Rarity        | Magnitude | Weight |
| ------------- | --------: | -----: |
| **common**    |      ×1.0 |   ×1.0 |
| **rare**      |      ×1.6 |   ×1.4 |
| **legendary** |      ×2.5 |   ×2.0 |

```text
rune_magnitude = common_magnitude × magnitude_multiplier(rarity)
rune_weight    = common_weight    × weight_multiplier(rarity)
```

Source: `RUNES.md`.
Magnitude grows faster than weight, so a rarer rune is always worth its extra weight.

**Weight bar.**

```text
spell_weight   = Σ rune_weight over the spell's runes
weight_bar_max = mana_pool
headroom       = weight_bar_max - spell_weight
```

Source: `GLOSSARY.md`, weight bar.
The bar runs from 1 to the wizard's `mana_pool`, and no figure is ever shown to the player.

⬜ The mana cost of a spell, computed from `spell_weight`.
⬜ The cooldown of a spell, computed from its Duration and Element.

## Enemies

**Tier baselines.**

| Tier         | health | power | magic defence | speed | luck |
| ------------ | -----: | ----: | ------------: | ----: | ---: |
| **critter**  |     30 |     4 |             2 |   110 |    1 |
| **common**   |     80 |     9 |             5 |   100 |    2 |
| **veteran**  |    200 |    18 |            12 |   100 |    3 |
| **elite**    |    450 |    34 |            22 |   105 |    5 |
| **champion** |    900 |    60 |            40 |   100 |    8 |

```text
enemy_stat ∈ [0.75 × tier_baseline, 1.25 × tier_baseline]
```

Source: `ENNEMIES.md`.
Guardians use the same baselines and the same band, see `SPIRITS_GUARDIANS.md`.

**Seasonal enemies.**

```text
weak season    : every stat × 0.8
strong season  : every stat × 1.2
appears/present: every stat × 1.0
```

Source: `ENNEMIES.md`, Scaling across the four seasons.

⬜ Whether ordinary enemies drift upward across a run.

## World bosses

**Season scaling.**

```text
boss_stat = table_stat × 1.25 ^ seasons_survived
```

Applies to `health`, `power`, `magic_defence`, `mana_pool` and `luck`; `speed` never scales.
Season-locked bosses are exempt, since they never cross a season boundary.

```text
rootbound_stat = table_stat × (1.25 × 1.15) ^ seasons_survived = table_stat × 1.4375 ^ seasons_survived
```

Source: `WORLD_BOSSES.md`, Season scaling.

**Contribution tickets.**

```text
contribution(w) = a × damage_dealt(w) + b × healing_done(w) + c × damage_taken(w)
tickets(w)      = contribution(w)
```

```text
share(w)      = tickets(w) / Σ tickets over every wizard who fought
gold(w)       = gold_pool × share(w)
xp(w)         = xp_pool   × share(w)
rp(w)         = rp_pool   × share(w)
rune winners  = the three wizards with the most tickets
```

```text
P(w wins a stone) = tickets(w) / Σ tickets over the wizards who chose Want
```

Source: `WORLD_BOSSES.md`, Rewards and the kill.
A wizard who has not answered when the stone draw closes counts as Want.

⬜ The weights `a`, `b` and `c`.
⬜ Whether `damage_taken` counts all damage, or only damage taken while the boss was attacking someone else.
⬜ The size of `gold_pool`, `xp_pool` and `rp_pool` per boss.

## Dungeons

**Gilded Hoard, Gold Wraiths.**

```text
gold_rank = the wizard's rank by carried gold among living wizards of the world, frozen on entry
```

| `gold_rank` | Gold Wraiths gain  |
| ----------- | ------------------ |
| 1 – 4       | ×2 `power`         |
| 5 – 8       | ×2 `magic_defence` |
| 9 – 14      | ×2 `health`        |
| 15 and over | nothing            |

Source: `DUNGEONS.md`, The Gilded Hoard.
The Wraith count per room is fixed; only the rank scales them.

**Dungeon draw.**

```text
dungeons_per_run = 20, distinct, drawn at generation
open(d)          = whole run           ordinary dungeon
                   its own season only season-gated dungeon
```

Source: `DUNGEONS.md`, What a dungeon is.
The catalogue holds 30, so a world draws two dungeons in three.
⬜ Mana-stone and life-stone drop chance per dungeon, set low on purpose.

## Economy

**Escalating price.**

```text
price(type, n) = base_price(type) × multiplier(type) ^ n
```

`n` counts every purchase of that type this run, including holdings since sold or lost, and never resets.
Source: `GLOSSARY.md`, escalating price.

⬜ `base_price` and `multiplier` for each purchase type.
⬜ Whether tower upgrades count per tower or per wizard, see `UPGRADES_TOWER.md`.

## Flags

```text
flag_end = min(raised_at + 24 h, end of the current season, the wizard's death)
```

| Flag           | Bonus while flown                  |
| -------------- | ---------------------------------- |
| **truce flag** | +10 % `magic_defence` and `health` |
| **war flag**   | +10 % `power` and `speed`          |

Source: `GLOSSARY.md`, flag.


## Score and reincarnation points

```text
score_gain = gain × 0.25      while the world is in overtime
             gain             otherwise
```

Source: `GLOSSARY.md`, overtime and score.

⬜ What a score is made of.
⬜ How a score converts into RP.
⬜ The winner's bonus.
⬜ RP per dungeon, per world boss, per floor and per wizard kill.

## Endings

**Sudden death.**

```text
minimap_size(m) = original_size × (1 - 0.10 × (m - 5))      for 5 ≤ m ≤ 15
                  original_size                             for m < 5
```

`m` is whole minutes since the ROOF fight began; the minimap reaches zero at minute 15.
Source: `GLOSSARY.md`, sudden death.

## Missing formulas

Gathered here so they can be answered in one pass, roughly in the order the game needs them.

| Formula                                         | Needed by                        | Blocks                      |
| ----------------------------------------------- | -------------------------------- | --------------------------- |
| `K` and `raw_damage`                            | every fight                      | any balancing at all        |
| Stat growth per `wizard_level`                  | `GLOSSARY.md`                    | `K`, every fight            |
| Crit and favourable rolls, from `luck`          | every fight, drops               | Spark, crits, drop rates    |
| Mana cost, from `spell_weight`                  | `RUNES.md`                       | the spell builder           |
| Cooldown, from Duration and Element             | `RUNES.md`                       | the spell builder           |
| XP per `wizard_level`                           | `GLOSSARY.md`, `MAZES.md`        | maze rewards, Grimoire pace |
| Contribution ticket weights `a`, `b`, `c`       | `WORLD_BOSSES.md`                | every world boss reward     |
| Reward pools per world boss                     | `WORLD_BOSSES.md`                | world boss economy          |
| `base_price` and `multiplier` per purchase type | `UPGRADES_*.md`, `WEAPONS.md`    | the whole economy           |
| Score composition and RP conversion             | `GLOSSARY.md`                    | meta-progression            |
| RP per source                                   | `DUNGEONS.md`, `WORLD_BOSSES.md` | meta-progression            |
| Stone drop chances                              | `DUNGEONS.md`                    | Grimoire pace               |

**Stat growth comes first, then `K`.**
The shape of the damage formula is settled; its constant only means something once the range of `magic_defence` across a run is known.
