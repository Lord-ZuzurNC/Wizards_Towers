# Weapons — Wizards Towers

A weapon is what a wizard holds, not what a wizard casts.
There are four kinds: wand, staff, tome and relic, and this document lists them with the small stat bonuses each one grants.
A weapon is the one durable possession a wizard keeps.
When a wizard is away and their village or floor is raided, the weapon is never lost, only the runs and loot around it are at risk.

**A wizard may use exactly one kind, and no other.**
Which kind is fixed by their **wizard type**, the starting template unlocked with reincarnation points.
A Magus can never swing a wand, however good the wand is.

That makes three quarters of this document unusable loot for any given wizard, and the loot still has value.
A weapon of the wrong kind can be **sold to a shop for gold**, or **traded to another wizard** who can actually hold it.
So a legendary wand dropped by a world boss is worth something to a Magus: it is either income or leverage over whoever wants it.

## Wizard types

Four types exist, one per weapon kind.
The type is chosen at reincarnation and fixed for the whole run.

| Type         | Weapon | Identity                                                                                    |
| ------------ | ------ | ------------------------------------------------------------------------------------------- |
| **Sorcerer** | wand   | Fast and precise. Clears quickly, kites well, breaks if cornered. It is the starter wizard. |
| **Magus**    | staff  | Heavy and immovable. Holds a floor, a gate, a chokepoint, and pays for it in speed.         |
| **Arcanist** | tome   | A scholar of the craft. Lives on mana, cost-bar headroom and Grimoire capacity.             |
| **Oracle**   | relic  | Reads the situation and bets on it: gold carried, villages held, the season, the target.    |

**None of these four is called a wizard, deliberately.**
`wizard` is the word for any player character regardless of type, so it cannot also name one type out of four.

## How to read this document

Every weapon lists a `Rarity` of common, rare or legendary — **the same single scale runes and Artifacts use**, not a parallel ladder borrowing the same three words.
`Stat bonuses` always lists the six stats in the fixed order health, power, mana pool, magic defence, speed, luck, and omits any stat a weapon does not touch.
A bonus is additive to the base stat and small: +3 to +15 for common and rare weapons, a little higher for legendary weapons.
Every legendary carries a real drawback, shown as a negative number in the same column.
`Special` holds anything that is not a flat stat bonus: cooldown and regeneration effects, conditional multipliers, and the handful of mechanics unique to a kind.
`Source` describes how the weapon is obtained without ever stating a gold price.
Gold prices for a purchase category rise with how many of that category a wizard already owns, so an absolute number here would be wrong within a single session.
`Notes` carries balance commentary and open questions.
A ⬜ marks anything this document could not resolve on its own.

Several tomes reference **rune weight**, which is now a ratified term: the cost pressure a rune contributes to a spell, scaled by rarity, and the primary input to the computed mana cost.
See `weight` in `GLOSSARY.md` and the weight columns throughout `RUNES.md`.

## Wand

A wand is the lightest weapon a wizard can hold, and it shows in the numbers.
It rewards precision over endurance: bonuses that favour speed, luck and cooldown rather than raw health or defence.
A wand wizard clears quickly and kites well, and pays for it with little resilience if a fight goes wrong.

| Name                      | Rarity    | Stat bonuses                                | Special                                                                               | Source                                                       | Notes                                                                                  |
| ------------------------- | --------- | ------------------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| Hazel Wand                | common    | speed +5, luck +2                           | Cooldown on the wielder's spells shortens by a small fixed amount.                    | Village shop, gold, price rises with each wand already owned | The first wand most new wizards can afford. Exact figure follows the cooldown formula. |
| Quickglass Wand           | common    | luck +3                                     | +8% chance a Spark hit counts as a double strike, stacking with Spark's own chance.   | Early dungeon chest                                          | A pure luck pick for a Spark build.                                                    |
| Thornless Wand            | common    | health +4, magic defence +4                 | —                                                                                     | Village shop, gold, escalating                               | The defensive budget pick of the kind. Plain by design, and meant to be outgrown.      |
| Wand of the Steady Hand   | common    | power +3, speed +4                          | —                                                                                     | Village shop, gold, escalating                               | A balanced beginner option with no hook of its own, by design.                         |
| Snapwood Wand             | rare      | power +4, speed +8                          | Casting no longer interrupts the wielder's movement.                                  | Veteran enemy drop                                           | A quality-of-life convenience rather than a stat play.                                 |
| Hummingbird Wand          | rare      | speed +10, luck +4                          | The first spell cast after entering combat recasts once, instantly.                   | Veteran drop, floors 5-15                                    | Rewards reacting fast; does nothing once the fight is already underway.                |
| Needle of the First Light | rare      | power +6, magic defence +3                  | +10% damage against critter- and common-tier enemies.                                 | Village shop, late-game stock, gold escalating               | A clearing tool, weak against anything bigger.                                         |
| Glassthorn Wand           | rare      | power +7, magic defence +3                  | +5% crit chance while the wielder has not been hit in the last few seconds.           | Champion drop                                                | Rewards kiting and punishes being cornered.                                            |
| Wandtip of the Hunt       | rare      | luck +6                                     | One extra loot roll on a confirmed kill, at most once per minute.                     | Maze treasure                                                | An economy wand, not a combat one.                                                     |
| Fulgur, the Sparking Wand | legendary | power +10, mana pool -10, luck +8, speed +5 | Every third cast double-strikes like Spark does, whatever the spell's actual element. | Unique drop, world boss "Fulgurax" only                      | The drawback is the mana pool: a wand that hits above its weight and runs dry for it.  |
| Moonrise Wand             | legendary | magic defence -5, speed +12, luck +9        | The speed and luck bonuses double during winter.                                      | Unique drop, winter-season world boss only                   | Peaks for one season in four and is middling the rest of the run.                      |

