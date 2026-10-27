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

Five tier tables follow — **critter**, **common**, **veteran**, **elite**, **champion** — then a sixth table of **special enemies** that do not spawn on their own.

The tier numbers are fixed by the project contract.
A deviation of up to ±25 % is allowed per enemy to give it character, and the **Notes** column says why whenever a stat sits at the edge of its range.
`magic defence` and `luck` only vary meaningfully from **elite** upward: below that the tier's base number is too small for the tolerance band to contain another whole number, so critters sit at luck 1 and magic defence 2, and common enemies at luck 2.

`mana pool` is not fixed per tier: a magic-attack enemy carries a larger pool than a melee enemy of the same tier, since a melee enemy needs only a small reserve while a caster must sustain repeated casts.

The **Behaviour** column states the one thing a player must do differently to beat that enemy.

## Critter — trivial, teaches mechanics

Tier baseline: health 30, power 4, magic defence 2, speed 110, luck 1.
These fill empty space in the open world and each teach a single mechanic: dodging, kiting, swarm behaviour, or reading a wind-up.

| Name            | Atk type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                               | Notes                                                                        |
| --------------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | --------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Mudskitter Rat  | melee    |     24 |     3 |         5 |             2 |   135 |    1 | Harmless alone, but three or more together stop fleeing and swarm a wizard's flank instead.                                             | Speed at the top of its range to sell "swarm that scatters, then regroups".  |
| Bramble Hare    | melee    |     26 |     3 |         5 |             2 |   137 |    1 | Bolts the instant it takes any damage, so a wizard must land a killing first hit or lose the chase entirely.                            | Highest speed of any critter; teaches committing to the first strike.        |
| Candlewisp      | magic    |     25 |     4 |        18 |             2 |   100 |    1 | Drifts in place and only fires a weak spark bolt if a wizard lingers inside its glow for several seconds.                               | Teaches reading the enemy's wind-up rather than its stats.                   |
| Cabbage Grub    | melee    |     28 |     3 |         4 |             2 |    85 |    1 | **Spawns only near a crop field.** Ignores wizards entirely and eats slowly through a crop row, costing the village gold if left alone. | The slowness is the point: a patrolling owner always has time to stop it.    |
| Dust Mote Swarm | magic    |     27 |     4 |        20 |             2 |   120 |    1 | **Spawns as a pair and multiplies over time toward about ten.** Each surviving mote buffs the speed of the others.                      | Rewards burst over sustained damage. Left alone it becomes a real fight.     |
| Rust Sprite     | magic    |     30 |     5 |        16 |             2 |   105 |    1 | Pelts a corrosive bolt that temporarily lowers the wizard's magic defence, rewarding a fast melee kill over trading at range.           | Power at the top of its range.                                               |
| Moss Sprite     | magic    |     23 |     3 |        14 |             2 |   100 |    1 | Never attacks, and channels a slow heal into the nearest wounded critter, so it is the priority kill in any pack.                       | Lowest health in the tier; a pure support role has no business tanking hits. |

## Common — the ordinary enemy of the open world

Tier baseline: health 80, power 9, magic defence 5, speed 100, luck 2.
Bandit camps, pack beasts, undead stragglers, and the first enemies that punish a careless low-level wizard.

