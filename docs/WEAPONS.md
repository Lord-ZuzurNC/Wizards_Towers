# Weapons — Wizards Towers

A weapon is what a wizard holds, not what a wizard casts.
There are four kinds: wand, staff, tome and relic, and this document lists them with the small stat bonuses each one grants.
A weapon is the one durable possession a wizard keeps.
When a wizard is away and their village or floor is raided, the weapon is never lost, only the runs and loot around it are at risk.
Which kinds a wizard may even equip is set by their wizard type, a starting template unlocked with reincarnation points, so no entry here assumes a wizard can hold all four.
⬜ The exact mapping from wizard type to permitted weapon kinds is not available to this document, so every kind below is written as if any wizard could reach it.
A later pass needs to annotate which types unlock which kinds.

## How to read this document

Every weapon lists a `Rarity` of common, rare or legendary, the same three-tier scale the rune tables use.
⬜ Whether weapon rarity lines up one-to-one with rune and Artifact rarity, or is an independent scale that merely borrows the same three words, is not settled.
This document assumes the latter.
`Stat bonuses` always lists the six stats in the fixed order health, power, mana pool, magic defence, speed, luck, and omits any stat a weapon does not touch.
A bonus is additive to the base stat and small: +3 to +15 for common and rare weapons, a little higher for legendary weapons.
Every legendary carries a real drawback, shown as a negative number in the same column.
`Special` holds anything that is not a flat stat bonus: cooldown and regeneration effects, conditional multipliers, and the handful of mechanics unique to a kind.
`Source` describes how the weapon is obtained without ever stating a gold price.
Gold prices for a purchase category rise with how many of that category a wizard already owns, so an absolute number here would be wrong within a single session.
`Notes` carries balance commentary and open questions.
A ⬜ marks anything this document could not resolve on its own.

## Wand

A wand is the lightest weapon a wizard can hold, and it shows in the numbers.
It rewards precision over endurance: bonuses that favour speed, luck and cooldown rather than raw health or defence.
A wand wizard clears quickly and kites well, and pays for it with little resilience if a fight goes wrong.

| Name                      | Rarity    | Stat bonuses                                | Special                                                                                                                     | Source                                                       | Notes                                                                                         |
| ------------------------- | --------- | ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------------------- |
| Hazel Wand                | common    | speed +5, luck +2                           | Cooldown on the wielder's spells shortens by a small fixed amount. ⬜ exact figure depends on an undecided cooldown formula. | Village shop, gold, price rises with each wand already owned | The first wand most new wizards can afford.                                                   |
| Quickglass Wand           | common    | luck +3                                     | +8% chance a Spark hit counts as a double strike, stacking with Spark's own chance.                                         | Early dungeon chest                                          | A pure luck pick for a Spark build.                                                           |
| Thornless Wand            | common    | health +4, magic defence +4                 | —                                                                                                                           | Village shop, gold, escalating                               | The defensive budget pick of the kind, and plain enough to flag as a possible underperformer. |
| Wand of the Steady Hand   | common    | power +3, speed +4                          | —                                                                                                                           | Village shop, gold, escalating                               | A balanced beginner option with no hook of its own.                                           |
| Snapwood Wand             | rare      | power +4, speed +8                          | Casting no longer interrupts the wielder's movement.                                                                        | Veteran enemy drop                                           | A quality-of-life convenience rather than a stat play.                                        |
| Hummingbird Wand          | rare      | speed +10, luck +4                          | The first spell cast after entering combat recasts once, instantly.                                                         | Veteran drop, floors 5-15                                    | Rewards reacting fast; does nothing once the fight is already underway.                       |
| Needle of the First Light | rare      | power +6, magic defence +3                  | +10% damage against critter- and common-tier enemies.                                                                       | Village shop, late-game stock, gold escalating               | A clearing tool, weak against anything bigger.                                                |
| Glassthorn Wand           | rare      | power +7, magic defence +3                  | +5% crit chance while the wielder has not been hit in the last few seconds.                                                 | Champion drop                                                | Rewards kiting and punishes being cornered.                                                   |
| Wandtip of the Hunt       | rare      | luck +6                                     | One extra loot roll on a confirmed kill, at most once per minute.                                                           | Maze treasure                                                | An economy wand, not a combat one.                                                            |
| Fulgur, the Sparking Wand | legendary | power +10, mana pool -10, luck +8, speed +5 | Every third cast double-strikes like Spark does, whatever the spell's actual element.                                       | Unique drop, world boss "Fulgurax" only                      | The drawback is the mana pool: a wand that hits above its weight and runs dry for it.         |
| Moonrise Wand             | legendary | magic defence -5, speed +12, luck +9        | The speed and luck bonuses double during winter.                                                                            | Unique drop, winter-season world boss only                   | Peaks for one season in four and is middling the rest of the run.                             |

