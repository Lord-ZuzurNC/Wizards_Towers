# Weapons — Wizards Towers

A weapon is what a wizard holds, not what a wizard casts.
There are four kinds: wand, staff, tome and relic, and this document lists them with the small stat bonuses each one grants.
A weapon is the one durable possession a wizard keeps.
When a wizard is away and their village or floor is raided, the weapon is never lost, only the runs and loot around it are at risk.

**A wizard may use exactly one kind, and no other.**
Which kind is fixed by their wizard type, the starting template unlocked with reincarnation points.
A staff wizard can never swing a wand, however good the wand is.

That makes three quarters of this document unusable loot for any given wizard, and the loot still has value.
A weapon of the wrong kind can be **sold to a shop for gold**, or **traded to another wizard** who can actually hold it.
So a legendary wand dropped by a world boss is worth something to a staff wizard: it is either income or leverage over whoever wants it.

⚠️ Wizard-to-wizard trading is named here for the first time and is not yet in `GLOSSARY.md`.
It deserves a ratified definition, because a trade is the only consensual transfer of value between wizards in a game otherwise built on taking things by force.

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

Several tomes reference **rune weight**, which is now a ratified term: the cost pressure a rune contributes to a spell, scaled by rarity, and the primary input to the computed mana cost.
See `weight` in `GLOSSARY.md` and the weight columns throughout `RUNES.md`.

## Wand

A wand is the lightest weapon a wizard can hold, and it shows in the numbers.
It rewards precision over endurance: bonuses that favour speed, luck and cooldown rather than raw health or defence.
A wand wizard clears quickly and kites well, and pays for it with little resilience if a fight goes wrong.

| Name                      | Rarity    | Stat bonuses                                | Special                                                                                                                     | Source                                                       | Notes                                                                                         |
| ------------------------- | --------- | ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------------------------------------------- |
| Hazel Wand                | common    | speed +5, luck +2                           | Cooldown on the wielder's spells shortens by a small fixed amount. ⬜ exact figure depends on an undecided cooldown formula. | Village shop, gold, price rises with each wand already owned | The first wand most new wizards can afford.                                                   |
| Quickglass Wand           | common    | luck +3                                     | +8% chance a Spark hit counts as a double strike, stacking with Spark's own chance.                                         | Early dungeon chest                                          | A pure luck pick for a Spark build.                                                           |
| Thornless Wand            | common    | health +4, magic defence +4                 | —                                                                                                                           | Village shop, gold, escalating                               | The defensive budget pick of the kind. Plain by design, and meant to be outgrown.             |
| Wand of the Steady Hand   | common    | power +3, speed +4                          | —                                                                                                                           | Village shop, gold, escalating                               | A balanced beginner option with no hook of its own, by design.                                |
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

| Name                       | Rarity    | Stat bonuses                                       | Special                                                                                                                                            | Source                                               | Notes                                                                                                             |
| -------------------------- | --------- | -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Oak Staff                  | common    | power +6, health +5                                | —                                                                                                                                                  | Village shop, gold escalating                        | The default staff, with heavier base stats than any starter wand.                                                 |
| Bonegrip Staff             | common    | power +5, mana pool +5                             | —                                                                                                                                                  | Village shop, gold escalating                        | Plain and cheap by design, like Oak Staff.                                                                        |
| Staff of the Deep Root     | common    | mana pool +8, magic defence +6                     | —                                                                                                                                                  | Dungeon chest                                        | A mana-heavy support pick with no offensive hook.                                                                 |
| Staff of the Garrison      | common    | health +8, magic defence +6                        | +10% magic defence while the wielder is near a village currently under raid. ⬜ assumes a wizard can be present during a raid on their own village. | Village shop, gold escalating                        | The first dedicated village-defence staff.                                                                        |
| Longstaff of the Monolith  | rare      | power +10, health +10, speed -5                    | +12% power while the wielder currently holds a floor.                                                                                              | Champion drop, inside the Monolith                   | The signature floor-holding staff; the speed loss is the kind's identity tax, not a legendary drawback.           |
| Granite Staff              | rare      | power +9, magic defence +7, speed -6               | The first hit of a cast ignores a small amount of the target's magic defence.                                                                      | Dungeon chest                                        | An anti-defence staff for a tough single target.                                                                  |
| Wintercrown Staff          | rare      | health +6, magic defence +8, speed -4              | Every stat bonus on this staff is 15% stronger during winter.                                                                                      | Winter-season world boss drop                        | A seasonal staff, honestly dead weight for three seasons out of four.                                             |
| Staff of Siege             | rare      | health +12, magic defence +9, speed -8             | Incoming damage reduced by 10% while the wielder is defending a village under raid.                                                                 | Maze treasure                                        | The premier anti-raid staff; its drawback is already the speed loss.                                              |
| Staff of Echoes Broken     | rare      | power +8, magic defence +4, luck +4                | +15% damage against echoes specifically.                                                                                                           | Reward for taking a floor from another wizard        | A raider's staff that does nothing in ordinary open-world play.                                                   |
| Staff of the World-Walker  | legendary | power +14, mana pool +12, speed -10                | Mana regeneration +20% while the wielder is stationary.                                                                                            | Unique world boss drop                               | The drawback is the speed loss, severe enough to make the wielder an easy target in the open.                     |
| Pillar of the First Wizard | legendary | power +15, health +14, magic defence +9, speed -12 | Mana pool +10% for every village the wielder owns, **capped at five villages for +50%**.                                                            | Single unique drop, the highest-tier world boss only | The strongest staff in the game by raw numbers. The cap stops a village empire from compounding without limit.     |

