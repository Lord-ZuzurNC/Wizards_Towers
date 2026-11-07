# Bestiary — Wizards Towers

## How to read this document

This document lists the enemies that roam the open world, fill dungeons and mazes, and defend the Monolith's floors.
It does not cover **floor bosses** or **world bosses**, which have their own documents.

**Enemies use their own authored attacks. They never use the rune and spell system.**
That holds for magic-attack enemies too: a Frost Pixie does not assemble a spell from Shape, Element and Duration runes, it has a frost bolt.
The rune system belongs to wizards alone.

Every enemy uses the same six stats as a wizard: `health`, `power`, `mana pool`, `magic defence`, `speed`, `luck`.
There is no separate melee stat and magic stat.
An enemy has one `power` value and a descriptive **Atk type** field, either `melee` or `magic`, and the backend treats both the same way.

An elemental weakness or resistance on a single enemy is a **per-enemy specificity, not a game system**.
A Shambling Corpse collapsing to fire and a Swamp Hydra Pup healing from it need no elemental framework behind them.

Every enemy has a **tier** — **critter**, **common**, **veteran**, **elite**, **champion** — and a **family**, its nature; a few are **special** and never spawn on their own.

The tier numbers are fixed by the project contract.
A deviation of up to ±25 % is allowed per enemy to give it character, and the **Notes** column says why whenever a stat sits at the edge of its range.
`magic defence` and `luck` only vary meaningfully from **elite** upward: below that the tier's base number is too small for the tolerance band to contain another whole number, so critters sit at luck 1 and magic defence 2, and common enemies at luck 2.

`mana pool` is not fixed per tier: a magic-attack enemy carries a larger pool than a melee enemy of the same tier, since a melee enemy needs only a small reserve while a caster must sustain repeated casts.

The **Behaviour** column states the one thing a player must do differently to beat that enemy.

## Tiers

| Tier         | health | power | magic defence | speed | luck | Role                                                                   |
| ------------ | -----: | ----: | ------------: | ----: | ---: | ---------------------------------------------------------------------- |
| **critter**  |     30 |     4 |             2 |   110 |    1 | Trivial; fills empty space and teaches a single mechanic.              |
| **common**   |     80 |     9 |             5 |   100 |    2 | The ordinary enemy of the open world.                                  |
| **veteran**  |    200 |    18 |            12 |   100 |    3 | A real fight for a mid-run wizard; the first genuinely dangerous solo. |
| **elite**    |    450 |    34 |            22 |   105 |    5 | Dangerous alone, lethal in a pair.                                     |
| **champion** |    900 |    60 |            40 |   100 |    8 | The strong enemy of a dungeon, maze or Monolith floor.                 |

## Families

Enemies are filed by **family**, their nature, one file per family under `bestiary/`.
Each file lists its enemies across every tier, with their special enemies at the end.

| Family                               | critter | common | veteran | elite | champion | special |  Total |
| ------------------------------------ | ------: | -----: | ------: | ----: | -------: | ------: | -----: |
| [Undead](bestiary/UNDEAD.md)         |       0 |      2 |       2 |     2 |        1 |       3 |     10 |
| [Beasts](bestiary/BEASTS.md)         |       3 |      4 |       1 |     1 |        1 |       0 |     10 |
| [Fae](bestiary/FAE.md)               |       3 |      1 |       2 |     1 |        2 |       0 |      9 |
| [Elementals](bestiary/ELEMENTALS.md) |       1 |      1 |       2 |     1 |        1 |       0 |      6 |
| [Constructs](bestiary/CONSTRUCTS.md) |       0 |      2 |       2 |     1 |        0 |       1 |      6 |
| [Humanoids](bestiary/HUMANOIDS.md)   |       0 |      4 |       3 |     1 |        0 |       0 |      8 |
| **Total**                            |   **7** | **14** |  **12** | **7** |    **5** |   **4** | **49** |

## Special enemies

A special enemy does **not** spawn on its own.
It appears only from the condition stated in its family file.
A season-gated enemy is **not** special — it spawns by itself, just in one season.

**The Skeleton Hand exclusion matters.**
A Bone Pile appears where any enemy dies, except a Skeleton Hand.
Without that exclusion, a Bone Pile producing Skeleton Hands whose deaths produce more Bone Piles would never stop.

## Scaling across the four seasons

A seasonal enemy either appears in some seasons and not others, or is present with its strength varying.
Each entry's arc is stated below rather than left to a general rule.

| Enemy                | spring  | summer | autumn  | winter  |
| -------------------- | ------- | ------ | ------- | ------- |
| Flame Wisp Elemental | appears | strong | weak    | absent  |
| Frost Warden         | absent  | absent | appears | strong  |
| Frost Pixie          | absent  | absent | absent  | present |
| Permafrost Wyrm      | absent  | absent | weak    | strong  |
| Molten Titan         | weak    | strong | present | absent  |
| Mire Elemental       | strong  | weak   | strong  | absent  |

The Flame Wisp and the Frost Warden are deliberate opposites: one fades exactly as the other arrives, so autumn is the only season both are on the map at once.

**A `weak` season applies -20 % to every stat, a `strong` season +20 %.**
`appears` and `present` are the baseline, and `absent` means the enemy does not spawn at all that season.

The gold a village loses when a crop row is finished by Cabbage Grub, Wild Boar or The Rootbound Elder is defined with the crop rules, in `UPGRADES_VILLAGE.md`.

⬜ Whether ordinary non-seasonal enemy stats drift upward across a run has not been decided.

## Notes for balancing

**Likely overpowered.**
Ogre Warlord sits at the top of its range on both `health` and `power` at once, stacking two deviations in the same direction; pulling one back toward the baseline would stop it reading like a champion wearing an elite's stat block.
Ironclad Warbeast does the same across three stats, which is defensible for a dungeon-end champion but makes it the single most-tested entry here.

**Likely underpowered.**
Marsh Leech Swarm has the lowest `power` in its tier and a slow-building payoff, so in a short fight it reads as merely weak; it needs either a faster drain or a visible warning.
Necromancer Acolyte's low health is meant to reward focus-fire, but if Skeleton Hands arrive faster than a wizard clears them the intended read inverts from "kill it fast" into "it is already too late".

**Accepted repetition.**
Permafrost Wyrm, Molten Titan and Mire Elemental reuse the Flame Wisp and Frost Warden seasonal pattern.
They sit in different tiers and climb in strength, so the overlap is acceptable — not every entry can be unique.

**Worth watching.**
Tiny Shattered Colossus at speed 40 is slower than anything else here and can simply be walked away from, which risks making the Shattered Colossus's death-split a non-event rather than a second fight.