## Staff

A staff is the heaviest weapon a wizard can hold, and it is built to be planted rather than danced with.
Its bonuses favour power, health, magic defence and mana pool, numbers that matter when a fight does not end quickly.
Most staves trade away speed for their size, a deliberate identity tax that applies well before the legendary tier's mandatory drawback.
A staff wizard wants to hold ground: a floor, a village gate, a chokepoint.

| Name                       | Rarity    | Stat bonuses                                       | Special                                                                                                                                              | Source                                               | Notes                                                                                                             |
| -------------------------- | --------- | -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Oak Staff                  | common    | power +6, health +5                                | —                                                                                                                                                    | Village shop, gold escalating                        | The default staff, with heavier base stats than any starter wand.                                                 |
| Bonegrip Staff             | common    | power +5, mana pool +5                             | —                                                                                                                                                    | Village shop, gold escalating                        | Plain and cheap, a candidate for an underperformer alongside Oak Staff.                                           |
| Staff of the Deep Root     | common    | mana pool +8, magic defence +6                     | —                                                                                                                                                    | Dungeon chest                                        | A mana-heavy support pick with no offensive hook.                                                                 |
| Staff of the Garrison      | common    | health +8, magic defence +6                        | +10% magic defence while the wielder is inside a village currently under raid. ⬜ assumes a wizard can be present during a raid on their own village. | Village shop, gold escalating                        | The first dedicated village-defence staff.                                                                        |
| Longstaff of the Monolith  | rare      | power +10, health +10, speed -5                    | +12% power while the wielder currently holds a floor.                                                                                                | Champion drop, inside the Monolith                   | The signature floor-holding staff; the speed loss is the kind's identity tax, not a legendary drawback.           |
| Granite Staff              | rare      | power +9, magic defence +7, speed -6               | The first hit of a cast ignores a small amount of the target's magic defence.                                                                        | Dungeon chest                                        | An anti-defence staff for a tough single target.                                                                  |
| Wintercrown Staff          | rare      | health +6, magic defence +8, speed -4              | Every stat bonus on this staff is 15% stronger during winter.                                                                                        | Winter-season world boss drop                        | A seasonal staff, honestly dead weight for three seasons out of four.                                             |
| Staff of Siege             | rare      | health +12, magic defence +9, speed -8             | Incoming damage reduced by 10% while the wielder is defending a village under raid.                                                                  | Maze treasure                                        | The premier anti-raid staff; its drawback is already the speed loss.                                              |
| Staff of Echoes Broken     | rare      | power +8, magic defence +4, luck +4                | +15% damage against echoes specifically.                                                                                                             | Reward for taking a floor from another wizard        | A raider's staff that does nothing in ordinary open-world play.                                                   |
| Staff of the World-Walker  | legendary | power +14, mana pool +12, speed -10                | Mana regeneration +20% while the wielder is stationary.                                                                                              | Unique world boss drop                               | The drawback is the speed loss, severe enough to make the wielder an easy target in the open.                     |
| Pillar of the First Wizard | legendary | power +15, health +14, magic defence +9, speed -12 | Mana pool +10% for every village the wielder owns. ⬜ whether this scaling needs a hard cap is undecided.                                             | Single unique drop, the highest-tier world boss only | The strongest staff in the game by raw numbers, and realistically unreachable without an existing village empire. |

## Tome