## Tome

A tome is not primarily a combat weapon, and its table reflects that.
Its bonuses touch mana pool, mana regeneration and the mechanics around how a spell gets built and kept, rather than raw offence.
It is the kind that interacts most directly with **rune weight**, the **cost bar** and **Grimoire positions**, so it is also the kind most exposed to changes in those systems.

| Name                        | Rarity    | Stat bonuses                             | Special                                                                                                                                    | Source                        | Notes                                                                                                                                      |
| --------------------------- | --------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Primer, the First Tome      | common    | mana pool +8                             | +1 Grimoire position.                                                                                                                      | Starting quest reward         | A near-universal pick for any tome wizard.                                                                                                 |
| Pocket Primer               | common    | speed +3, mana pool +4                   | —                                                                                                                                          | Village shop, gold escalating | Deliberately mild, and meant to be outgrown.                                                                                               |
| Tome of Lesser Weights      | common    | magic defence +4                         | The wielder's cost bar gains extra headroom worth one point of **rune weight**.                                                            | Village shop, gold escalating | The plainest version of the cost-bar lever, and the reason `weight` needed ratifying.                                                        |
| Merchant's Ledger           | common    | mana pool +4, luck +3                    | Rune prices at NPC villages are reduced for the wielder.                                                                                   | Village shop, gold escalating | An economy tome that repays itself slowly. Worth exactly as much as the wizard's rune-buying habit.                                          |
| Tome made of feathers       | rare      | mana pool +10, magic defence +5          | The same cost-bar headroom as the common version, larger.                                                                                   | Dungeon chest                 | Differentiated from its common counterpart only by size, which is thin — watch it in testing.                                                |
| Tome of Mana Unbound        | rare      | mana pool +12                            | Mana regeneration +15%.                                                                                                                    | Champion drop                 | A pure sustain tome with no offensive hook of its own.                                                                                      |
| Tome of the Patient Scholar | rare      | mana pool +6, magic defence +6           | Mana regeneration +10% while the wielder has not cast anything for a few seconds.                                                           | Maze treasure                 | Mirrors the **Patience** Effect rune, which still exists — not the deleted `Patient` Duration rune. See the notes.                           |
| The Marginal Note           | rare      | mana pool +6, luck +5                    | Once per fight, the wielder may recast their last spell at no mana cost.                                                                    | Village shop, gold escalating | Rewards a wizard built around one expensive spell rather than several cheap ones.                                                            |
| Codex of the Second Hand    | rare      | mana pool +9, power +4                   | The rune in the wielder's `Effect2` slot acts at +20% strength. `Effect1` is unaffected.                                                    | Champion drop, floors 20-39   | Pays off only for a wizard who fills both Effect slots, which needs level 2 and a deliberate build.                                          |
| Grand Grimoire              | legendary | mana pool +15, magic defence +8, luck -5 | +2 Grimoire positions, plus cost-bar headroom equal to the rare tome above, stacked.                                                        | Unique world boss drop        | The drawback is luck. +2 positions is the ratified maximum any single tome may grant.                                                        |
| The Unwritten Page          | legendary | mana pool +18, magic defence +6, speed -8 | In one spell of the wielder's choosing, the heaviest single rune counts at half its **weight** when the spell's cost is computed.           | Unique maze reward            | The drawback is speed. Bounded on purpose: it discounts one rune, never a whole spell, so "no spell is both cheap and strong" still holds.    |