| Name               | Atk type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                         | Notes                                                                                          |
| ------------------ | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Goblin Skirmisher  | melee    |     65 |    10 |         8 |             4 |   122 |    2 | Lands one hit then retreats to range, punishing a wizard with no way to close distance quickly.                                   | Health near the bottom of its range to pay for the hit-and-run pattern.                        |
| Goblin Firethrower | magic    |     70 |    11 |        30 |             4 |    95 |    2 | Lobs a flaming flask that scorches the ground, so the fight itself damages anyone standing on the burn afterwards.                | Power at the top of its range.                                                                 |
| Bandit Raider      | melee    |     85 |    10 |        10 |             5 |   108 |    2 | Sounds a horn on first taking damage and runs for its camp, returning with two more raiders if not killed within a few seconds.   | The signature "flee and fetch reinforcements" enemy of this tier.                              |
| Bandit Cutpurse    | melee    |     62 |     8 |         6 |             4 |   124 |    2 | Tries to pickpocket the wizard's gold and flee, and only fights back if cornered first.                                           | Harmless until provoked; the cost of ignoring it is gold, not health.                          |
| Dire Wolf          | melee    |     75 |    10 |         5 |             4 |   123 |    2 | Circles to flank from behind while a packmate holds the wizard's attention head-on.                                               | Always spawns paired; solo tuning assumes the flanking partner is present.                     |
| Wild Boar          | melee    |     98 |     9 |         4 |             6 |    80 |    2 | Charges in a straight line that staggers on impact, and tramples a village's crop row if it wanders there unchecked.              | Health and magic defence near the top of range for a slow armoured charge.                     |
| Giant Spider       | magic    |     70 |    10 |        20 |             5 |   100 |    2 | Spits a web bolt that roots the wizard in place, then closes the distance while the root holds.                                   | Early-game trap enemy; trivial once a wizard has any root cleanse.                             |
| Marsh Leech Swarm  | melee    |     60 |     7 |        15 |             4 |    90 |    2 | Siphons a sliver of the wizard's mana into its own pool on every hit, so the fight worsens the longer it drags on.                | Lowest power in the tier, intentionally; its threat scales over time.                          |
| Shambling Corpse   | melee    |    100 |     9 |         5 |             6 |    76 |    2 | Shrugs off ordinary hits but **collapses outright to fire damage**, punishing a wizard with no answer to it.                      | Health and magic defence top of range, speed bottom. The fire weakness is its own specificity. |
| Grave Moth         | magic    |     65 |     9 |        25 |             4 |   110 |    2 | Drains health at range over time and flutters straight out of melee reach the instant a wizard closes in.                         | Speed pushed up to make "cannot be melee'd down" land.                                         |
| Mire Elemental     | magic    |     90 |     9 |        35 |             5 |    80 |    2 | Pulses a slow-spreading bog that halves speed for anyone standing in it, rewarding kiting over trading.                           | Seasonal: see the season table.                                                                |
| Frost Pixie        | magic    |     65 |     9 |        28 |             4 |   115 |    2 | Chains a short frost bolt that stacks a slow, and becomes nearly harmless once the slow is cleansed or outrun.                    | **Winter only.** Absent in the other three seasons.                                            |
| Tinker Imp         | magic    |     70 |     8 |        32 |             5 |   100 |    2 | **Never attacks anything.** Repairs the nearest damaged construct enemy, so it must die before the construct it is mending.       | Harmless alone and the priority kill in any construct pack. It damages nothing.                |
| Clockwork Sentinel | melee    |     95 |     9 |        10 |             6 |    80 |    2 | Holds its ground and counters a melee strike with a short stun, punishing a wizard who trades blows instead of baiting its swing. | Magic defence at the top of range for a stationary corridor guard.                             |

## Veteran — a real fight for a mid-run wizard

Tier baseline: health 200, power 18, magic defence 12, speed 100, luck 3.
Supports that must die first, enemies that punish a specific gap in a wizard's kit, and the first entries genuinely dangerous solo.