## Staff

A staff is the heaviest weapon a wizard can hold, and it is built to be planted rather than danced with.
Its bonuses favour power, health, magic defence and mana pool, numbers that matter when a fight does not end quickly.
Most staves trade away speed for their size, a deliberate identity tax that applies well before the legendary tier's mandatory drawback.
A staff wizard wants to hold ground: a floor, a village gate, a chokepoint.

| Name                       | Rarity    | Stat bonuses                                       | Special                                                                                  | Source                                               | Notes                                                                                                          |
| -------------------------- | --------- | -------------------------------------------------- | ---------------------------------------------------------------------------------------- | ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Oak Staff                  | common    | power +6, health +5                                | —                                                                                        | Village shop, gold escalating                        | The default staff, with heavier base stats than any starter wand.                                              |
| Bonegrip Staff             | common    | power +5, mana pool +5                             | —                                                                                        | Village shop, gold escalating                        | Plain and cheap by design, like Oak Staff.                                                                     |
| Staff of the Deep Root     | common    | mana pool +8, magic defence +6                     | —                                                                                        | Dungeon chest                                        | A mana-heavy support pick with no offensive hook.                                                              |
| Staff of the Garrison      | common    | health +8, magic defence +6                        | +10% magic defence while the wielder is near a village currently under raid.             | Village shop, gold escalating                        | A wizard receives a **raid alert** and can travel to defend in person, so this is never dead weight.           |
| Longstaff of the Monolith  | rare      | power +10, health +10, speed -5                    | +12% power while the wielder currently holds a floor.                                    | Champion drop, inside the Monolith                   | The signature floor-holding staff; the speed loss is the kind's identity tax, not a legendary drawback.        |
| Granite Staff              | rare      | power +9, magic defence +7, speed -6               | The first hit of a cast ignores a small amount of the target's magic defence.            | Dungeon chest                                        | An anti-defence staff for a tough single target.                                                               |
| Wintercrown Staff          | rare      | health +6, magic defence +8, speed -4              | Every stat bonus on this staff is 15% stronger during winter.                            | Winter-season world boss drop                        | A seasonal staff, honestly dead weight for three seasons out of four.                                          |
| Staff of Siege             | rare      | health +12, magic defence +9, speed -8             | Incoming damage reduced by 10% while the wielder is defending a village under raid.      | Maze treasure                                        | The premier anti-raid staff; its drawback is already the speed loss.                                           |
| Staff of Echoes Broken     | rare      | power +8, magic defence +4, luck +4                | +15% damage against echoes specifically.                                                 | Reward for taking a floor from another wizard        | A raider's staff that does nothing in ordinary open-world play.                                                |
| Staff of the World-Walker  | legendary | power +14, mana pool +12, speed -10                | Mana regeneration +20% while the wielder is stationary.                                  | Unique world boss drop                               | The drawback is the speed loss, severe enough to make the wielder an easy target in the open.                  |
| Pillar of the First Wizard | legendary | power +15, health +14, magic defence +9, speed -12 | Mana pool +10% for every village the wielder owns, **capped at five villages for +50%**. | Single unique drop, the highest-tier world boss only | The strongest staff in the game by raw numbers. The cap stops a village empire from compounding without limit. |

## Tome

A tome is not primarily a combat weapon, and its table reflects that.
Its bonuses touch mana pool, mana regeneration and the mechanics around how a spell gets built and kept, rather than raw offence.
It is the kind that interacts most directly with **rune weight**, the **weight bar** and **Grimoire positions**, so it is also the kind most exposed to changes in those systems.