## Relic

A relic is the strange one: its bonuses are small but frequently conditional, tied to gold carried, villages owned, season, or whether the target is an echo.
Relics are worn rather than wielded — rings, charms, lockets, bands, sashes and masks — which is why a relic wizard's silhouette never tells you what they can do.
A relic wizard is making a bet about their own situation at the moment of a fight, not about their build in general.
Several relics carry an honest two-way swing rather than a flat bonus, which is the point of the kind.

| Name                  | Rarity    | Stat bonuses                      | Special                                                                                                                                                                                                                                | Source                                                 | Notes                                                                                                                |
| --------------------- | --------- | --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| Pauper's Ring         | common    | luck +2, speed +2                 | All bonuses on this relic double while the wielder owns zero villages.                                                                                                                                                                 | Always available, starting village shop                | Zero villages is genuinely reachable, unlike zero floors, so this trigger is sound.                                   |
| Coinbound Charm       | common    | luck +3                           | Power +1 for every notable amount of gold currently carried, up to a small cap.                                                                                                                                                        | Village shop, gold escalating                          | Mirrors the Greed rune's logic; makes a rich wizard hit harder and a juicier raid target.                            |
| Beggar's Locket       | common    | speed +4                          | Magic defence bonus increases the fewer villages the wielder owns.                                                                                                                                                                     | Quest reward, offered to a wizard in a losing position | A comeback relic, mirroring the Humility rune. ⬜ "a losing position" still needs a concrete threshold.                |
| Thaw-Iron Band        | common    | magic defence +5                  | Magic defence +8% during winter, -4% during summer.                                                                                                                                                                                    | Seasonal village vendor                                | An honest two-way seasonal swing rather than a flat bonus.                                                           |
| Shard of the Unraided | rare      | health +10                        | While the wielder is offline, their village's defenders gain a bonus to magic defence against the raid.                                                                                                                                | Maze treasure                                          | Ratified: personal gear **can** buff village defenders while its owner is absent.                                     |
| Sunstone of Radiance  | rare      | power +7                          | +15% damage against echoes specifically.                                                                                                                                                                                              | Monolith floor-clear reward                            | An anti-echo relic for floor raiders, weak everywhere else.                                                           |
| Harvestcount Seal     | rare      | health +6, luck +3                | +1 to every stat bonus on this relic for every village the wielder owns, up to three villages.                                                                                                                                         | Quest reward                                           | A direct implementation of scaling with villages owned, with its own cap already built in.                            |
| Sash of the Tithe     | rare      | health +8, luck +4                | Gold income from the wielder's villages continues at full rate while the wielder is inside the Monolith.                                                                                                                               | Quest reward, issued at the Ground Floor               | Resolves a real tension: climbing and earning otherwise compete for the same hours.                                   |
| Mask of the Quiet Name | rare     | magic defence +5, speed +6        | The wielder's name is hidden from the North Wall while worn, though their floors stay held.                                                                                                                                            | Maze treasure                                          | Buys obscurity, not power. Strongest for a wizard high enough to be a target but not strong enough to survive being one. |
| Widow's Ichor Vial    | legendary | health -15, power +12             | Returns a portion of damage dealt to the caster as health.                                                                                                                                                                             | Unique world boss drop                                 | Mirrors the Ichor rune's risk; a glass-cannon relic for a confident player.                                           |
| The Unspent Hour      | legendary | mana pool -12, speed +10, luck +8 | Once per run, a hit that would kill the wielder instead turns them invisible and intangible for **20 seconds**, during which they can do nothing at all. When it ends they return with **10% of their health** and may act again. The relic's special effect is then spent for the rest of the run. | Single unique maze reward, one per world               | No rollback and no rewind: a forced, helpless pause followed by a bad position. Buys one life, and charges for it.      |

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

## Changed in this pass

