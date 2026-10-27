# Tower upgrades — Wizards Towers

- [Tower upgrades — Wizards Towers](#tower-upgrades--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [What a tower is for, and why its upgrades are riskier than a village's](#what-a-tower-is-for-and-why-its-upgrades-are-riskier-than-a-villages)
  - [Mana income upgrades](#mana-income-upgrades)
  - [Defences and fortification upgrades](#defences-and-fortification-upgrades)
  - [Offline defence upgrades](#offline-defence-upgrades)
  - [Rune-unlocking upgrades](#rune-unlocking-upgrades)
  - [Utility and quality-of-life upgrades](#utility-and-quality-of-life-upgrades)
  - [Risky and conditional upgrades](#risky-and-conditional-upgrades)
  - [Notes for balancing](#notes-for-balancing)

## How to read this document

This is a long menu of candidate tower upgrades, meant to be cut down rather than built as written.

Every table uses the same six columns: **Name**, **Tier**, **Effect**, **Cost shape**, **Requires**, **Notes**.
**Tier** is `I`, `II`, `III` for an upgrade bought in levels, or `Unique` for a one-off purchase with no levels.
**Cost shape** never states a gold figure.
It describes how the price behaves instead, because purchase prices escalate with how many upgrades of that kind the wizard already holds, and an absolute number written here would be false by the time a second copy is bought.
**Requires** names a prerequisite: an earlier tier, a wizard level, another upgrade, a held floor, or a season.
**Notes** is where the trade-off lives.
If a row has no notable trade-off, it says so plainly rather than inventing one.

No entry below assigns a mana cost to anything, and none should.
Where a runic catalyst is spent to buy an upgrade, it is consumed outright, the same way a mana-stone or a life-stone is spent.

## What a tower is for, and why its upgrades are riskier than a village's

A tower is the one building a wizard constructs inside a village they own, at most one tower per village.
It produces mana income, raising the wizard's mana pool, the counterpart to the gold income a village produces on its own.
A tower also defends itself according to its upgrades, including while the wizard is offline, which is why so many of the upgrades below are about an unattended fight rather than one the wizard watches.

The reason tower upgrades deserve more caution than village upgrades is the tower cap.
When a wizard exceeds it, they must give up a tower, and that tower is **ruined**: the building and every upgrade bought on it are destroyed outright.
A village's own upgrades are not touched by the loss of its tower, so a village upgrade is a purchase a wizard keeps however their towers fare.
A tower upgrade is not: every gold piece spent here is a gold piece that can be erased the day the wizard's holdings are trimmed back to the cap.

That asymmetry is also why a tower matters at the far end of a run.
Paying for the Monolith's final floor is done from a tower, so a wizard who has been talked into never building one cannot enter the endgame at all.
Several upgrades below exist specifically to reward a wizard who keeps that door open.

⬜ The tower cap's exact number, and whether it is fixed or raised by other purchases, is not decided (see `GLOSSARY.md`, landlord management, question 26.6).
Every upgrade below is written to make sense regardless of what that number turns out to be.

## Mana income upgrades

| Name               | Tier     | Effect                                                                                                                   | Cost shape                                                                       | Requires                                        | Notes                                                                                                                        |
| ------------------ | -------- | ------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| Attunement Spire   | I–III    | Raises the tower's mana income by a flat percentage per tier.                                                            | Gold, escalating per tier and per copy already bought on this tower.             | None                                             | The baseline income upgrade, unremarkable on purpose: everything else in this table is a trade measured against it.         |
| Overcharged Conduits | I–III  | Raises mana income well beyond Attunement Spire, but each tier also raises the tower's income figure on the North Wall. | Gold, higher than Attunement Spire at the same tier.                             | Attunement Spire III                             | The income side of this document's central trade: more mana for more attention from raiders.                               |
| Harvest Font       | I–II     | Doubles mana income during one chosen season and halves it during the other three.                                      | Gold, with the season locked in at purchase.                                     | None                                             | Rewards planning a build around one season rather than steady accumulation; the wrong choice sits half-dead for three of them. |
| Ley Overdraw       | I–III    | Converts a portion of mana income into gold income at a fixed ratio.                                                     | Gold, escalating per tier.                                                       | Attunement Spire I                               | Useful when gold is the bottleneck for the next village, wasteful for a wizard chasing a bigger mana pool.                   |
| Floorlight Siphon  | Unique   | Mana income rises for every Monolith floor the wizard currently holds, and produces nothing if they hold none.          | Gold plus a mana-stone, spent on purchase.                                       | Wizard holds at least one floor at purchase      | A trophy upgrade: strong for a floor holder, dead weight if bought early and the floor never comes, or is later lost.       |
| Nightwell          | I–III    | Mana income accrues at a bonus rate on top of the normal passive rate while the wizard is offline.                       | Gold, escalating per tier.                                                       | None                                             | Pure upside only while logged out; contributes nothing to a wizard who stays online around the clock.                       |
| Vigil Draft        | I–III    | Mana income rises while the wizard is online and present in the capital village, and drops to normal the moment they log out. | Gold, escalating per tier.                                                 | None                                             | The mirror of Nightwell. Maximising both at once asks for more towers than most wizards will ever hold.                     |
| Greedy Core        | I–III    | Mana income rises with the gold the wizard is currently carrying.                                                        | Gold, escalating per tier.                                                       | None                                             | Turns a wealthy wizard's own treasury into bait, since Greed-type offensive spells also scale on carried gold.              |
| Bleeding Coil      | I–II     | A strong flat mana income boost that also permanently chips a small amount off the tower's magic defence every tick.    | Gold, cheap for the income it grants.                                            | None                                             | Looks like a trap and mostly is one: fine as a short rush before a planned defensive purchase, ruinous left running a season. |

## Defences and fortification upgrades

| Name                | Tier               | Effect                                                                                                              | Cost shape                                                                       | Requires               | Notes                                                                                                                       |
| ------------------- | ------------------ | --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Ward Lattice        | I–III              | Raises the tower's magic defence stat directly.                                                                     | Gold, escalating per tier.                                                       | None                    | The baseline defensive upgrade.                                                                                             |
| Bastion Walls       | I–III              | Raises the tower's health.                                                                                          | Gold, escalating per tier.                                                       | None                    | Pairs naturally with Ward Lattice; neither alone holds against a determined raider.                                        |
| Elemental Bulwark   | I–III, per Element | Reduces damage from one chosen Element by a large margin, and does nothing against the other eleven.                | Gold, each additional Element chosen escalating independently.                   | Ward Lattice I          | Guessing wrong about a rival's favoured Element wastes the purchase; scouting first turns it sharp instead of a gamble.     |
| Reactive Plating    | I–II               | A portion of damage the tower takes is returned to the attacker as a Knockback-shaped strike.                       | Gold, escalating per tier.                                                       | Bastion Walls I         | Weak against an attacker fighting at ranged reach, who never comes close enough to be shoved.                                            |
| Gate Sigil          | Unique             | Adds a Wall-shaped barrier at the tower's entrance that must be destroyed before the tower itself can be damaged.    | Gold plus a Shape-attribute rune, consumed as a catalyst.                        | None                    | A flat extra health buffer dressed as a mechanic: strong against a weak early raider, irrelevant against a champion-tier one. |
| Fortified Foundations | I–II             | Halves damage the tower takes from Covet-type effects, which are built to raze structures rather than hurt wizards. | Gold, escalating per tier.                                                       | Bastion Walls I         | Narrow by design: does nothing in a wizard-versus-wizard duel, since Covet is nearly harmless there.                        |
| Sacrificial Ramparts | I–III             | A large magic defence boost paid for by a matching cut to the tower's mana income.                                  | Gold, escalating per tier.                                                       | Ward Lattice II         | The direct mirror of Overcharged Conduits: this table's version of betting on survival over growth.                        |
| Thorned Perimeter   | I–II               | Enemies that strike the tower in melee range take damage back, at the cost of raising the tower's own mana upkeep.  | Gold, escalating per tier.                                                       | Reactive Plating I      | Punishes a melee raider hard and does nothing against an attacker fighting at ranged reach.                                      |

## Offline defence upgrades

| Name                | Tier     | Effect                                                                                                                        | Cost shape                                                        | Requires               | Notes                                                                                                                      |
| ------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Echo Reinforcement  | I–III    | Raises the stats the echo inherits specifically while defending the capital village offline, with no effect on the wizard online. | Gold, escalating per tier.                                        | None                    | The most direct offline-defence purchase here, and useless the moment the wizard is logged in and defending in person.     |
| Sentinel Seed       | I–II     | Plants a Seed-shaped, Delayed-Duration ward around the tower that only arms itself once the wizard goes offline.                | Gold plus one Shape rune and one Duration rune, both consumed.     | Echo Reinforcement I    | Classic trap design: silent while the wizard plays, lethal to whoever raids while they are away.                          |
| Idle Vigil          | I–III    | Tower defence stats continue to rise the longer the wizard stays offline, resetting the moment they log back in.               | Gold, escalating per tier.                                        | None                    | Rewards a wizard who logs off and stays off; a wizard who checks in hourly never lets the bonus build.                     |
| Last Stand Ward     | Unique   | Grants the echo a one-time Ward-type shield, triggering automatically only once tower health falls below a fixed fraction offline. | Gold plus a life-stone, spent on purchase.                   | Echo Reinforcement II   | One clutch save per logout window; it will not recharge until the wizard logs in and back out again.                      |
| Decoy Ward          | I–II     | Randomises the tower's displayed mana income on the North Wall and to scouting, within a bounded range of the true value.      | Gold, escalating per tier.                                        | None                    | Quality-of-life for the paranoid: a worse-looking target without any change to what it actually defends.                   |
| Raid Vigil          | Unique   | Alerts the wizard, wherever they are, the moment the offline tower comes under attack.                                          | Gold, cheap.                                                       | None                    | Only useful if the wizard can act on the alert quickly; a short, decisive raid can be over before they do.                 |
| Dormant Bulwark     | I–III    | A magic defence bonus that only applies while the wizard is offline, lost entirely the instant they log in.                     | Gold, escalating per tier.                                        | Idle Vigil I            | Stacks with Echo Reinforcement for a tower built purely to survive unattended, at no benefit in a fight the wizard watches. |
| Sleeper's Patience  | Unique   | The echo's first strike against an offline raider deals bonus damage scaled to how long the wizard has been logged out, capped at one season. | Gold plus a mana-stone, spent on purchase.          | Sentinel Seed I         | Devastating against a raider who waits for a long logout window, irrelevant against one who strikes within the hour.      |

## Rune-unlocking upgrades

| Name              | Tier         | Effect                                                                                                      | Cost shape                                                              | Requires           | Notes                                                                                                                       |
| ----------------- | ------------ | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Rune Conduit      | I–III        | Unlocks direct purchase of common Shape runes at the tower, bypassing a trip to an NPC village.             | Gold, escalating per tier.                                              | Wizard level 2       | The entry point into this category: convenience first, deeper access later.                                                |
| Elemental Font    | I–III        | Unlocks purchase of one chosen Element rune at the tower that is otherwise only found from bosses or treasure. | Gold, escalating per tier and again per additional Element chosen.      | Rune Conduit II      | The Element is locked in at purchase, so knowing what the wizard's build actually needs matters before buying.             |
| Duration Archive  | I–II         | Unlocks purchase of the Delayed and Lingering Duration runes at the tower.                                  | Gold, escalating per tier.                                              | Rune Conduit I       | Opens the two Duration runes offline-defence builds lean on hardest, tying this category back to that one by design.       |
| Effect Index      | I–III        | Unlocks purchase of one chosen Effect rune, gated to a tier set by how powerful that Effect is.             | Gold, escalating sharply for a heavier Effect.                          | Elemental Font I     | Buying access to Growth or Anchor here is buying a rune that does nothing alone, so pair it with the Shape or Duration it needs. |
| Seasonal Rune Well | Unique, per season | Unlocks purchase of a rune that is otherwise only available during one named season.                   | Gold, re-triggered each run when that season arrives.                   | Rune Conduit I       | Dead weight for three seasons out of four, which is the entire point of locking it to one.                                 |
| Artifact Conduit  | Unique       | Unlocks purchase of a rare-rarity rune at the tower, but only while the wizard currently holds a Monolith floor. | Gold plus a mana-stone, spent on purchase.                          | Wizard holds a floor at purchase and at every use | Loses all function the moment the floor changes hands, which can happen without warning.                                  |
| Range Beacon      | Unique       | Unlocks purchase of a rune, otherwise only found from treasure, that lets the caster target any village they have personally visited.                            | Gold, expensive, reflecting how strong remote-cast defence is.          | Rune Conduit III     | Enables casting at any village the wizard has personally visited, the backbone of remote village defence.                  |
| Legendary Forge   | I–II         | Lets the wizard pay gold and mana, instead of finding a drop, to raise one owned rune from common to rare.  | Gold plus mana, both scaling with the rune's weight.                    | Effect Index I       | Deliberately stops short of legendary, which stays find-only; the Forge narrows the gap rather than closing it.            |

## Utility and quality-of-life upgrades

| Name                 | Tier   | Effect                                                                                                                | Cost shape                                                           | Requires       | Notes                                                                                                                        |
| -------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------ | ---------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Tower Beacon         | I      | Marks the tower clearly on the wizard's own minimap from any distance.                                               | Gold, cheap.                                                          | None            | Small, cheap, mostly bought out of habit rather than need.                                                                  |
| Remote Ledger        | Unique | Lets the wizard check the tower's current health, income and upgrade state from anywhere on the world map.          | Gold, cheap.                                                           | None            | Information only; it changes nothing about a fight already underway.                                                       |
| Mana Overflow Vault  | I–II   | Mana income earned while the mana pool is already full is stored up to a cap and released on the next pool increase. | Gold, escalating per tier.                                             | None            | Solves a real waste problem for a wizard who logs in rarely, and does nothing for one who plays every day.                 |
| Fast Travel Anchor   | Unique | Lets the wizard teleport directly to this tower's village once per a fixed cooldown.                                 | Gold plus a Shape-attribute rune, consumed as a catalyst.              | None            | Convenience with a real defensive side effect: reaching a raided tower faster can matter before the fight is decided.      |
| Weather Vane         | Unique | Displays the time left in the current season and a warning before a world boss's seasonal strength spike.            | Gold, cheap.                                                           | None            | Pure information, but several builds above only make sense once a wizard can see the season clock.                          |
| Blueprint Memory     | I–III  | If this tower is ever ruined, rebuilding one in the same village refunds a portion of the gold spent on its upgrades. | Gold, escalating per tier.                                             | None            | The one upgrade here that exists purely to soften the mechanic that makes tower upgrades risky at all.                     |
| Shared Ward          | Unique | Lets an allied wizard temporarily benefit from this tower's magic defence bonus while visiting.                      | Gold, cheap.                                                           | Ward Lattice I  | Mostly social; a lone wizard gets nothing from it at all.                                                                   |
| Appraiser's Lens     | I      | Shows the estimated gold and rune value of a rival's tower before a wizard decides whether to raid it.               | Gold, cheap.                                                           | None            | Information for the raider, not the defender, and the only row here more useful on someone else's tower than your own.      |

## Risky and conditional upgrades

| Name               | Tier   | Effect                                                                                                              | Cost shape                                                           | Requires                                             | Notes                                                                                                                        |
| ------------------ | ------ | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Beacon of Avarice  | Unique | A very large mana income boost that makes the tower's income figure publicly visible and highlighted on the North Wall. | Gold, expensive.                                                   | Overcharged Conduits II                                 | Builds a target on the wizard's own back deliberately; sound only for one confident their defences can answer the raids it invites. |
| Overclocked Core   | I–II   | Doubles mana income, but the tower's health no longer regenerates between attacks, only on upgrade or repair.      | Gold, escalating per tier.                                               | Attunement Spire III                                    | Fine against one raid a season, ruinous against a wizard being probed repeatedly by the same rival.                        |
| Blood Font         | Unique | Converts a sliver of the wizard's own health into mana income every tick while online, in the manner of the Ichor Element. | Gold plus an Ichor-Element rune, consumed as a catalyst.          | None                                                     | The only income upgrade that can contribute to killing its own owner if left running during a hard fight.                  |
| Gambler's Spire    | Unique | At the start of every season, rerolls a random result: double income for the season, or none at all.               | Gold, moderate.                                                           | None                                                     | A coin flip bought on purpose, acceptable to a wizard who treats one bad season as a tolerable loss.                        |
| Monolith Tithe     | Unique | A strong bonus to both income and defence while the wizard holds a Monolith floor, switching off the instant the floor is lost. | Gold, expensive.                                               | Wizard holds a Monolith floor, and an Artifact, never spent | The clearest example of why a tower matters at the endgame: paying for a later floor is done from a tower, and this upgrade leans on that link directly. |
| Last Bastion Pact  | Unique | A large defence bonus that activates only once this is the wizard's single standing tower.                         | Gold, cheap.                                                              | Wizard has been reduced to one tower by the tower cap    | Looks wasted for anyone with more than one tower, and is the strongest single defensive upgrade here for whoever is down to their last. |
| Sunken Treasury    | I–II   | A portion of mana income is instead stored as gold inside the tower itself.                                         | Gold, escalating per tier.                                               | None                                                     | That stored gold is destroyed along with everything else if the tower is ever ruined, unlike gold banked on the wizard directly. |
| Twilight Pact      | Unique | A large bonus to both income and defence that only applies during winter, the final season of a run.               | Gold, expensive.                                                          | Wizard has reached autumn without losing their capital's tower | Dead for three-quarters of a run and the strongest single upgrade here for whichever wizard is still standing when winter starts. |

## Notes for balancing

**Likely overpowered as written.**
`Monolith Tithe` and `Twilight Pact` both stack a strong income bonus with a strong defence bonus on the same row, which no other entry does; if either survives review it should probably give up one of the two bonuses.
`Last Bastion Pact` is intentionally extreme — reread its row before deciding whether "strongest defensive upgrade in the whole document" is the comeback mechanic wanted, or too strong a safety net for a wizard who has already lost towers to the cap.

**Likely underpowered or too narrow as written.**
`Fortified Foundations` only matters against one specific effect, Covet, and may never see play outside a village-razing meta.
`Shared Ward` gives nothing to a wizard who never plays alongside anyone, which may be most wizards; it may belong in a co-op-only expansion of this document rather than the base one.

**Deliberately bad-looking, strong only in a narrow build.**
`Bleeding Coil`, `Greedy Core`, `Blood Font`, `Last Bastion Pact` and `Gambler's Spire` are the five meant to read as traps on first glance.
Whether each actually earns its keep in a narrow build, rather than just looking clever on paper, is exactly what playtesting needs to answer before any of them ship.

⬜ **Open — whether escalating price is per tower or per wizard.**
`GLOSSARY.md` says purchase prices escalate with how many of a type the wizard already holds, in the context of villages and weapons, which are owned by the wizard as a whole.
Every "Cost shape" cell above assumes the same escalation applies to tower upgrades, but it is undecided whether the count is per tower (so a second tower starts its `Attunement Spire` cheap again) or per wizard across every tower they hold.
That choice changes whether owning several towers is an income strategy or a tax, and should be settled before any of the income table is priced.

⬜ **Open — whether a mana-stone is charged for a rune granted by a tower upgrade.**
`GLOSSARY.md` question 32.1 leaves open whether swapping a rune inside an existing spell costs a mana-stone.
The rune-unlocking table above treats an upgrade's catalyst rune as a one-time purchase cost, separate from that question, but if unlocking a rune and then slotting it into a spell both draw on the same scarce consumable, several rows in that table become far more expensive in practice than their "Cost shape" column suggests.

⬜ **Open — whether the tower cap can itself be raised.**
Several rows, `Last Bastion Pact` most of all, read very differently depending on whether the tower cap is a fixed number for the whole run or something a wizard can push upward with gold, RP or a talent.
Nothing here assumes an answer, but the design question in the opening section blocks final balancing of the whole "risky and conditional" table.

**Speculative extensions, flagged rather than assumed.**
`Decoy Ward` assumes scouting spells exist that can read a tower's income from a distance; the base documents imply this through the North Wall but do not confirm a scouting mechanic beyond it.
`Appraiser's Lens` and `Beacon of Avarice` both assume a tower's income or value can be surfaced to other wizards specifically, which is a reasonable extension of the North Wall's existing floor-holder display but is not itself confirmed anywhere in `GLOSSARY.md` or `RUNES.md`.
Treat all three as proposals that need a scouting-mechanic decision behind them, not as settled features.
