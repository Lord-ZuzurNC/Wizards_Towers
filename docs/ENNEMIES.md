# Bestiary — Wizards Towers

## How to read this document

This document lists the generic enemies that roam the open world, fill dungeons and mazes, and defend the Monolith's floors.
It does not cover **floor bosses** or **world bosses**: those are authored or scaled separately and belong in their own documents.
Every enemy below uses the same six stats as a wizard: `health`, `power`, `mana pool`, `magic defence`, `speed`, `luck`.
There is no separate melee stat and magic stat.
An enemy has one `power` value and a descriptive **Attack type** field, either `melee` or `magic`, and the backend treats both the same way.

Five tables follow, one per tier: **critter**, **common**, **veteran**, **elite**, **champion**.
The tier numbers are fixed by the project contract and are not reinvented here.
A deviation of up to ±25 % on `health`, `power`, `magic defence`, `speed` or `luck` is allowed per enemy to give it character, and the **Notes** column says why whenever a stat is pushed to the edge of that range.
Two tiers, **critter** and **common**, have a `luck` value so low that ±25 % does not contain any other whole number, so every critter sits at luck 1 and every common enemy sits at luck 2.
The same is true of a critter's `magic defence`, fixed at 2 for the whole tier.
**Veteran** has the same problem with `luck`: ±25 % of 3 only contains the integer 3 itself, so every veteran is luck 3.
`magic defence` and `luck` only start showing real per-enemy variety from **elite** upward, where the tier's base number is high enough for the tolerance band to contain more than one integer.

`mana pool` is not part of the tier table in the contract, since the contract only fixes `health`, `power`, `magic defence`, `speed` and `luck` per tier.
⬜ The numbers below are therefore this document's own proposal, not a confirmed design value: an enemy using `attack type: magic` is given a larger mana pool than a same-tier enemy using `attack type: melee`, on the theory that a melee enemy still needs a small reserve for the odd talent but does not need to sustain repeated casts.
This scaling choice needs sign-off before it is treated as final; see "Notes for balancing" at the end.

The **Behaviour** column is the important one for design review.
It states the one thing a player must actually do differently to beat that enemy, not a restatement of its numbers.
The **Notes** column explains any stat pushed toward the edge of its tier's range, flags open questions with ⬜, and otherwise stays empty.

Enemies are grouped within each tier by fantasy identity — beast, undead, construct, fae, bandit, elemental, aberration — wherever that reading order makes the table clearer.

## Critter — trivial, teaches mechanics

Tier baseline: health 30, power 4, magic defence 2, speed 110, luck 1.
These fill empty space in the open world and are built to teach a single mechanic each: dodging, kiting, swarm behaviour, or reading a cast bar.

| Name              | Attack type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                      | Notes                                                                                 |
| ----------------- | ----------- | -----: | ----: | --------: | -------------: | ----: | ---: | ------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| Mudskitter Rat    | melee       |     24 |     3 |         5 |              2 |   135 |    1 | Harmless alone, but three or more rats together stop fleeing and swarm a wizard's flank instead.                                 | Speed pushed to the top of its range to sell "swarm that scatters, then regroups".     |
| Bramble Hare      | melee       |     26 |     3 |         5 |              2 |   137 |    1 | Bolts the instant it takes any damage, so a wizard must land a killing first hit or lose the chase entirely.                   | Highest speed of any critter; teaches committing to the first strike.                  |
| Candlewisp        | magic       |     25 |     4 |        18 |              2 |   100 |    1 | Drifts in place and only fires a weak spark bolt if a wizard lingers inside its glow for several seconds.                      | Teaches reading the enemy's own wind-up rather than its stats.                         |
| Cabbage Grub      | melee       |     28 |     3 |         4 |              2 |    85 |    1 | Ignores wizards entirely and burrows into a village's crop row, finishing the row and costing the village gold if left alone.  | Ties into the season-driven crop mechanic noted in the project glossary.               |
| Dust Mote Swarm   | magic       |     27 |     4 |        20 |              2 |   120 |    1 | Each surviving mote buffs the speed of the others, so a wizard who trades hits slowly ends up fighting a faster and faster swarm. | Rewards burst damage over sustained damage, the opposite lesson from the hare.       |
| Skeleton Hand     | melee       |     32 |     4 |         6 |              2 |    95 |    1 | Crawls and claws at ankles, and keeps reappearing from a nearby bone pile until the pile itself is destroyed.                  | ⬜ "Bone pile" is a prop this entry assumes exists; not confirmed as a real object.      |
| Rust Sprite       | magic       |     30 |     5 |        16 |              2 |   105 |    1 | Pelts a corrosive bolt that temporarily lowers the wizard's own magic defence, rewarding a fast melee kill over trading at range. | Power at the top of its range; the corrosion debuff is this entry's own invention.   |
| Moss Sprite       | magic       |     23 |     3 |        14 |              2 |   100 |    1 | Never attacks, and instead channels a slow heal into the nearest wounded critter, so it is the priority kill in any pack.      | Lowest health in the tier; a pure support role has no business tanking hits.           |