| Name                 | Atk type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                 | Notes                                                                           |
| -------------------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | ------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Orc Berserker        | melee    |    180 |    22 |        10 |            10 |   110 |    3 | Attacks faster as its own health drops, so burst damage beats a slow grind against it.                                    | Power at the top of its range to pay for the self-enrage.                       |
| Orc Shaman           | magic    |    170 |    19 |        70 |            12 |    95 |    3 | Shields the nearest ally before attacking, so killing it first denies the whole pack its damage reduction.                | Support-first priority target.                                                  |
| Troll Bruiser        | melee    |    240 |    20 |         8 |            15 |    80 |    3 | Regenerates a slice of health every few seconds unless a wizard's burst outpaces the regeneration.                        | Regeneration rate to be tuned later. Health and magic defence top of range.     |
| Swamp Hydra Pup      | melee    |    210 |    18 |        15 |            12 |   100 |    3 | **Regrows lost health whenever it takes fire damage**, so a wizard relying on fire fights a losing battle.                | Its own specificity, the mirror of the Shambling Corpse.                        |
| Necromancer Acolyte  | magic    |    160 |    17 |        85 |            11 |    95 |    3 | Raises a Skeleton Hand every time its own cast completes, so it must die before its retinue grows out of hand.            | Summon cadence on its own sheet. Health at the bottom of range: a glass cannon. |
| Barrow Wight         | magic    |    190 |    18 |        60 |            13 |    90 |    3 | Drains a slice of the wizard's mana pool on every hit, crippling a low-level wizard far more than a late one.             | Dangerous early, trivial later, since mana pool grows with level.               |
| Will-o'-Wisp Herald  | magic    |    150 |    17 |        75 |            12 |   120 |    3 | Never commits to a fight and lures a wizard toward a den of other fae, vanishing the moment it is seriously threatened.   | Lowest health and highest speed in the tier: a lure, not a brawler.             |
| Fae Duelist          | melee    |    180 |    19 |        20 |            12 |   105 |    4 | Relies on favourable rolls for crippling critical strikes, making the fight swingy and rewarding a decisive finish.       | **Luck 4**, the only veteran above the tier's flat 3.                           |
| Stone Golem Ward     | melee    |    250 |    18 |         5 |            15 |    75 |    3 | Barely moves from its post and leans on raw magic defence to outlast attackers, rewarding sustained damage over burst.    | Health and magic defence top of range, speed bottom: a chokepoint guard.        |
| Arc Construct        | magic    |    170 |    20 |        55 |            11 |   100 |    3 | Arcs its bolt to a second nearby target, making it far more dangerous alongside another enemy than alone.                 | Power at the top of range for the chain-damage read.                            |
| Flame Wisp Elemental | magic    |    190 |    19 |        65 |            12 |   110 |    3 | Leaves a trail of fire wherever it moves, so a wizard must fight it in bursts rather than chase it through its own trail. | Seasonal arc: see the season table.                                             |
| Frost Warden         | magic    |    200 |    18 |        60 |            14 |    85 |    3 | Freezes the ground in a slowly growing ring, so a wizard must break away before the ring closes off every escape route.   | Seasonal arc: see the season table.                                             |

## Elite — dangerous alone, lethal in a pair

Tier baseline: health 450, power 34, magic defence 22, speed 105, luck 5.
The first tier where `magic defence` and `luck` have room to vary meaningfully between entries.

| Name               | Atk type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                    | Notes                                                                                 |
| ------------------ | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Lich Apprentice    | magic    |    400 |    38 |       150 |            20 |   100 |    5 | Channels a health-drain beam that can be interrupted by breaking line of sight, but ticks heavily left uninterrupted.        | Power pushed up, health pulled down: a glass-cannon caster.                           |
| Death Knight       | melee    |    500 |    36 |        30 |            27 |   100 |    4 | Strikes rapidly and repeatedly. **Any hit interrupts a heal in progress**, so its cadence alone keeps a wizard from healing. | Mildly anti-heal as a consequence of its speed, with no anti-heal mechanic behind it. |
| Ogre Warlord       | melee    |    560 |    42 |        15 |            18 |    85 |    4 | Telegraphs a long wind-up before each swing, so the fight is about punishing that window rather than trading hits.           | Health and power both at the top of range; a likely overtune.                         |
| Coven Matriarch    | magic    |    380 |    32 |       180 |            24 |   110 |    6 | Continuously heals every fae enemy in the area, making the area effectively unkillable until she dies first.                 | Highest luck in the tier; built around being killed first.                            |
| Shattered Colossus | melee    |    450 |    34 |        20 |            26 |    80 |    5 | **On death, breaks into two Tiny Shattered Colossus**, so killing it is the start of the fight rather than the end.          | The split happens at death, not at half health.                                       |
| Void Maw           | magic    |    420 |    37 |       140 |            20 |    95 |    5 | Pulls the wizard a short distance toward itself before each cast, so staying mobile matters more than raw damage.            | The pull is the whole identity, not the numbers.                                      |
| Permafrost Wyrm    | magic    |    520 |    35 |       120 |            23 |    90 |    5 | Spreads a slow-growing field of ice that does not stop advancing even if the wizard retreats, demanding a quick kill.        | Seasonal arc: see the season table.                                                   |

