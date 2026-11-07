# Undead — Bestiary — Wizards Towers

The dead that will not stay down: corpses, wights, liches and the bones they raise.
Shared rules — stats, tiers, special enemies, seasons — live in [`ENNEMIES.md`](../ENNEMIES.md).

## Enemies

| Name                | Tier     | Atk type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                                | Notes                                                                                          |
| ------------------- | -------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | ---------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Shambling Corpse    | common   | melee    |    100 |     9 |         5 |             6 |    76 |    2 | Shrugs off ordinary hits but **collapses outright to fire damage**, punishing a wizard with no answer to it.                             | Health and magic defence top of range, speed bottom. The fire weakness is its own specificity. |
| Grave Moth          | common   | magic    |     65 |     9 |        25 |             4 |   110 |    2 | Drains health at range over time and flutters straight out of melee reach the instant a wizard closes in.                                | Speed pushed up to make "cannot be melee'd down" land.                                         |
| Necromancer Acolyte | veteran  | magic    |    160 |    17 |        85 |            11 |    95 |    3 | Raises a Skeleton Hand every time its own cast completes, so it must die before its retinue grows out of hand.                           | Summon cadence on its own sheet. Health at the bottom of range: a glass cannon.                |
| Barrow Wight        | veteran  | magic    |    190 |    18 |        60 |            13 |    90 |    3 | Drains a slice of the wizard's mana pool on every hit, crippling a low-level wizard far more than a late one.                            | Dangerous early, trivial later, since mana pool grows with level.                              |
| Lich Apprentice     | elite    | magic    |    400 |    38 |       150 |            20 |   100 |    5 | Channels a health-drain beam that can be interrupted by breaking line of sight, but ticks heavily left uninterrupted.                    | Power pushed up, health pulled down: a glass-cannon caster.                                    |
| Death Knight        | elite    | melee    |    500 |    36 |        30 |            27 |   100 |    4 | Strikes rapidly and repeatedly. **Any hit interrupts a heal in progress**, so its cadence alone keeps a wizard from healing.             | Mildly anti-heal as a consequence of its speed, with no anti-heal mechanic behind it.          |
| The Hollow King     | champion | magic    |   1000 |    65 |       250 |            45 |    95 |    8 | **Summons a wave of Skeleton Guards** whenever its own health crosses each quarter threshold, demanding crowd control over a burst race. | Wave size and cap live on its own sheet.                                                       |

## Special enemies

These never spawn on their own; each appears only from the condition stated.

| Name           | Atk type | health | power | mana pool | magic defence | speed | luck | Spawn condition                                                                              | Notes                                                                                             |
| -------------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| Bone Pile      | —        |     40 |     0 |         0 |             2 |     0 |    1 | **30 % chance to appear where any enemy dies.** A Skeleton Hand's death never creates one.   | Cannot attack and cannot move. It exists to produce Skeleton Hands, and destroying it stops them. |
| Skeleton Hand  | melee    |     32 |     4 |         6 |             2 |    95 |    1 | Produced by a **Bone Pile**, or raised by a **Necromancer Acolyte** on each completed cast.  | Crawls and claws at ankles. Endless until its source is destroyed.                                |
| Skeleton Guard | melee    |     80 |     9 |         5 |             5 |   100 |    2 | Summoned by **The Hollow King** in a wave, each time its health crosses a quarter threshold. | Common-tier stats. Dangerous as a wave, trivial individually.                                     |
