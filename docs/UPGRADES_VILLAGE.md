# Village upgrades — Wizards Towers

- [Village upgrades — Wizards Towers](#village-upgrades--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [What a village is for](#what-a-village-is-for)
  - [Gold income](#gold-income)
  - [Crops and farmland](#crops-and-farmland)
  - [Walls and fortification](#walls-and-fortification)
  - [Guardians](#guardians)
  - [Offline defence](#offline-defence)
  - [Utility and quality of life](#utility-and-quality-of-life)
  - [Risky or conditional](#risky-or-conditional)
  - [Notes for balancing](#notes-for-balancing)

## How to read this document

This is a brainstorm of purchasable upgrades for a **village**, grouped by what they do.
It is a list to cut down from, not a finished design: expect overlap, expect some entries to
be rejected outright.

Each table uses the same six columns:

- **Name** — the upgrade's working title.
- **Tier** — `I`, `II` or `III`.
  A higher tier is either a straight upgrade of a lower one in the same line
  (Market Stall → Market Row → Grand Bazaar), or a standalone upgrade whose power and cost sit
  at that tier's weight.
  No absolute gold figures are given anywhere in this document, because every purchase type has
  its own **escalating price**: the cost rises with how many of that type the wizard already
  holds, and falls if holdings are lost.
  Tier says roughly how strong and how late-game an upgrade is meant to be, not what it costs
  in gold on any particular purchase.
- **Effect** — what changes when the upgrade is bought.
- **Cost shape** — what currency it draws on and how its escalation is scoped.
  Almost everything here is paid in gold.
  A few entries also draw on a life-stone, called out explicitly because life-stones are
  precious: a wizard sees two or three across a whole run, plus one starter life-stone meant
  for their first village's shield.
- **Requires** — prerequisites beyond the baseline.
  Every single upgrade in this document additionally requires **wizard level 2**, because a
  level-1 wizard may hold only one village and may buy no village upgrades at all.
  That blanket requirement is not repeated in every row; this column lists anything beyond it.
- **Notes** — the trade-off, the catch, or the reason the upgrade exists.

## What a village is for

A village is a settlement on the procedurally generated world map, procedurally named.
A wizard buys one with gold, or wins one by completing a quest.
A village cannot be sold, ever.

A village produces gold income.
A tower, a separate building placed inside a village, produces mana income instead — towers and
their upgrades are not this document's subject.

One village is designated the **capital**.
The wizard teleports there on logout and reappears there on login.
The capital is defended by the wizard's echo while they are offline; no other village has an
echo, so echo-related upgrades below only apply to the capital.

Villages can be raided, stolen and destroyed, by other wizards and by wandering NPC enemies
alike.
Offline defence matters enormously, because a wizard spends most of a run logged out of a
village they still depend on.

A village may raise a village shield, bought with a life-stone, which absorbs a fixed amount of
damage and then vanishes.
A level-1 wizard begins with one starter life-stone, meant to be spent on their first village's
shield.

A level-1 wizard may hold only one village and may buy no village upgrades.
Both a second village and every upgrade in this document require level 2.

Guardians are defensive units stationed in a village by an upgrade, covered in their own table
below.

Crops sit **outside** the village's walls as a separate kind of investment: high-yield, and
exposed to raiders and wandering enemies in a way nothing inside the walls is.
They also interact with the run's four seasons — spring, summer, autumn and winter, each 48
hours — because what a field yields depends on which season it is.

## Gold income

| Name              | Tier | Effect                                                                                               | Cost shape                                                   | Requires      | Notes                                                                                     |
| ----------------- | ---- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- | -------------- | ------------------------------------------------------------------------------------------- |
| Market Stall      | I    | Modest flat increase to the village's gold income.                                                    | Gold, escalates with gold-income upgrades already held.      | —              | The entry point of the category; nothing clever, just gold.                                 |
| Market Row        | II   | Larger increase to gold income than Market Stall.                                                     | Gold, escalates with gold-income upgrades already held.      | Market Stall   | Straight upgrade of Market Stall, same slot.                                                |
| Grand Bazaar      | III  | Large increase to gold income, and makes the village visibly wealthy on the world map.                | Gold, escalates with gold-income upgrades already held.      | Market Row     | The wealth marker raises how often other wizards target this village for a raid.             |
| Toll Gate         | I    | Small continuous gold income from NPC and wizard road traffic passing the village.                    | Gold, escalates with gold-income upgrades already held.      | —              | Passive income, and only available on a village with a nearby road.                          |
| Trade Caravan     | II   | Converts Toll Gate income into a larger lump sum, delivered by an escorted caravan.                   | Gold, escalates with gold-income upgrades already held.      | Toll Gate      | The caravan travels outside the village and can be ambushed, losing that delivery entirely.   |
| Treasury Vault    | II   | Protects a portion of the village's stored gold from being plundered in a successful raid.            | Gold, one-time, escalates with vaults already held.          | —              | Safety rather than growth: this upgrade adds no income of its own.                            |
| Gilded Banner     | II   | Noticeable income increase, broadcast as a visible prestige marker to every nearby wizard.            | Gold, escalates with gold-income upgrades already held.      | —              | A deliberate version of the Grand Bazaar trade-off: buy it for the income, pay for it in raids. |
| Market Insurance  | I    | Refunds a portion of any gold stolen from the village in a raid, paid out afterwards.                 | Gold upkeep, recurring, escalates with gold-income upgrades. | —              | Ongoing upkeep quietly taxes the very income it protects.                                     |

## Crops and farmland

Crops are a separate category of investment from everything else in this document: planted
outside the walls, bought and upgraded like any other village purchase, but destroyable by
raiders and by wandering enemies in a way that walls, guardians and the shield do not protect
against by default.
Every protective crop upgrade below buys that protection back at some cost, usually yield.

| Name                   | Tier | Effect                                                                                                      | Cost shape                                                       | Requires                              | Notes                                                                                              |
| ----------------------- | ---- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ | --------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| Grain Field             | I    | Basic crop: strong yield in spring and summer, weak in autumn, dormant in winter.                              | Gold, escalates with crop fields already held.                   | —                                       | The baseline crop, cheapest to plant and cheapest to rebuild if lost.                                   |
| Orchard                 | II   | Slower crop to establish, but yields through spring, summer and autumn.                                        | Gold, escalates with crop fields already held.                   | —                                       | Mature trees take longer to replace than a field of grain once destroyed.                               |
| Vineyard                | III  | Rare crop, yielding only in summer and autumn, at the highest gold value of any crop.                          | Gold, escalates with crop fields already held.                   | —                                       | Highest loot value makes it the first field a raider burns.                                             |
| Winter Root Crop        | II   | The only crop that yields in winter, at a smaller amount than a summer crop.                                   | Gold, escalates with crop fields already held.                   | —                                       | Keeps some crop income alive through the one season that kills every other field's yield.               |
| Fallow Rotation         | I    | Rests a field for part of a season, cutting its yield, for a lower chance wandering enemies target it.         | Gold, escalates with protective crop upgrades already held.      | A crop field                            | Direct yield-for-safety trade: the field earns less while it is harder to destroy.                      |
| Scarecrow Wards         | I    | Wards a field against critter- and common-tier wandering enemies.                                              | Gold, escalates with protective crop upgrades already held.      | A crop field                            | Does nothing against a wizard raider; purely an anti-wildlife upgrade.                                  |
| Hedge Walls             | II   | Low fences around a field that delay a raider reaching it.                                                     | Gold, escalates with protective crop upgrades already held.      | A crop field                            | Blunts an opportunistic raid; a determined raider still gets through, just later.                       |
| Crop Shield             | III  | A smaller cousin of the village shield, bought with gold, that absorbs a fixed amount of damage on one field.  | Gold, large, escalates with crop shields raised this season.     | A crop field                            | Deliberately gold-funded rather than life-stone-funded; life-stones are too precious to spend on a field. |
| Granary                 | I    | Banks a buffer of the field's own recent income, so it survives even if the field is destroyed afterwards.     | Gold, escalates with granaries already held.                     | A crop field                            | Protects income already earned, not the field itself.                                                   |
| Irrigation Channel      | I    | Flat yield increase to every crop field in every season except winter.                                         | Gold, escalates with crop fields already held.                   | A crop field                            | No added vulnerability; the plain, unglamorous backbone of a crop-heavy village.                         |
| Seasonal Seed Vault     | II   | Guarantees at least one planted crop is in season at any time.                                                 | Gold, escalates with seed vaults already held.                   | Two crop fields of different types      | Prevents a badly timed field selection from earning nothing for a stretch.                              |
| Harvest Watch           | II   | Stations a light crop-specific guardian that fights wandering enemies but withdraws from a wizard raider.      | Gold, escalates with harvest watches already held.               | A crop field                            | Cheap and expendable by design; trades its own survival for the field's, never for a serious fight.     |
| Firebreak Trenches      | I    | Stops destruction of one field from spreading to an adjacent field.                                            | Gold, escalates with crop fields already held.                   | Two adjacent crop fields                | Only matters once a village runs multiple fields side by side.                                          |
| Harvest Festival Banner | III  | Large yield spike on every field for one season, tied to that season's harvest.                                | Gold, escalates with crop fields already held.                   | Two mature crop fields                  | The festival is loud: raid attention on the whole village rises sharply for its duration.                |

## Walls and fortification

| Name            | Tier | Effect                                                                                           | Cost shape                                                 | Requires      | Notes                                                                                     |
| --------------- | ---- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- | -------------- | ------------------------------------------------------------------------------------------- |
| Palisade        | I    | Basic perimeter wall, reducing incoming raid damage by a flat amount.                                | Gold, escalates with wall upgrades already held.             | —              | The entry point of the category.                                                            |
| Stone Wall      | II   | Upgrade of Palisade, with a larger damage reduction.                                                 | Gold, escalates with wall upgrades already held.             | Palisade       | Straight upgrade, same slot.                                                                |
| Bastion Wall    | III  | Highest wall tier, largest damage reduction, with a mounting point boosting a stationed guardian.    | Gold, escalates with wall upgrades already held.              | Stone Wall     | Synergizes with the Guardians category rather than standing alone.                           |
| Gatehouse       | I    | A controlled entry point adding time before a raider breaches the village, without reducing damage.  | Gold, escalates with gate upgrades already held.              | —              | Buys reaction time rather than absorbing damage; mainly useful while the wizard is online.    |
| Moat            | II   | A ditch obstacle strongly hindering ground-bound wandering enemies, weak against flying or magic foes.| Gold, escalates with wall upgrades already held.              | Palisade       | Strong against one threat type, weak against another; not a universal defence.              |
| Watchtower      | I    | Alerts the wizard immediately when a raid begins, while they are online.                             | Gold, escalates with watchtowers already held.                | —              | No effect on raid outcome by itself, and no benefit at all while the wizard is offline.       |
| Reinforced Gate | II   | Upgrade of Gatehouse, extending the breach delay further.                                            | Gold upkeep, recurring, escalates with gate upgrades held.    | Gatehouse      | The extra delay comes with an ongoing gold cost, quietly taxing income for safety.            |
| Wall Ward       | III  | Slowly regenerates wall damage each day without the wizard's involvement.                            | Gold, large, escalates with wall upgrades already held.       | Stone Wall     | Expensive top-tier upgrade, mainly useful for a village the wizard cannot check on often.      |

## Guardians

Guardians are defensive units stationed in a village by an upgrade.
Every entry below except Guardian Barracks depends on it: the barracks is the capacity unlock,
not a guardian itself.

| Name               | Tier | Effect                                                                                               | Cost shape                                             | Requires                             | Notes                                                                                         |
| ------------------ | ---- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Guardian Barracks  | I    | Raises the maximum number of guardians the village may station.                                          | Gold, escalates with barracks tiers already held.        | —                                        | Unlocks every other entry in this table.                                                           |
| Militia Guardian   | I    | Stations a weak guardian, roughly critter- to common-tier strength.                                       | Gold, escalates with guardians already stationed.        | Guardian Barracks                        | Holds the line against wandering enemies; no real threat to a wizard raider alone.                 |
| Veteran Guardian   | II   | Stations a stronger guardian, roughly veteran-tier strength.                                              | Gold, escalates with guardians already stationed.        | Guardian Barracks, Militia Guardian      | Can meaningfully delay a lone wizard raider, not stop a prepared one.                               |
| Elite Guardian     | III  | Stations a rare, elite-tier guardian.                                                                     | Gold, large, escalates with guardians already stationed. | Guardian Barracks, Veteran Guardian      | A genuine threat to an average wizard; price escalates sharply after the first.                     |
| Mounted Guardian   | II   | A fast guardian, high speed, able to intercept a raider fleeing a crop field with stolen yield.           | Gold, escalates with guardians already stationed.        | Guardian Barracks                        | The only guardian aimed specifically at defending crop fields rather than the village itself.        |
| Battle Formation   | II   | Grants a coordination bonus to power and magic defence when two or more guardians are stationed together. | Gold, escalates with formation upgrades already held.    | Guardian Barracks, two guardians         | Rewards committing to multiple guardians instead of one strong one.                                 |
| Guardian Captain   | III  | A single unique guardian raising the power and magic defence of every other guardian in the village.     | Gold, very large, one per village.                        | Guardian Barracks, two guardians         | Cannot stack; a village may station only one regardless of level.                                   |
| Sentinel Automaton | III  | A construct guardian immune to seasonal decay, requiring no upkeep.                                       | Gold, very large, escalates with automatons already held.| Guardian Barracks, Elite Guardian        | Expensive and immobile: it cannot be reassigned to another village once placed.                     |

## Offline defence

| Name                | Tier | Effect                                                                                                             | Cost shape                                                   | Requires                              | Notes                                                                                        |
| ------------------- | ---- | ----------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- | ---------------------------------------- | --------------------------------------------------------------------------------------------- |
| Echo Ward           | I    | Grants a stat bonus to the defending echo only, with no effect while the wizard is online.                              | Gold, escalates with echo wards already held.                    | Capital village                           | Only the capital has an echo, so this upgrade is unavailable anywhere else.                    |
| Alarm Wards         | I    | Automatically raises the village shield the instant a raid begins while the wizard is offline.                         | Gold, escalates with alarm wards already held.                   | A life-stone banked for the village shield | Useless if no life-stone is available to spend when the alarm fires.                           |
| Echo Reinforcement  | II   | Stations a guardian that fights only alongside the echo while the wizard is offline, standing down while they log in.  | Gold, escalates with echo reinforcements already held.           | Capital village, Guardian Barracks        | A guardian slot that exists purely for the hours nobody is watching.                           |
| Nightwatch Lantern  | I    | Reduces how easily other wizards can scout the village on the world map while its owner is offline.                    | Gold, escalates with nightwatch lanterns already held.           | —                                          | Stealth rather than strength: lowers the chance of being found, not damage once found.          |
| Offline Yield Ward  | II   | Pauses wandering-enemy damage to crop fields for a limited daily window while the wizard is offline.                    | Gold, escalates with offline yield wards already held.           | A crop field                              | Protects against wildlife only; a wizard raider ignores this ward entirely.                     |
| Decay Anchor        | II   | Slows the echo's seasonal decay while the wizard stays logged out for an extended stretch.                             | Gold, escalates with decay anchors already held.                 | Capital village                           | Addresses decay from long absences specifically, not decay from normal re-raid cycles.          |
| Echo's Last Stand   | III  | If the echo falls while the wizard is offline, automatically spends a banked life-stone to raise the village shield.   | Gold, very large, plus a banked life-stone to trigger.           | Capital village, a life-stone banked      | Powerful but entirely dependent on a life-stone sitting unspent when it is needed.               |

## Utility and quality of life

| Name               | Tier | Effect                                                                                       | Cost shape                                              | Requires                 | Notes                                                                                   |
| ------------------ | ---- | ------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- | --------------------------- | ------------------------------------------------------------------------------------------ |
| Signpost Shrine    | I    | Shortens travel time between this village and the wizard's other holdings.                        | Gold, escalates with signpost shrines already held.        | —                            | Pure convenience, no combat or income effect.                                              |
| Storage Expansion  | I    | Raises the cap on gold the village can hold locally before overflow transfers away.               | Gold, escalates with storage expansions already held.      | —                            | Interacts with Treasury Vault: more gold held locally is also more gold exposed to a raid.  |
| Trade Exchange     | II   | Small discount on goods bought from nearby NPC villages.                                          | Gold, escalates with trade exchanges already held.         | —                            | Minor economic convenience, no effect on this village's own income or defence.              |
| Capital Beacon     | I    | Shortens the teleport animation on logout and login for the capital village.                      | Gold, one-time.                                            | Capital village              | Cosmetic convenience tied specifically to the teleport-on-logout mechanic.                   |
| Harvest Almanac    | I    | Shows a forecast of the next season's transition and expected crop yield.                         | Gold, one-time.                                            | A crop field                 | Information only; it changes no yield, it only lets the wizard plan around it.              |
| Shared Vault       | II   | Routes gold overflow from one village automatically into another village's storage.               | Gold, escalates with shared vaults already held.           | A second village             | Only relevant once a wizard holds more than one village, itself a level-2 requirement.      |
| Trophy Hall        | I    | A purely cosmetic display of the wizard's achievements inside the village.                        | Gold, escalates with trophy halls already held.            | —                            | No mechanical effect of any kind; a prestige option rather than a power option.              |

## Risky or conditional

| Name                  | Tier | Effect                                                                                                       | Cost shape                                                        | Requires               | Notes                                                                                             |
| --------------------- | ---- | ------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------ |
| Bounty Board          | I    | Passive gold trickle, paid for every wandering enemy a guardian kills near the village.                            | Gold, escalates with bounty boards already held.                    | Guardian Barracks           | Also raises how often wandering enemies spawn nearby, feeding its own payout and its own risk together. |
| Smuggler's Cache      | II   | A hidden stash that pays out a bonus if a raid against the village is successfully repelled.                       | Gold, escalates with smuggler's caches already held.                 | —                           | Pure gamble on the defence outcome: no benefit at all if the village is never raided.                   |
| Provoke Rival Banner  | I    | Deliberately raises how often other wizards choose to raid this village, for amplified gold income while it stands. | Gold, escalates with provoke banners already held.                   | —                           | Opt-in PvP magnet; does nothing to wandering-enemy raid frequency, only wizard-versus-wizard.             |
| Unstable Rune Conduit | III  | Grants one random, strong bonus each season, drawn against the wizard's luck stat.                                 | Gold, very large, escalates with conduits already held.              | —                           | The bonus can occasionally be a drawback instead, by design; luck improves the odds, not the guarantee.  |
| Overharvest Decree    | II   | Forces an immediate yield burst from every crop field this season.                                                 | Gold, escalates with overharvest decrees issued this run.            | A crop field                | Every decreed field yields nothing the following season, regardless of what season that is.             |
| Echo Aggression Rite  | II   | Sets the defending echo's offline behaviour to maximum aggression, raising its effective power against a raider.  | Gold, escalates with aggression rites already held.                  | Capital village             | An aggressive echo can be lured away by a second raider, leaving guardians and crops undefended.          |
| Winter Gambit Silo    | III  | Banks surplus crop yield from summer and autumn that would otherwise be lost to winter dormancy.                   | Gold, very large, one per village.                                   | Two mature crop fields      | The entire banked reserve is lost at once if the silo itself is destroyed, a single exposed structure.   |

## Notes for balancing

This document holds 59 distinct upgrades, 14 of them crop-related, across seven categories.
Volume is deliberate: it is a list to cut from, not a minimal sample.

Honest flags, in no particular order:

- ⬜ **Does a village keep its upgrades when stolen?**
  The brief states a village can be raided, stolen and destroyed, by wizards and by wandering
  NPC enemies alike.
  A tower that a wizard must give up is ruined, losing its upgrades, while the village's
  upgrades survive — but that rule is written for the *losing* wizard giving up a tower, not for
  a village changing hands outright.
  Whether a stolen village's upgrades transfer intact to the new owner, degrade, or reset is
  not decided anywhere, and several entries here (Grand Bazaar, Bastion Wall, Elite Guardian)
  are expensive enough that the answer changes how worthwhile they are.
- ⬜ **Does stealing a village require the NPC case to work differently from the wizard case?**
  A wandering NPC enemy stealing a village implies some NPC-controlled ownership state that is
  not described elsewhere in the glossary.
  This document assumes it exists but does not design it.
- ⬜ **How many crop fields can one village hold?**
  Several upgrades (Firebreak Trenches, Seasonal Seed Vault, Harvest Festival Banner, Winter
  Gambit Silo) assume multiple fields per village, and Firebreak Trenches is meaningless with
  only one.
  A hard cap, or the lack of one, changes how strong a fully invested crop village can become.
- ⬜ **Does stored gold actually get plundered on a successful raid?**
  Treasury Vault, Market Insurance and part of Storage Expansion's note all assume raiders can
  steal a cut of a village's banked gold.
  The brief says villages "can be raided... and destroyed," but does not confirm gold capture as
  a mechanic; if it is not one, those three entries need new justifications.
- ⬜ **Is there an actual raid-probability system, or is "attracts more raids" flavour text?**
  Grand Bazaar, Gilded Banner, Harvest Festival Banner and Provoke Rival Banner all assume a
  village's visible wealth or banner status measurably changes how often it gets targeted.
  If no such system exists yet, these upgrades need one built before they can ship as anything
  more than cosmetic.
- 🔴 **Likely overpowered: Echo's Last Stand.**
  Automatically spending a life-stone to save the capital reads as very strong for a resource
  the wizard is meant to hoard across a whole run; it may need to cost two life-stones, or only
  trigger once per season, or not exist at all if the designer wants life-stone scarcity to bite.
- 🔴 **Possible design tension: Crop Shield.**
  It intentionally copies the village shield's function but pays in gold instead of a
  life-stone, specifically so crops do not compete with the village for the player's scarce
  life-stones.
  That is also exactly the kind of thing that could make the real village shield feel
  pointless by comparison if Crop Shield is tuned too strong — worth a second look once both
  exist.
- 🟡 **Likely underpowered or filler: Trophy Hall, Harvest Almanac, Capital Beacon.**
  Included because the quality-of-life category needs entries with no mechanical trade-off at
  all, but none of the three should take a meaningful development slot ahead of anything with
  an actual effect.
- 🟡 **Overlap worth merging: Market Insurance and Treasury Vault.**
  Both exist to blunt the same loss — stolen stored gold — through different mechanisms
  (refund after the fact versus protection beforehand).
  One of the two is probably redundant once the stored-gold mechanic above is actually decided.
- ⬜ **Guardian cap sharing between village and crop guardians.**
  Harvest Watch and Mounted Guardian are guardians stationed specifically for crop fields.
  Whether they draw from the same Guardian Barracks capacity as Militia/Veteran/Elite
  Guardian, or from a separate crop-only pool, is not decided, and changes whether investing in
  crop defence competes with investing in village defence.
- ⬜ **Exact guardian stat values.**
  Guardian entries describe strength only by rough tier comparison (critter- to elite-tier).
  Actual numbers need a pass once guardians are confirmed as their own stat-block entity rather
  than a reuse of an existing enemy tier.
