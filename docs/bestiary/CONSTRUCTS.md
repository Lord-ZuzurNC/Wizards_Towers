# Constructs — Bestiary — Wizards Towers

Built guardians and the imps that mend them.
Shared rules — stats, tiers, special enemies, seasons — live in [`ENNEMIES.md`](../ENNEMIES.md).

## Enemies

| Name               | Tier    | Atk type | health | power | mana pool | magic defence | speed | luck | Behaviour                                                                                                                         | Notes                                                                           |
| ------------------ | ------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Tinker Imp         | common  | magic    |     70 |     8 |        32 |             5 |   100 |    2 | **Never attacks anything.** Repairs the nearest damaged construct enemy, so it must die before the construct it is mending.       | Harmless alone and the priority kill in any construct pack. It damages nothing. |
| Clockwork Sentinel | common  | melee    |     95 |     9 |        10 |             6 |    80 |    2 | Holds its ground and counters a melee strike with a short stun, punishing a wizard who trades blows instead of baiting its swing. | Magic defence at the top of range for a stationary corridor guard.              |
| Stone Golem Ward   | veteran | melee    |    250 |    18 |         5 |            15 |    75 |    3 | Barely moves from its post and leans on raw magic defence to outlast attackers, rewarding sustained damage over burst.            | Health and magic defence top of range, speed bottom: a chokepoint guard.        |
| Arc Construct      | veteran | magic    |    170 |    20 |        55 |            11 |   100 |    3 | Arcs its bolt to a second nearby target, making it far more dangerous alongside another enemy than alone.                         | Power at the top of range for the chain-damage read.                            |
| Shattered Colossus | elite   | melee    |    450 |    34 |        20 |            26 |    80 |    5 | **On death, breaks into two Tiny Shattered Colossus**, so killing it is the start of the fight rather than the end.               | The split happens at death, not at half health.                                 |

## Special enemies

These never spawn on their own; each appears only from the condition stated.

| Name                    | Atk type | health | power | mana pool | magic defence | speed | luck | Spawn condition                                                                 | Notes                                                                       |
| ----------------------- | -------- | -----: | ----: | --------: | ------------: | ----: | ---: | ------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| Tiny Shattered Colossus | melee    |    225 |    17 |        10 |            13 |    40 |    2 | Two appear when a **Shattered Colossus** dies, each at half its parent's stats. | Half of every parent stat. Very slow, so it can be left behind and ignored. |