## Common — the ordinary enemy of the open world

Tier baseline: health 80, power 9, magic defence 5, speed 100, luck 2.
This is the bulk of open-world population: bandit camps, pack beasts, undead stragglers, and the first enemies that genuinely punish a careless low-level wizard even though a mid-run wizard shrugs them off.

| Name                | Attack type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                          | Notes                                                                                   |
| ------------------- | ----------- | -----: | ----: | --------: | -------------: | ----: | ---: | ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Goblin Skirmisher   | melee       |     65 |    10 |         8 |              4 |   122 |    2 | Lands one hit then retreats to range, punishing a wizard with no way to close distance quickly.                                   | Health near the bottom of its range to pay for the hit-and-run pattern.                   |
| Goblin Firethrower  | magic       |     70 |    11 |        30 |              4 |    95 |    2 | Lobs a flaming flask that scorches the ground, so the fight itself damages anyone who stands on the burn afterward.               | Power at the top of its range; the burn ground is this entry's own invention.             |
| Bandit Raider       | melee       |     85 |    10 |        10 |              5 |   108 |    2 | Sounds a horn on first taking damage and runs for its camp, returning with two more raiders if not killed within a few seconds.   | The signature "flee and fetch reinforcements" enemy of this tier.                         |
| Bandit Cutpurse     | melee       |     62 |     8 |         6 |              4 |   124 |    2 | Tries to pickpocket the wizard's gold and flee, and only fights back if cornered first.                                           | Harmless-until-provoked; the real cost of ignoring it is gold, not health.                |
| Dire Wolf           | melee       |     75 |    10 |         5 |              4 |   123 |    2 | Circles to flank from behind while a packmate holds the wizard's attention head-on.                                               | Always spawns paired; solo tuning assumes the flanking partner is present.                |
| Wild Boar           | melee       |     98 |     9 |         4 |              6 |    80 |    2 | Charges in a straight line that staggers on impact, and tramples a village's crop row if it wanders there unchecked.              | Health and magic defence near the top of range for the "slow but armoured charge" read.   |
| Giant Spider        | magic       |     70 |    10 |        20 |              5 |   100 |    2 | Spits a web bolt that roots the wizard in place, then closes the distance while the root holds.                                   | Early-game trap enemy; trivial once a wizard has any root-cleanse talent.                 |
| Marsh Leech Swarm   | melee       |     60 |     7 |        15 |              4 |    90 |    2 | Siphons a sliver of the wizard's own mana into its pool on every hit, so the fight gets worse the longer it drags on.             | Lowest power in the tier, intentionally, since its real threat scales over time.          |
| Shambling Corpse    | melee       |    100 |     9 |         5 |              6 |    76 |    2 | Shrugs off ordinary hits but collapses outright to fire damage, hard-punishing a wizard with no Element rune equipped.            | Health and magic defence at the top of range, speed at the bottom; fire weakness is ⬜ unconfirmed as a system. |
| Grave Moth          | magic       |     65 |     9 |        25 |              4 |   110 |    2 | Drains health at range over time and flutters straight out of melee reach the instant a wizard closes in.                        | Speed pushed up to make the "cannot be melee'd down" read land.                           |
| Mire Elemental      | magic       |     90 |     9 |        35 |              5 |    80 |    2 | Pulses a slow-spreading bog that halves speed for anyone standing in it, rewarding kiting over standing and trading.             | ⬜ Seasonal flavour assumed (wet autumn/spring); not confirmed which seasons it should favour. |
| Frost Pixie         | magic       |     65 |     9 |        28 |              4 |   115 |    2 | Chains a short frost bolt that stacks a slow, and becomes nearly harmless once the slow is cleansed or outrun.                   | ⬜ Written as winter-flavoured; season-lock vs season-boost is an open question, see below. |
| Hearth Imp          | magic       |     70 |     8 |        32 |              5 |   100 |    2 | Never attacks and instead channels repairs into the nearest damaged construct, making it the priority kill in any construct pack. | Mirrors the Moss Sprite's support role one tier up, with a construct instead of a critter. |
| Clockwork Sentinel  | melee       |     95 |     9 |        10 |              6 |    80 |    2 | Holds its ground and counters a melee strike with a short stun, punishing a wizard who trades blows instead of baiting its swing. | Magic defence at the top of range for a stationary dungeon-corridor guard.                 |