A tome is not primarily a combat weapon, and its table reflects that.
Its bonuses touch mana pool, mana regeneration and the mechanics around how a spell gets built and kept, rather than raw offence.
Several entries below reference the Grimoire and the cost bar, both of which this document treats as existing systems without specifying their exact rules.
Where that matters, it is flagged.

| Name                                    | Rarity    | Stat bonuses                             | Special                                                                                                                                              | Source                        | Notes                                                                                                                                          |
| --------------------------------------- | --------- | ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Primer, the First Tome                  | common    | mana pool +8                             | +1 saved spell slot in the Grimoire. ⬜ the Grimoire's saved-slot mechanic is not defined in the material available here.                             | Starting quest reward         | A near-universal pick for any tome-capable wizard type.                                                                                        |
| Pocket Primer                           | common    | speed +3, mana pool +4                   | —                                                                                                                                                    | Village shop, gold escalating | Deliberately mild, meant to pair with a wand rather than compete with a staff; a likely underperformer.                                        |
| Tome of Lesser Weights                  | common    | magic defence +4                         | The wielder's cost bar gains a small amount of extra headroom, enough for one additional point of rune weight.                                       | Village shop, gold escalating | A direct, modest version of the cost-bar lever.                                                                                                |
| Scrivener's Tome                        | common    | luck +4                                  | A salvaged rune has a higher chance to return at its original rarity instead of dropping a tier. ⬜ assumes a rune salvage/disassembly system exists. | Maze reward                   | An economy tome.                                                                                                                               |
| Tome of Lesser Weights, Second Printing | rare      | mana pool +10, magic defence +5          | The same cost-bar headroom as the common version, larger.                                                                                            | Dungeon chest                 | Watch for this entry and its common counterpart competing rather than differentiating.                                                         |
| Tome of Mana Unbound                    | rare      | mana pool +12                            | Mana regeneration +15%.                                                                                                                              | Champion drop                 | A pure sustain tome with no offensive hook of its own.                                                                                         |
| Tome of the Patient Scholar             | rare      | mana pool +6, magic defence +6           | Mana pool regeneration +10% while the wielder has not cast anything for a few seconds.                                                               | Maze treasure                 | Mirrors the Patience rune's logic in weapon form.                                                                                              |
| Annotated Index                         | rare      | mana pool +6, luck +5                    | The Grimoire gains one extra saved loadout for quick-swapping between two spells. ⬜ a loadout-swap mechanic is assumed.                              | Village shop, gold escalating | A quality-of-life tome rather than a combat one.                                                                                               |
| Grand Grimoire                          | legendary | mana pool +15, magic defence +8, luck -5 | +2 saved spell slots in the Grimoire, plus cost-bar headroom equal to the rare tome above, stacked.                                                  | Unique world boss drop        | The drawback is luck. ⬜ the saved-slot count across all tomes needs a hard cap from the Grimoire system itself, outside this document's scope. |

## Relic

A relic is the strange one: its bonuses are small but frequently conditional, tied to gold carried, villages owned, season, or whether the target is an echo.
A relic wizard is making a bet about their own situation at the moment of a fight, not about their build in general.
Several relics carry an honest two-way swing rather than a flat bonus, which is the point of the kind.