| Name                        | Rarity    | Stat bonuses                              | Special                                                                                                                           | Source                        | Notes                                                                                                                                      |
| --------------------------- | --------- | ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Primer, the First Tome      | common    | mana pool +8                              | +1 Grimoire position.                                                                                                             | Starting quest reward         | A near-universal pick for any tome wizard.                                                                                                 |
| Pocket Primer               | common    | speed +3, mana pool +4                    | —                                                                                                                                 | Village shop, gold escalating | Deliberately mild, and meant to be outgrown.                                                                                               |
| Tome of Lesser Weights      | common    | magic defence +4                          | The wielder's **weight bar** gains extra headroom worth one point of rune **weight**.                                             | Village shop, gold escalating | The plainest version of the headroom lever.                                                                                                |
| Merchant's Ledger           | common    | mana pool +4, luck +3                     | Rune prices at NPC villages are reduced for the wielder.                                                                          | Village shop, gold escalating | An economy tome that repays itself slowly. Worth exactly as much as the wizard's rune-buying habit.                                        |
| Tome made of feathers       | rare      | mana pool +10, magic defence +5           | Grants **+1 weight-bar headroom to every Grimoire position the wielder holds**, not just one.                                     | Dungeon chest                 | Scales with the Grimoire instead of being a larger common. Earns its tier on a wizard with several spells.                                 |
| Tome of Mana Unbound        | rare      | mana pool +12                             | Mana regeneration +15%.                                                                                                           | Champion drop                 | A pure sustain tome with no offensive hook of its own.                                                                                     |
| Tome of the Patient Scholar | rare      | mana pool +6, magic defence +6            | Mana regeneration +10% while the wielder has not cast anything for a few seconds.                                                 | Maze treasure                 | Mirrors the **Patience** Effect rune, which still exists — not the deleted `Patient` Duration rune. See the notes.                         |
| The Marginal Note           | rare      | mana pool +6, luck +5                     | Once per fight, the wielder may recast their last spell at no mana cost.                                                          | Village shop, gold escalating | Rewards a wizard built around one expensive spell rather than several cheap ones.                                                          |
| Codex of the Second Hand    | rare      | mana pool +9, power +4                    | The rune in the wielder's `Effect2` slot acts at +20% strength. `Effect1` is unaffected.                                          | Champion drop, floors 20-39   | Pays off only for a wizard who fills both Effect slots, which needs level 2 and a deliberate build.                                        |
| Grand Grimoire              | legendary | mana pool +15, magic defence +8, luck -5  | +2 Grimoire positions, plus cost-bar headroom equal to the rare tome above, stacked.                                              | Unique world boss drop        | The drawback is luck. +2 positions is the ratified maximum any single tome may grant.                                                      |
| The Unwritten Page          | legendary | mana pool +18, magic defence +6, speed -8 | In one spell of the wielder's choosing, the heaviest single rune counts at half its **weight** when the spell's cost is computed. | Unique maze reward            | The drawback is speed. Bounded on purpose: it discounts one rune, never a whole spell, so "no spell is both cheap and strong" still holds. |

## Relic

A relic is the strange one: its bonuses are small but frequently conditional, tied to gold carried, villages owned, season, or whether the target is an echo.
Relics are worn rather than wielded — rings, charms, lockets, bands, sashes and masks — which is why a relic wizard's silhouette never tells you what they can do.
A relic wizard is making a bet about their own situation at the moment of a fight, not about their build in general.
Several relics carry an honest two-way swing rather than a flat bonus, which is the point of the kind.