## Veteran — a real fight for a mid-run wizard

Tier baseline: health 200, power 18, magic defence 12, speed 100, luck 3.
This is where group tactics start to matter: supports that must die first, enemies that punish a specific gap in a wizard's kit, and the first entries that are genuinely dangerous solo.

| Name                  | Attack type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                        | Notes                                                                                   |
| --------------------- | ----------- | -----: | ----: | --------: | -------------: | ----: | ---: | ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Orc Berserker         | melee       |    180 |    22 |        10 |             10 |   110 |    3 | Attacks faster as its own health drops, so burst damage beats a slow grind against it.                                         | Power at the top of its range to pay for the self-enrage.                                  |
| Orc Shaman            | magic       |    170 |    19 |        70 |             12 |    95 |    3 | Shields the nearest ally before attacking, so killing it first denies the whole pack its damage reduction.                      | Classic support-first priority target.                                                     |
| Troll Bruiser         | melee       |    240 |    20 |         8 |             15 |    80 |    3 | Regenerates a slice of health every few seconds unless a wizard's burst outpaces the regeneration.                              | ⬜ Health and magic defence at the top of range; the regeneration rate itself is undecided. |
| Swamp Hydra Pup       | melee       |    210 |    18 |        15 |             12 |   100 |    3 | Regrows lost health whenever it takes fire damage, so a wizard without a non-fire rune equipped fights a losing battle.          | ⬜ Elemental weakness/resistance interactions are not confirmed anywhere in the contract.    |
| Necromancer Acolyte   | magic       |    160 |    17 |        85 |             11 |    95 |    3 | Raises a skeleton critter every time its own cast completes, so it must be killed fast before its retinue grows out of hand.    | Health at the bottom of range; a glass-cannon summoner is the intended read.                |
| Barrow Wight          | magic       |    190 |    18 |        60 |             13 |    90 |    3 | Drains a slice of the wizard's own mana pool on every hit, crippling a low-level wizard's spellcasting far more than a late one. | The textbook "dangerous early, trivial later" entry, since mana pool grows with level.      |
| Will-o'-Wisp Herald   | magic       |    150 |    17 |        75 |             12 |   120 |    3 | Never commits to a fight and instead lures a wizard toward a den of other fae, vanishing the moment it is seriously threatened. | Lowest health in the tier, highest speed, by design: it is a lure, not a brawler.           |
| Fae Duelist           | melee       |    180 |    19 |        20 |             12 |   105 |    3 | Relies on favourable rolls for crippling critical strikes, making the fight swingy and rewarding a quick, decisive finish.      | Luck is tier-flat at 3, so the "lucky" identity is carried by the behaviour text, not the number. |
| Stone Golem Ward      | melee       |    250 |    18 |         5 |             15 |    75 |    3 | Barely moves from its post and leans on raw magic defence to outlast attackers, rewarding sustained damage over burst.         | Health, magic defence at the top of range, speed at the bottom; archetypal chokepoint guard. |
| Arc Construct         | magic       |    170 |    20 |        55 |             11 |   100 |    3 | Arcs its bolt to a second nearby target, making it far more dangerous fought alongside another enemy than fought alone.         | Power at the top of range to justify the chain-damage read.                                 |
| Flame Wisp Elemental  | magic       |    190 |    19 |        65 |             12 |   110 |    3 | Leaves a trail of fire wherever it moves, so a wizard must fight it in short bursts rather than chase it through its own trail. | ⬜ Written as summer-flavoured; see the seasonal section on whether that should be a hard lock. |
| Frost Warden          | magic       |    200 |    18 |        60 |             14 |    85 |    3 | Freezes the ground in a slowly growing ring, so a wizard must break away before the ring closes off every escape route.        | ⬜ Written as winter-flavoured; mirrors the Flame Wisp Elemental's open seasonal question.    |