| Name                  | Rarity    | Stat bonuses                      | Special                                                                                                             | Source                                                 | Notes                                                                                                                |
| --------------------- | --------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| Pauper's Ring         | common    | luck +2, speed +2                 | All bonuses on this relic double while the wielder owns zero villages.                                              | Always available, starting village shop                | A deliberately humble relic for the most vulnerable stage of a run.                                                  |
| Coinbound Charm       | common    | luck +3                           | Power +1 for every notable amount of gold currently carried, up to a small cap.                                     | Village shop, gold escalating                          | Mirrors the Greed rune's logic; makes a rich wizard hit harder and a juicier raid target.                            |
| Beggar's Locket       | common    | speed +4                          | Magic defence bonus increases the fewer villages the wielder owns.                                                  | Quest reward, offered to a wizard in a losing position | A comeback relic, mirroring the Humility rune; the trigger condition needs a concrete threshold to be reliable.      |
| Thaw-Iron Band        | common    | magic defence +5                  | Magic defence +8% during winter, -4% during summer.                                                                 | Seasonal village vendor                                | An honest two-way seasonal swing rather than a flat bonus.                                                           |
| Shard of the Unraided | rare      | health +10                        | While the wielder is offline, their village's defenders gain a bonus to magic defence against the raid.             | Maze treasure                                          | ⬜ whether a wizard's personal gear can buff defenders while that wizard is absent is a genuine open design question. |
| Sunstone of Radiance  | rare      | power +7                          | +15% damage against echoes specifically.                                                                            | Monolith floor-clear reward                            | An anti-echo relic for floor raiders, weak everywhere else.                                                          |
| Harvestcount Seal     | rare      | health +6, luck +3                | +1 to every stat bonus on this relic for every village the wielder owns, up to three villages.                      | Quest reward                                           | A direct implementation of scaling with villages owned, with its own cap already built in.                           |
| Widow's Ichor Vial    | legendary | health -15, power +12             | Returns a portion of damage dealt to the caster as health.                                                          | Unique world boss drop                                 | Mirrors the Ichor rune's risk; a glass-cannon relic for a confident player.                                          |
| The Unspent Hour      | legendary | mana pool -12, speed +10, luck +8 | Once per run, the wielder cannot die to a hit that would otherwise kill, as if the last few seconds never happened. | Single unique maze reward, one per world               | ⬜ whether this rollback effect is even implementable is an engineering question, not just a balance one.             |

## Choosing between kinds

A wand suits a wizard clearing quickly through common ground, kiting rather than tanking, and leaning on luck and cooldown rather than raw numbers.
A staff suits a wizard who intends to stop and hold something: a floor, a village gate, a chokepoint, paying for it in speed.
A tome suits a wizard mid-build, assembling heavier spells and wanting the mana and cost-bar room to actually cast them, or one who values Grimoire flexibility over combat stats.
A relic suits a wizard willing to read their own situation and bet on it: how much gold they are carrying, how many villages they own, which season it is, or whether the target in front of them is an echo.
None of the four replaces a build.
Every bonus in this document is small, and a wizard's runes and Artifacts decide the fight; the weapon only nudges it.

## Notes for balancing

**Likely overpowered.**
Pillar of the First Wizard already sits at the top of the legendary range before its villages-owned scaling is even counted, and that scaling is currently uncapped.
Grand Grimoire stacks two separate tome advantages, extra saved slots and cost-bar headroom, onto one item, which removes any reason to pick a narrower tome at the same rarity; consider splitting the two effects across two items.
Fulgur's guaranteed double-strike on every third cast, regardless of element, risks making its mana pool drawback irrelevant once mana regeneration from any other source covers it.

**Likely underpowered.**
Thornless Wand, Wand of the Steady Hand, Bonegrip Staff, Oak Staff and Pocket Primer carry no Special effect at all, only flat numbers.
Each is likely to be skipped once anything with a hook exists at the same rarity, and each is a candidate for either a small hook or removal.
Beggar's Locket's trigger, "a losing position," is vague enough that it may rarely fire in practice and needs a concrete threshold.

**Dependent on an undecided design question.**
The cooldown formula is undecided, which affects Hazel Wand and any future cooldown-reduction item.
The Grimoire's saved-slot mechanic and its cap are undecided, which affects Primer, Annotated Index and Grand Grimoire.
The cost-bar headroom's exact numeric scale is undecided, which affects both Tome of Lesser Weights entries.
Whether a rune salvage or disassembly system exists at all is undecided, which affects Scrivener's Tome.
Whether a wizard's personal gear can buff their village's defenders while that wizard is offline is undecided, which affects Shard of the Unraided.
Whether a wizard can be physically present during a raid on their own village is undecided, which affects Staff of the Garrison.
Whether the villages-owned scaling on Pillar of the First Wizard needs a hard cap is undecided.
Whether a once-per-run death-rollback effect, as on The Unspent Hour, is technically implementable is an open engineering question, not only a balance one.
The wizard-type-to-weapon-kind mapping table is undecided and was not available while writing this document, even though every section above depends on it existing.