## Champion — dungeon-end material

Tier baseline: health 900, power 60, magic defence 40, speed 100, luck 8.
The "strong enemy" of a dungeon, maze, or Monolith floor, distinct from the authored floor boss that may also guard that floor.

| Name                | Atk type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                                                   | Notes                                                                    |
| ------------------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| The Hollow King     | magic    |   1000 |    65 |       250 |            45 |    95 |    8 | **Summons a wave of Skeleton Guards** whenever its own health crosses each quarter threshold, demanding crowd control over a burst race.                    | Wave size and cap live on its own sheet.                                 |
| Ironclad Warbeast   | melee    |   1125 |    70 |        20 |            50 |    80 |    6 | Telegraphs a charge on a fixed timer that must be dodged outright, since tanking it costs most of a wizard's health.                                        | Health, power and magic defence all top of range; a likely overtune.     |
| Archfae Trickster   | magic    |    750 |    58 |       280 |            35 |   120 |   10 | Spawns illusory decoys that mimic its own attack pattern, so a wizard must learn its tell to pick the real target out of the copies.                        | Health bottom of range, luck and speed top: a trickster, not a tank.     |
| Molten Titan        | magic    |   1050 |    72 |       200 |            38 |    90 |    7 | Erupts in a wide area pulse that melts the surrounding terrain, forcing constant repositioning rather than a fixed stance.                                  | Seasonal arc: see the season table.                                      |
| The Rootbound Elder | melee    |   1100 |    63 |       150 |            42 |    75 |    7 | Drains health from any village crop field within reach to heal itself, so the fight drags on near farmland until the crops are cleared or it is lured away. | Slowest enemy in the document by design; it is rooted, almost literally. |

## Special enemies

A special enemy does **not** spawn on its own.
It appears only from the condition stated below.
A season-gated enemy is **not** special — it spawns by itself, just in one season.

| Name                    | Atk type | health | power | mana pool | magic defence | speed | luck | Spawn condition                                                                              | Notes                                                                                             |
| ----------------------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| Bone Pile               | —        |     40 |     0 |         0 |             2 |     0 |    1 | **30 % chance to appear where any enemy dies.** A Skeleton Hand's death never creates one.   | Cannot attack and cannot move. It exists to produce Skeleton Hands, and destroying it stops them. |
| Skeleton Hand           | melee    |     32 |     4 |         6 |             2 |    95 |    1 | Produced by a **Bone Pile**, or raised by a **Necromancer Acolyte** on each completed cast.  | Crawls and claws at ankles. Endless until its source is destroyed.                                |
| Skeleton Guard          | melee    |     80 |     9 |         5 |             5 |   100 |    2 | Summoned by **The Hollow King** in a wave, each time its health crosses a quarter threshold. | Common-tier stats. Dangerous as a wave, trivial individually.                                     |
| Tiny Shattered Colossus | melee    |    225 |    17 |        10 |            13 |   100 |    2 | Two appear when a **Shattered Colossus** dies, each at half its parent's stats.              | Half of every parent stat. Very slow, so it can be left behind and ignored.                       |

**The Skeleton Hand exclusion matters.**
Without it, a Bone Pile producing Skeleton Hands whose deaths produce more Bone Piles would never stop.

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

## Counts

| Tier      | Enemies |
| --------- | ------: |
| critter   |       7 |
| common    |      14 |
| veteran   |      12 |
| elite     |       7 |
| champion  |       5 |
| special   |       4 |
| **Total** |  **49** |

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