## Elite — dangerous alone, lethal in a pair

Tier baseline: health 450, power 34, magic defence 22, speed 105, luck 5.
This is the first tier where `magic defence` and `luck` have enough room in their ±25 % band to vary meaningfully between entries, and it shows in the spread below.

| Name                | Attack type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                       | Notes                                                                                     |
| -------------------- | ----------- | -----: | ----: | --------: | -------------: | ----: | ---: | ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Lich Apprentice      | magic       |    400 |    38 |       150 |             20 |   100 |    5 | Channels a health-drain beam that can be interrupted by breaking line of sight, but ticks for heavy damage left uninterrupted. | Power pushed up, health pulled down: a glass-cannon caster read.                              |
| Death Knight         | melee       |    500 |    36 |        30 |             27 |   100 |    4 | Its strikes reportedly suppress any healing effect on the wizard for a short duration.                                         | ⬜ Anti-heal is this entry's own invention; not confirmed as a real mechanic in the contract. |
| Ogre Warlord         | melee       |    560 |    42 |        15 |             18 |    85 |    4 | Telegraphs a long wind-up before each swing, so the fight is entirely about punishing that window rather than trading hits.    | Health and power both at the top of range together; flagged as a likely overtune, see below. |
| Coven Matriarch      | magic       |    380 |    32 |       180 |             24 |   110 |    6 | Continuously heals every fae enemy in the room, making the room effectively unkillable until she dies first.                  | Highest luck in the tier; the support-priority identity is built around being killed first.   |
| Shattered Colossus   | melee       |    450 |    34 |        20 |             26 |    80 |    5 | Splits into two lesser constructs once its own health crosses the halfway mark, doubling the incoming threat mid-fight.       | ⬜ Split-on-threshold is this entry's own invention; needs a decision on how the split pieces are statted. |
| Void Maw             | magic       |    420 |    37 |       140 |             20 |    95 |    5 | Pulls the wizard a short distance toward itself before each cast, so staying mobile matters more than raw damage output.      | Baseline-adjacent stats; the pull is the whole identity, not the numbers.                     |
| Permafrost Wyrm      | magic       |    520 |    35 |       120 |             23 |    90 |    5 | Spreads a slow-growing field of ice that does not stop advancing even if the wizard retreats, demanding it be killed quickly. | ⬜ Written as winter-flavoured; see the seasonal section for the open question this raises.    |

## Champion — dungeon-end material

Tier baseline: health 900, power 60, magic defence 40, speed 100, luck 8.
These are the "strong enemy" of a dungeon, maze, or Monolith floor, distinct from the authored floor boss that may also guard that same floor.

| Name                 | Attack type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                             | Notes                                                                                     |
| -------------------- | ----------- | -----: | ----: | --------: | -------------: | ----: | ---: | ---------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| The Hollow King      | magic       |   1000 |    65 |       250 |             45 |    95 |    8 | Resummons a wave of skeleton guards whenever its own health crosses each quarter threshold, demanding crowd control over a burst race. | ⬜ Risk of a dragged-out fight if summon waves are not capped; flagged for playtesting.       |
| Ironclad Warbeast    | melee       |   1125 |    70 |        20 |             50 |    80 |    6 | Telegraphs a charge on a fixed timer that must be dodged outright, since blocking or tanking it costs most of a wizard's health.      | Health, power and magic defence all pushed to the top of range; flagged as a likely overtune. |
| Archfae Trickster    | magic       |    750 |    58 |       280 |             35 |   120 |   10 | Spawns illusory decoys that mimic its own attack pattern, so a wizard must learn its tell to pick the real target out of the copies.  | Health pulled to the bottom of range, luck and speed at the top: a trickster, not a tank.     |
| Molten Titan         | magic       |   1050 |    72 |       200 |             38 |    90 |    7 | Erupts in a wide area-damage pulse that melts the surrounding terrain, forcing constant repositioning rather than a fixed stance.     | ⬜ Written as summer-flavoured champion; see the seasonal section for whether that is a hard rule. |
| The Rootbound Elder  | melee       |   1100 |    63 |       150 |             42 |    75 |    7 | Drains health from any village crop field within its reach to heal itself, so the fight drags on near farmland until the crops are cleared or it is lured away. | Slowest enemy in the whole document by design; it is rooted, almost literally.               |