| Name                   | Rarity    | Stat bonuses                      | Special                                                                                                                                                                                                                                                                                             | Source                                                 | Notes                                                                                                                    |
| ---------------------- | --------- | --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| Pauper's Ring          | common    | luck +2, speed +2                 | All bonuses on this relic double while the wielder owns zero villages.                                                                                                                                                                                                                              | Always available, starting village shop                | Zero villages is genuinely reachable, unlike zero floors, so this trigger is sound.                                      |
| Coinbound Charm        | common    | luck +3                           | Power +1 for every notable amount of gold currently carried, up to a small cap.                                                                                                                                                                                                                     | Village shop, gold escalating                          | Mirrors the Greed rune's logic; makes a rich wizard hit harder and a juicier raid target.                                |
| Beggar's Locket        | common    | speed +4                          | Magic defence bonus increases the fewer villages the wielder owns, and doubles outright while the wielder is in a **losing position**.                                                                                                                                                              | Quest reward, offered to a wizard in a losing position | A comeback relic, mirroring the Humility rune.                                                                           |
| Thaw-Iron Band         | common    | magic defence +5                  | Magic defence +8% during winter, -4% during summer.                                                                                                                                                                                                                                                 | Seasonal village vendor                                | An honest two-way seasonal swing rather than a flat bonus.                                                               |
| Shard of the Unraided  | rare      | health +10                        | While the wielder is offline, their village's defenders gain a bonus to magic defence against the raid.                                                                                                                                                                                             | Maze treasure                                          | Ratified: personal gear **can** buff village defenders while its owner is absent.                                        |
| Sunstone of Radiance   | rare      | power +7                          | +15% damage against echoes specifically.                                                                                                                                                                                                                                                            | Monolith floor-clear reward                            | An anti-echo relic for floor raiders, weak everywhere else.                                                              |
| Harvestcount Seal      | rare      | health +6, luck +3                | +1 to every stat bonus on this relic for every village the wielder owns, up to three villages.                                                                                                                                                                                                      | Quest reward                                           | A direct implementation of scaling with villages owned, with its own cap already built in.                               |
| Sash of the Tithe      | rare      | health +8, luck +4                | Gold income from the wielder's villages continues at full rate while the wielder is inside the Monolith.                                                                                                                                                                                            | Quest reward, issued at the Lobby                      | Resolves a real tension: climbing and earning otherwise compete for the same hours.                                      |
| Mask of the Quiet Name | rare      | magic defence +5, speed +6        | The wielder's name is hidden from the North Wall while worn, though their floors stay held.                                                                                                                                                                                                         | Maze treasure                                          | Buys obscurity, not power. Strongest for a wizard high enough to be a target but not strong enough to survive being one. |
| Widow's Ichor Vial     | legendary | health -15, power +12             | Returns a portion of damage dealt to the caster as health.                                                                                                                                                                                                                                          | Unique world boss drop                                 | Mirrors the Ichor rune's risk; a glass-cannon relic for a confident player.                                              |
| The Unspent Hour       | legendary | mana pool -12, speed +10, luck +8 | Once per run, a hit that would kill the wielder instead turns them invisible and intangible for **20 seconds**, during which they can do nothing at all. When it ends they return with **10% of their health** and may act again. The relic's special effect is then spent for the rest of the run. | Single unique maze reward, one per world               | No rollback and no rewind: a forced, helpless pause followed by a bad position. Buys one life, and charges for it.       |

## Choosing between kinds

A wizard does not choose, so this section is about understanding what your wizard type gave you rather than shopping between four options.

A wand suits a wizard clearing quickly through common ground, kiting rather than tanking, and leaning on luck and cooldown rather than raw numbers.
A staff suits a wizard who intends to stop and hold something: a floor, a village gate, a chokepoint, paying for it in speed.
A tome suits a wizard mid-build, assembling heavier spells and wanting the mana and cost-bar room to actually cast them, or one who values Grimoire flexibility over combat stats.
A relic suits a wizard willing to read their own situation and bet on it: how much gold they are carrying, how many villages they own, which season it is, or whether the target in front of them is an echo.

None of the four replaces a build.
Every bonus in this document is small, and a wizard's runes and Artifacts decide the fight; the weapon only nudges it.

## Weapon counts

| Kind      | common | rare | legendary | Total  |
| --------- | ------ | ---- | --------- | ------ |
| Wand      | 4      | 5    | 2         | 11     |
| Staff     | 4      | 5    | 2         | 11     |
| Tome      | 4      | 5    | 2         | 11     |
| Relic     | 4      | 5    | 2         | 11     |
| **Total** |        |      |           | **44** |

## Notes for balancing

**A plain common weapon being discarded beside a rare one is expected, not a defect.**
Thornless Wand, Wand of the Steady Hand, Oak Staff, Bonegrip Staff, Staff of the Deep Root and Pocket Primer carry no Special effect at all.
They are the floor of the scale, and a wizard is supposed to outgrow them.

⚠️ **`Grand Grimoire` stacks two tome advantages onto one item.**
It grants the maximum of +2 Grimoire positions **and** the largest cost-bar headroom in the document.
That removes most of the reason to pick a narrower legendary tome.
Splitting its two effects across two items is the cleaner fix if it proves dominant.

⚠️ **`Tome of Lesser Weights` and `Tome made of feathers` now differ in kind, not in size.**
The common grants one point of headroom; the rare grants a point to **every** Grimoire position.
Watch that the rare does not become mandatory for any wizard holding three or more spells.

⬜ **`Beggar's Locket`'s doubled bonus needs its trigger ratified beyond autumn.**
A **losing position** is defined as holding **no village and no floor from autumn onward**.
Before autumn a wizard can legitimately own nothing without losing, so the check cannot fire in spring or summer.