| Weapon                      | Change  | Reason                                                                                                                      |
| --------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------- |
| Scrivener's Tome            | deleted | Its effect improved the result of salvaging a rune. There is no rune salvage or disassembly system, and none is planned.      |
| Annotated Index             | deleted | Its effect granted an extra saved loadout for quick-swapping. There is no loadout-swap mechanic.                             |
| Merchant's Ledger           | added   | Replaces Scrivener's Tome at common, keeping the economy niche without assuming a system that does not exist.                 |
| The Marginal Note           | added   | Replaces Annotated Index at rare.                                                                                           |
| Codex of the Second Hand    | added   | Extra rare tome, on request. Built on the ordered Effect slots, a system that definitely exists.                              |
| The Unwritten Page          | added   | Extra legendary tome, on request.                                                                                            |
| Sash of the Tithe           | added   | Extra rare relic, on request. A belt.                                                                                       |
| Mask of the Quiet Name      | added   | Extra rare relic, on request. A mask.                                                                                       |
| Pillar of the First Wizard  | capped  | Villages-owned scaling now stops at five villages for +50%.                                                                  |
| The Unspent Hour            | rewritten | Replaced the unimplementable rollback with a 20-second helpless ghost phase and a 10% health return.                        |
| Tome of the Patient Scholar | kept    | Reported as naming a deleted rune. It does not — see the notes below.                                                        |

## Notes for balancing

**A plain common weapon being discarded beside a rare one is accepted behaviour, not a defect.**
Thornless Wand, Wand of the Steady Hand, Oak Staff, Bonegrip Staff, Staff of the Deep Root and Pocket Primer carry no Special effect at all.
That is deliberate: they are the floor of the scale, and a wizard is supposed to outgrow them.
The notes on those rows have been reworded to say so rather than flagging them as underperformers.

**One report was incorrect, and the detail matters.**
`Tome of the Patient Scholar` was reported as naming the deleted `Patience` rune.
`Patience` is an **Effect** rune and is still in `RUNES.md`, at weight 3.
What was deleted is `Patient`, a **Duration** rune, and the two were always one letter apart.
The tome is valid and has been kept, with its note made explicit about which rune it mirrors.
The near-collision is worth remembering: `Patient` and `Patience` were close enough to cause a false alarm even for the person who deleted one of them.

⚠️ **`Grand Grimoire` still stacks two tome advantages onto one item.**
It grants the ratified maximum of +2 Grimoire positions **and** the largest cost-bar headroom in the document.
That removes most of the reason to pick a narrower legendary tome, and `The Unwritten Page` now exists partly to give that tier a second option.
Splitting Grand Grimoire's two effects across two items remains the cleaner fix if it proves dominant.

⚠️ **`Tome made of feathers` and `Tome of Lesser Weights` differ only in magnitude.**
A rare that is a bigger common is the weakest kind of rarity step.
Giving the rare a different behaviour — headroom that grows with the number of filled spell slots, for instance — would earn its tier.

⬜ **`Staff of the Garrison` still assumes a wizard can be physically present during a raid on their own village.**
Everything else in the design points to yes: the echo defends a capital only while its owner is **offline**, which implies an online owner defends in person.
But that inference has never been ratified, and this staff and `Staff of Siege` both depend on it.

⬜ **`Beggar's Locket` needs a concrete threshold for "a losing position".**
It is the only trigger in the document that cannot be evaluated from a number.

**Resolved since the last pass.**

| Question                                               | Answer                                                                                       |
| ------------------------------------------------------ | -------------------------------------------------------------------------------------------- |
| Do the over- and underpowered flags need a rework?      | No. A common being outclassed by a rare is expected.                                          |
| Does the cooldown formula block the weapon list?        | No. The formula comes later; nothing here needs redesigning for it.                            |
| Is a cap needed on Grimoire positions from a tome?      | Yes, +2 is the maximum, which `Grand Grimoire` already sits at.                                |
| Does a rune salvage or disassembly system exist?        | No. `Scrivener's Tome` was deleted for assuming one.                                           |
| May a weapon buff the owner's villages?                 | Yes, and it is kept — `Shard of the Unraided` stands.                                          |
| Does `Pillar of the First Wizard` need a cap?           | Yes, five villages for +50%.                                                                   |
| Is a death-rollback implementable?                      | Not as written. Replaced with a 20-second helpless ghost phase and a 10% health return.         |
| Can a wizard use more than one weapon kind?             | No, exactly one. Others are sold to shops for gold or traded to other wizards.                 |

**Still open, and now the only one that touches every row.**
⬜ The mapping from wizard type to weapon kind does not exist yet.
The rule is settled — one kind per wizard — but the table saying *which* type gets *which* kind has not been written, and it decides what a quarter of this document is worth to any given player.