## Scaling across the four seasons

The project glossary already states that season "drives crops, dungeon entrances, world boss strength and echo decay", and separately flags world boss strength-by-season as an open question in that same document.
That same uncertainty carries over to this bestiary, so the following is a proposal rather than a settled rule.

- Several entries above are written with a season in mind — Frost Pixie and Frost Warden for winter, Flame Wisp Elemental and Molten Titan for summer, Mire Elemental for a wet season — because the brief asks for enemies that "only appear in a given season".
- ⬜ Whether a seasonal enemy is **season-locked** (absent entirely outside its season) or merely **season-boosted** (present year-round, strengthened in its season) is not decided anywhere in the contract or the glossary.
  Both readings are plausible and they lead to different spawn-table work, so this needs a design decision before implementation.
- ⬜ Whether open-world enemy stats drift upward across a run the way `world boss` strength reportedly does is also unconfirmed.
  If it does, the simplest implementation is a small flat multiplier applied at the season boundary, on top of the tier numbers in this document, but no multiplier value is specified anywhere, so none is invented here.
- Crop-eating enemies (Cabbage Grub, Wild Boar, The Rootbound Elder) are written on the assumption that crops exist as a real per-village resource tied to season, which the glossary confirms, but the exact gold-loss formula when a crop row finishes is not specified, so none is invented here either.
- Dungeon and maze population is assumed to reuse the same tier tables above year-round, with the season only changing which seasonal entries are mixed in, rather than restatting the whole roster. ⬜ This is this document's own assumption, not a confirmed rule.

## Notes for balancing

**Likely overpowered.**
Ogre Warlord sits at the top of its range on both `health` (560) and `power` (42) simultaneously, which stacks two deviations in the same direction; pulling one of the two back toward the tier baseline would make it feel less like a champion wearing an elite's stat block.
Ironclad Warbeast does the same thing across three stats at once — `health`, `power` and `magic defence` all at the top of their ranges — which is defensible for a dungeon-end champion but should be the single most-tested entry in this document before it ships.

**Likely underpowered.**
Marsh Leech Swarm has the lowest `power` in the common tier and a slow-building payoff (draining mana into its own pool), so in a short fight it may simply read as a weak enemy rather than a scaling threat; it probably needs either a faster drain or a visible warning so players understand why ignoring it is a mistake.
Necromancer Acolyte's low health is meant to reward focus-fire, but if its skeleton summons arrive faster than a wizard can clear them, the intended "kill it fast" read inverts into "it is already too late" — this depends on a summon-cadence number this document does not have.

**Dependent on an undecided design question, and therefore not final:**
- ⬜ `mana pool` values throughout this document are this document's own proposal; the contract's tier table does not define them at all.
- ⬜ Shambling Corpse and Swamp Hydra Pup assume an elemental weakness system (fire kills one outright, fire heals the other) that is not confirmed to exist in the contract.
- ⬜ Death Knight's anti-heal strike is this document's own invention.
- ⬜ Shattered Colossus's split-on-half-health mechanic is this document's own invention, and the split pieces have no stats assigned yet.
- ⬜ Skeleton Hand's "bone pile" respawn source assumes a prop that is not defined elsewhere.
- ⬜ Season-lock versus season-boost for every seasonal entry (Frost Pixie, Frost Warden, Flame Wisp Elemental, Permafrost Wyrm, Molten Titan) is unresolved, and mirrors the same open question the project glossary already flags for world boss strength.
- ⬜ The gold-loss formula for crop-eating enemies (Cabbage Grub, Wild Boar, The Rootbound Elder) finishing a crop row is unresolved.
- ⬜ Regeneration rate for Troll Bruiser, and summon cadence for Necromancer Acolyte and The Hollow King, are named in Behaviour but have no authored numbers, since none exist in the contract to draw from.

**Volume.**
This document lists 46 enemies — 8 critter, 14 common, 12 veteran, 7 elite, 5 champion — intentionally more than a final roster, so the designer has material to cut rather than a minimal sample to pad out.
