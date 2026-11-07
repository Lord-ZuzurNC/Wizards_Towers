# Humanoids — Bestiary — Wizards Towers

Goblins, bandits, orcs, trolls and ogres: the camps and warbands of the open world.
Shared rules — stats, tiers, special enemies, seasons — live in [`ENNEMIES.md`](../ENNEMIES.md).

## Enemies

| Name               | Tier    | Atk type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                       | Notes                                                                       |
| ------------------ | ------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | ------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| Goblin Skirmisher  | common  | melee    |     65 |    10 |         8 |             4 |   122 |    2 | Lands one hit then retreats to range, punishing a wizard with no way to close distance quickly.                                 | Health near the bottom of its range to pay for the hit-and-run pattern.     |
| Goblin Firethrower | common  | magic    |     70 |    11 |        30 |             4 |    95 |    2 | Lobs a flaming flask that scorches the ground, so the fight itself damages anyone standing on the burn afterwards.              | Power at the top of its range.                                              |
| Bandit Raider      | common  | melee    |     85 |    10 |        10 |             5 |   108 |    2 | Sounds a horn on first taking damage and runs for its camp, returning with two more raiders if not killed within a few seconds. | The signature "flee and fetch reinforcements" enemy of this tier.           |
| Bandit Cutpurse    | common  | melee    |     62 |     8 |         6 |             4 |   124 |    2 | Tries to pickpocket the wizard's gold and flee, and only fights back if cornered first.                                         | Harmless until provoked; the cost of ignoring it is gold, not health.       |
| Orc Berserker      | veteran | melee    |    180 |    22 |        10 |            10 |   110 |    3 | Attacks faster as its own health drops, so burst damage beats a slow grind against it.                                          | Power at the top of its range to pay for the self-enrage.                   |
| Orc Shaman         | veteran | magic    |    170 |    19 |        70 |            12 |    95 |    3 | Shields the nearest ally before attacking, so killing it first denies the whole pack its damage reduction.                      | Support-first priority target.                                              |
| Troll Bruiser      | veteran | melee    |    240 |    20 |         8 |            15 |    80 |    3 | Regenerates a slice of health every few seconds unless a wizard's burst outpaces the regeneration.                              | Regeneration rate to be tuned later. Health and magic defence top of range. |
| Ogre Warlord       | elite   | melee    |    560 |    42 |        15 |            18 |    85 |    4 | Telegraphs a long wind-up before each swing, so the fight is about punishing that window rather than trading hits.              | Health and power both at the top of range; a likely overtune.               |
