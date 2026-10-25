# Dungeons — Wizards Towers

- [Dungeons — Wizards Towers](#dungeons--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [What a dungeon is](#what-a-dungeon-is)
  - [How difficulty is expressed](#how-difficulty-is-expressed)
  - [Summary table](#summary-table)
  - [The Hollow Crypts](#the-hollow-crypts)
  - [Ashfall Bandit Hold](#ashfall-bandit-hold)
  - [Thistlewake Grove](#thistlewake-grove)
  - [Bramblefang Warren](#bramblefang-warren)
  - [The Drowned Shaft](#the-drowned-shaft)
  - [Rustbelly Hive](#rustbelly-hive)
  - [Mournwillow Fen](#mournwillow-fen)
  - [Cinder Rift](#cinder-rift)
  - [Blackroot Bandit Fort](#blackroot-bandit-fort)
  - [Skyreach Spire](#skyreach-spire)
  - [Suncoil Ruins](#suncoil-ruins)
  - [The Gilded Hoard](#the-gilded-hoard)
  - [The Silt Cisterns](#the-silt-cisterns)
  - [Frostfang Caverns](#frostfang-caverns)
  - [Cindermaw Forge](#cindermaw-forge)
  - [Notes for balancing](#notes-for-balancing)

## How to read this document

This is a content list, not an implementation spec.
Every dungeon below is a self-contained combat encounter: a short identity paragraph, a room-by-room table, and a line on what completion drops.
The summary table lets a designer scan all fifteen entries before drilling into one.
Room tables use four fixed columns — **Room**, **What is there**, **Enemies**, **Notes** — so every dungeon reads the same way regardless of theme.
Enemy entries always carry a tier from the shared tier scale below, and an attack type of either `melee` or `magic`, per the project's single `power` stat convention.
Where an enemy's numbers deviate from its tier by more than a token amount, the Notes column says why, capped at the ±25 % allowed by the tier scale.

This document covers **combat dungeons only**.
The puzzle variant, the maze, is documented elsewhere and is not repeated here.

A naming note worth flagging up front: the theme **ruined wizard tower** is flavour only.
It does not refer to the mechanical `Tower` entity that a village builds for mana income, and it is never the Monolith.
Two dungeons below use this theme and their in-fiction name is simply "a tower that used to belong to a wizard," nothing more.

## What a dungeon is

A dungeon is an **instanced** PvE location on the world map.
It is safe from other wizards — there is no PvP inside.
That safety is a deliberate design feature: a dungeon is the one place a wizard can slow down, read a room, and not get ambushed by a rival mid-fight.
A handful of the dungeons below then deliberately undercut that safety with a time-pressure or lingering gimmick, which is the point — the dungeon is still PvE-safe, but it is not passive-safe.
Entering any dungeon permanently breaks a level-1 wizard's peace shield, the same as their first attack or reaching level 2 does.
A level-1 wizard who steps through a dungeon entrance has chosen to leave newcomer protection behind.
Exactly one dungeon entrance in the world only opens during a specific season; every other entrance is open all run.
Completing a dungeon grants experience, gold, runes and reincarnation points, plus a chance — never a guarantee — at a mana-stone or a life-stone.
Those two consumables are scarce by design: a wizard sees three to five mana-stones and two to three life-stones across an entire run, so no single dungeon can be relied on to produce one.

## How difficulty is expressed

Three things set a dungeon's difficulty, in order of how much they matter:

1. **Recommended level**, a rough wizard-level band for a comfortable solo clear.
2. **Enemy tier mix per room**, which escalates from the entrance toward the final room.
3. **The final room**, which is always either one champion-tier enemy or a small group of elite-tier enemies whose combined threat is roughly equivalent.

The enemy tier scale is fixed across every document in the project:

| Tier         | health | power | magic defence | speed | luck | Role                                      |
| ------------ | -----: | ----: | ------------: | ----: | ---: | ----------------------------------------- |
| **critter**  |     30 |     4 |             2 |   110 |    1 | Trivial. Fills space, teaches mechanics.  |
| **common**   |     80 |     9 |             5 |   100 |    2 | The ordinary enemy of the open world.     |
| **veteran**  |    200 |    18 |            12 |   100 |    3 | A real fight for a mid-run wizard.        |
| **elite**    |    450 |    34 |            22 |   105 |    5 | Dangerous alone, lethal in a pair.        |
| **champion** |    900 |    60 |            40 |   100 |    8 | The "strong enemy". Dungeon-end material. |

A level-1 wizard with no talents is the baseline these numbers are measured against: health 100, power 10, mana pool 50, magic defence 10, speed 100, luck 5.

## Summary table

| Name                  | Rooms | Recommended level | Theme               | Final enemy                          | Season      |
| --------------------- | ----: | ----------------- | ------------------- | ------------------------------------ | ----------- |
| The Hollow Crypts     |     4 | 2 – 4             | Crypts              | Crypt Warden (champion)              | Any         |
| Ashfall Bandit Hold   |     5 | 3 – 5             | Bandit fort         | The Pass Reaver (champion)           | Any         |
| Thistlewake Grove     |     5 | 4 – 6             | Fae grove           | Grove Matriarch (champion)           | Any         |
| Bramblefang Warren    |     6 | 4 – 7             | Beast warren        | Alpha Direwolf (champion)            | Any         |
| The Drowned Shaft     |     6 | 5 – 8             | Flooded mines       | The Drowned Colossus (champion)      | Any         |
| Rustbelly Hive        |     5 | 5 – 8             | Beast warren        | Hive Queen (champion)                | Any         |
| Mournwillow Fen       |     6 | 6 – 9             | Fae grove           | The Willow Widow (champion)          | Any         |
| Cinder Rift           |     6 | 6 – 9             | Elemental rift      | The Ember Hunter (champion)          | Any         |
| Blackroot Bandit Fort |     7 | 7 – 10            | Bandit fort         | Bandit Warlord (champion)            | Any         |
| Skyreach Spire        |     7 | 7 – 10            | Ruined wizard tower | The Unbound Archmage (champion)      | Any         |
| Suncoil Ruins         |     6 | 8 – 11            | Ruined wizard tower | The Arc Warden (champion)            | Any         |
| The Gilded Hoard      |     7 | 8 – 11            | Crypts              | The Hoardwarden (champion)           | Any         |
| The Silt Cisterns     |     5 | 9 – 12            | Flooded mines       | The Silt Behemoth (champion)         | Any         |
| Frostfang Caverns     |     8 | 10 – 13           | Elemental rift      | The Frost Sovereign (champion)       | Winter only |
| Cindermaw Forge       |     9 | 11 – 14           | Elemental rift      | The Cindermaw Triumvirate (3 elites) | Any         |

## The Hollow Crypts

A burial ground predating the current villages, four low chambers cut into a hillside.
This is the dungeon the design brief treats as a baseline: no gimmick, a clean escalation from critter to champion, built to teach a new wizard what a dungeon run feels like.
Every enemy here is undead, melee-leaning, and slow by design so a level-2 wizard can read their attacks.

| Room             | What is there                                  | Enemies                                                         | Notes                                                                  |
| ---------------- | ---------------------------------------------- | --------------------------------------------------------------- | ---------------------------------------------------------------------- |
| Entrance alcove  | Collapsed stairwell, a few open sarcophagi.    | 3× Grave Husks (critter, melee)                                 | Teaches the room-clear loop.                                           |
| Bone ossuary     | Walls stacked floor to ceiling with remains.   | 4× Grave Husks (critter, melee), 1× Rot Acolyte (common, magic) | The acolyte casts from the back row; kill it first or eat chip damage. |
| Sealed vault     | A cracked stone door, runes scratched over it. | 2× Bound Skeletons (common, melee)                              | Small gimmick: the door only opens once both skeletons are down.       |
| Warden's chamber | A raised dais, cold air, a single stone seat.  | Crypt Warden (champion, magic)                                  | Opens with a ranged volley the moment the door is breached.            |

**Drops:** experience, gold and common-to-rare runes scaled to level 2 – 4, a flat reincarnation point award, and a small chance at a mana-stone.
No life-stone chance here — the dungeon is intentionally too low-stakes to justify one.

## Ashfall Bandit Hold

A collapsed mountain waystation a bandit company converted into a toll post.
No gimmick, early-game pacing: five rooms that go from scattered lookouts to the bandit captain's own hall.
Carried gold is irrelevant here — that pressure belongs to The Gilded Hoard, not this dungeon.

| Room                  | What is there                              | Enemies                                                           | Notes                                                            |
| --------------------- | ------------------------------------------ | ----------------------------------------------------------------- | ---------------------------------------------------------------- |
| Toll gate             | A barricade of cart wreckage.              | 2× Hold Scouts (critter, melee)                                   | Scouts flee at low health instead of fighting to the end.        |
| Barracks              | Bunks, a cold firepit.                     | 3× Hold Raiders (common, melee)                                   | Standard group fight, no twist.                                  |
| Armoury               | Racked weapons, most already taken.        | 2× Hold Raiders (common, melee), 1× Hold Marksman (common, magic) | Marksman uses thrown fire; break line of sight behind the racks. |
| Captain's antechamber | A locked strongbox, empty.                 | 1× Hold Lieutenant (veteran, melee)                               | A real fight for a level-4 wizard, by design.                    |
| Captain's hall        | A long table, a banner of a torn standard. | The Pass Reaver (champion, melee)                                 | No reinforcements, no gimmick — a clean final fight.             |

**Drops:** experience, gold and common-to-rare runes scaled to level 3 – 5, a flat reincarnation point award, and a small-to-moderate chance at a mana-stone.

## Thistlewake Grove

A pocket of old-growth forest the fae never let go wild.
**Gimmick — reinforcement on lingering:** every room here is watched.
Spend too long clearing a single room and the canopy answers: additional critter-tier fae drop in from above, specific to that room, resetting once the room is cleared.
The grove rewards a fast, decisive clear over a cautious one, which is the opposite lesson from Blackroot Bandit Fort's fort-wide alarm.

| Room                  | What is there                          | Enemies                                                            | Notes                                                                                      |
| --------------------- | -------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ |
| Mossgate              | A ring of standing stones, soft light. | 3× Wisp Motes (critter, magic)                                     | Lingering reinforcement: two more Wisp Motes drop in after a short delay.                  |
| The Weeping Birches   | Pale trees that bleed faint sap.       | 2× Thistle Sprites (common, magic), 2× Wisp Motes (critter, magic) | Same lingering rule; sprites blink erratically, making a slow clear likelier here.         |
| Hollow of Antlers     | A clearing ringed in shed antlers.     | 1× Antler Warden (veteran, melee)                                  | Single enemy, no reinforcement risk — a breather room.                                     |
| The Drowsing Pool     | Still water reflecting no sky.         | 3× Thistle Sprites (common, magic)                                 | Lingering reinforcement escalates faster here: the delay before reinforcements is shorter. |
| The Matriarch's Bower | A throne woven from living branches.   | Grove Matriarch (champion, magic)                                  | The lingering rule does not apply in the final room — this fight is a straight one.        |

**Drops:** experience, gold and common-to-rare runes scaled to level 4 – 6, a flat reincarnation point award, and a moderate chance at a mana-stone.
Small chance at a life-stone, reflecting the grove's reputation as a healing place twisted into a trap.

## Bramblefang Warren

A den system dug through a bramble thicket, home to a wolf pack grown too large for the surrounding woods.
**Gimmick — any order:** the warren is a hub with four side-dens branching off it, clearable in whatever order the wizard chooses.
None of the four affect each other's enemies or difficulty, and nothing escalates by skipping one for later.
The den core only opens once all four side-dens are cleared, regardless of order.

| Room          | What is there                                   | Enemies                                                             | Notes                                                                     |
| ------------- | ----------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Warren hub    | A wide earthen chamber, four tunnel mouths.     | none                                                                | Pure navigation room; the four side-dens are chosen from here, any order. |
| Den of Claws  | Scratched support beams, gnawed bone.           | 3× Fang Pups (critter, melee)                                       | Side-den 1 of 4, order-independent.                                       |
| Den of Howls  | An open-air sinkhole above.                     | 2× Brambleback Wolves (common, melee)                               | Side-den 2 of 4, order-independent.                                       |
| Den of Roots  | Roots breaking through the tunnel ceiling.      | 2× Brambleback Wolves (common, melee), 1× Fang Pup (critter, melee) | Side-den 3 of 4, order-independent.                                       |
| Den of Marrow | A bone midden stacked by generations of wolves. | 1× Packmaster (veteran, melee)                                      | Side-den 4 of 4, order-independent — the only one with a veteran.         |
| The Deep Den  | A sunken pit, warm with animal breath.          | Alpha Direwolf (champion, melee)                                    | Final room, unlocked only once all four side-dens are cleared.            |

**Drops:** experience, gold and common-to-rare runes scaled to level 4 – 7, a flat reincarnation point award, and a moderate chance at a mana-stone.

## The Drowned Shaft

A mineshaft the water table reclaimed decades ago, still worked by whatever moved in after the miners left.
**Gimmick — flooded, speed halved:** every room past the entrance is underwater or ankle-to-waist deep, and the flooding applies a flat halving to every wizard's effective speed for the whole dungeon.
Enemies tagged aquatic are exempt from the penalty, which is what makes the back half of the dungeon feel like it is hunting a slowed target rather than fighting an equal.

| Room                   | What is there                                         | Enemies                                                                      | Notes                                                                                    |
| ---------------------- | ----------------------------------------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Flooded entrance shaft | Knee-deep water, a broken ore cart.                   | 3× Shaft Crawlers (critter, melee, aquatic)                                  | Aquatic tag: unaffected by the speed halving that already applies to the wizard.         |
| The Sump               | Waist-deep standing water, floating debris.           | 3× Drowned Diggers (common, melee)                                           | Non-aquatic; these feel the halving too, so the fight is not as lopsided as it looks.    |
| Flooded gallery        | A long horizontal tunnel, water to the chest.         | 2× Drowned Diggers (common, melee), 1× Current Wisp (common, magic, aquatic) | Current Wisp is aquatic and noticeably faster-feeling than the wizard here.              |
| The Cistern Vault      | A dry raised platform above the waterline.            | 1× Deep Warden (veteran, melee, aquatic)                                     | The one dry room; speed returns to normal while standing on the platform.                |
| Lower flood chamber    | Water nearly to the ceiling, visible only in patches. | 2× Current Wisps (common, magic, aquatic)                                    | Visibility gimmick on top of the speed one: enemies here are only visible when adjacent. |
| The Drowned Hall       | A cavern lit by phosphorescent fungus.                | The Drowned Colossus (champion, melee, aquatic)                              | The Colossus is aquatic and fights at full speed while the wizard remains halved.        |

**Drops:** experience, gold and common-to-rare runes scaled to level 5 – 8, a flat reincarnation point award, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## Rustbelly Hive

An insect warren burrowed into a riverbank, growing louder the deeper a wizard goes.
No special gimmick, but the enemy composition itself is the lesson: swarms of critters that look trivial individually and are not trivial in aggregate.

| Room               | What is there                                            | Enemies                                                                  | Notes                                                                     |
| ------------------ | -------------------------------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| Hive mouth         | A crumbling riverbank opening, webbing strung across it. | 5× Rustbelly Nymphs (critter, melee)                                     | A deliberately wide swarm room to teach area damage value.                |
| Egg gallery        | Rows of pale egg clusters along both walls.              | 4× Rustbelly Nymphs (critter, melee), 1× Rustbelly Drone (common, magic) | Breaking egg clusters denies a later reinforcement wave, a small gimmick. |
| Silk chamber       | Thick curtains of silk cocoon the far wall.              | 3× Rustbelly Drones (common, magic)                                      | Ranged swarm, forces the wizard to close distance or trade hits.          |
| The Larder         | Stored carcasses, a strong smell.                        | 1× Rustbelly Brood-warden (veteran, melee)                               | Single strong enemy, a breather after two swarm rooms.                    |
| The Queen's Hollow | A pulsing chamber at the hive's centre.                  | Hive Queen (champion, magic)                                             | Summons single critter-tier Nymphs periodically through the fight.        |

**Drops:** experience, gold and common-to-rare runes scaled to level 5 – 8, a flat reincarnation point award, and a moderate chance at a mana-stone.

## Mournwillow Fen

A sunken swamp grove the local fae abandoned generations ago, now home to something sadder and angrier.
**Small gimmick:** the Fog Hollow room is wrapped in a standing fog that hides every enemy until the wizard is adjacent to it, forcing blind engagement rather than a ranged opening volley.

| Room               | What is there                                      | Enemies                                                       | Notes                                                                             |
| ------------------ | -------------------------------------------------- | ------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Sunken causeway    | A half-submerged log bridge.                       | 3× Fen Wisps (critter, magic)                                 | Standard opener.                                                                  |
| The Reedbed        | Reeds taller than a wizard, rustling with no wind. | 3× Bog Stalkers (common, melee)                               | Stalkers prefer flanking; expect to be surrounded rather than lined up.           |
| Fog Hollow         | A clearing wrapped in unmoving fog.                | 2× Bog Stalkers (common, melee), 1× Fen Wisp (critter, magic) | Gimmick room: enemies are invisible until adjacent, so the opening hit is theirs. |
| The Drowned Shrine | A cracked fae shrine, half underwater.             | 1× Shrine Warden (veteran, magic)                             | No gimmick here, a straight single-enemy fight.                                   |
| Willow Approach    | Weeping willows bent low over black water.         | 2× Bog Stalkers (common, melee)                               | Last breather room before the final fight.                                        |
| The Widow's Hollow | A ring of dead willow roots, pale light.           | The Willow Widow (champion, magic)                            | Fights entirely at range; closing distance is the main challenge.                 |

**Drops:** experience, gold and common-to-rare runes scaled to level 6 – 9, a flat reincarnation point award, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## Cinder Rift

A tear in the world where the elemental plane of fire bleeds through into open rock.
**Gimmick — the final enemy is awake from the start and hunts:** The Ember Hunter does not wait in the last room.
It patrols the whole dungeon from the moment the entrance opens and can ambush the wizard in any earlier room.
Reaching the final room guarantees a confrontation; it does not start one — the Hunter may already have found the wizard well before that.

| Room                 | What is there                                      | Enemies                                                             | Notes                                                                                       |
| -------------------- | -------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| Rift mouth           | Cracked basalt, heat shimmer.                      | 2× Cinder Motes (critter, magic)                                    | The Ember Hunter may already be present here; it is not guaranteed.                         |
| The Glass Flat       | Obsidian sheet, cooling lava beneath a thin crust. | 3× Cinder Motes (critter, magic), 1× Ash Skirmisher (common, melee) | Floor cracks under sustained standing; keep moving or take chip damage, a small gimmick.    |
| Smoulder Gallery     | A tunnel choked with slow-moving smoke.            | 2× Ash Skirmishers (common, melee)                                  | Smoke limits visibility slightly; not a hard mechanic, just flavour pressure.               |
| The Ember Vault      | A sealed door scorched black.                      | 1× Rift Warden (veteran, magic)                                     | Breather room, no Hunter encounter scripted here.                                           |
| Collapsed Forge Hall | A ruined forge, tools fused to their benches.      | 2× Ash Skirmishers (common, melee)                                  | High-likelihood Hunter ambush point if it has not appeared yet.                             |
| The Rift's Heart     | A column of standing fire at the dungeon's centre. | The Ember Hunter (champion, magic)                                  | Guaranteed confrontation here regardless of whether it already ambushed the wizard earlier. |

**Drops:** experience, gold and common-to-rare runes scaled to level 6 – 9, a flat reincarnation point award, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## Blackroot Bandit Fort

A proper fortified bandit holding, built into an old quarry wall, with a working alarm system.
**Gimmick — punishes slow clearing, fort-wide:** the fort tracks a single alert level across the whole run, not per room.
Clearing a room slowly raises the alert level; every room entered afterward spawns additional common-tier reinforcements for each alert step still active, and if the alert is maxed by the time the wizard reaches the Warlord, he enters the fight with an extra veteran-tier guard already present.
This is a global, accumulating version of the same pressure Thistlewake Grove applies locally per room.

| Room                | What is there                                 | Enemies                                                             | Notes                                                                                            |
| ------------------- | --------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| Quarry gate         | A broken portcullis, a disused alarm bell.    | 2× Fort Guards (common, melee)                                      | Alarm level starts at zero; a slow clear here sets it to one.                                    |
| Lower bailey        | An open yard, crates and a watch tower stub.  | 3× Fort Guards (common, melee)                                      | Each active alert step adds one Fort Guard to this room's spawn.                                 |
| The Armsmith's Hall | Racked weapons, half already distributed.     | 2× Fort Guards (common, melee), 1× Fort Marksman (common, magic)    | Same escalation rule applies here.                                                               |
| Inner stair         | A narrow, defensible stairwell.               | 1× Fort Sergeant (veteran, melee)                                   | A deliberate chokepoint; alert reinforcements stack up behind the sergeant if the alarm is high. |
| Captain's war room  | Maps pinned to every wall, a half-eaten meal. | 1× Fort Sergeant (veteran, melee), 1× Fort Marksman (common, magic) | Last chance to clear fast and let the alert level decay before the final room.                   |
| Powder store        | Sealed barrels, handled carefully.            | 2× Fort Guards (common, melee)                                      | Avoid lingering: every alert step still active adds a Fort Guard here too.                       |
| The Warlord's Hall  | A throne built from stacked shields.          | Bandit Warlord (champion, melee)                                    | At max alert, an extra Fort Sergeant (veteran) joins the Warlord at the start of the fight.      |

**Drops:** experience, gold and common-to-rare runes scaled to level 7 – 10, a flat reincarnation point award, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## Skyreach Spire

A wizard's tower, collapsed at the top and leaning hard, its upper floors still structurally live.
**Gimmick — a room that must be crossed without casting:** the Silence Hall carries an anti-magic ward that nullifies spellcasting entirely.
A wizard's weapon still functions there — the ward blocks spells, not the weapon a wizard holds — so the room is cleared by melee contact alone.
Enemy tiers in that one room are kept to critter and common specifically to compensate for the lost spellcasting.

| Room                  | What is there                                      | Enemies                                                                            | Notes                                                                                                      |
| --------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Collapsed entry hall  | Rubble from the tower's lower floors.              | 2× Spire Wisps (critter, magic)                                                    | Standard opener, full spellcasting available.                                                              |
| The Scribe's Landing  | Scattered unbound pages, ink long dried.           | 3× Wardbound Constructs (common, magic)                                            | Standard room, no gimmick yet.                                                                             |
| Silence Hall          | A perfectly circular room, wards etched underfoot. | 3× Wardbound Constructs (common, melee only), 2× Spire Wisps (critter, melee only) | Gimmick room: no spellcasting functions here; weapon strikes only, for the wizard and these enemies alike. |
| The Fractured Stair   | A staircase split by the tower's lean.             | 1× Spire Sentinel (veteran, magic)                                                 | Spellcasting returns on leaving Silence Hall.                                                              |
| Observatory floor     | A shattered dome open to the sky.                  | 2× Wardbound Constructs (common, magic)                                            | Breather room before the top floor.                                                                        |
| The Archivist's Vault | Locked cabinets, one forced open already.          | 1× Spire Sentinel (veteran, magic), 1× Wardbound Construct (common, magic)         | Last room before the top; no gimmick.                                                                      |
| The Shattered Study   | The tower's top floor, open to the wind.           | The Unbound Archmage (champion, magic)                                             | Full spellcasting available again; the ward does not reach this high.                                      |

**Drops:** experience, gold and common-to-rare runes scaled to level 7 – 10, a flat reincarnation point award, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## Suncoil Ruins

A second wizard's tower, this one toppled sideways into desert sand rather than collapsed in place.
No gimmick: a straightforward mid-to-late escalation built around construct enemies rather than undead or beasts, to vary the dungeon's texture from Skyreach Spire.

| Room                 | What is there                                    | Enemies                                                                 | Notes                                                  |
| -------------------- | ------------------------------------------------ | ----------------------------------------------------------------------- | ------------------------------------------------------ |
| Sand-choked entry    | Dunes have half-buried the original doorway.     | 3× Suncoil Wisps (critter, magic)                                       | Standard opener.                                       |
| The Sundial Hall     | A cracked sundial dominates the floor.           | 2× Suncoil Constructs (common, melee)                                   | Constructs track the sundial's shadow; flavour only.   |
| Buried archive       | Shelves sunk at an angle, half-filled with sand. | 2× Suncoil Constructs (common, melee), 1× Suncoil Adept (common, magic) | Standard mixed room.                                   |
| The Leaning Gallery  | A corridor tilted thirty degrees from true.      | 1× Suncoil Warden (veteran, melee)                                      | Single strong enemy, footing is the only complication. |
| Collapsed laboratory | Broken alembics, dried reagents underfoot.       | 2× Suncoil Adepts (common, magic)                                       | Standard room, no gimmick.                             |
| The Arc Chamber      | A half-buried ring of standing stones, humming.  | The Arc Warden (champion, magic)                                        | Straight final fight.                                  |

**Drops:** experience, gold and common-to-rare runes scaled to level 8 – 11, a flat reincarnation point award, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## The Gilded Hoard

A crypt built by a wizard obsessed with wealth, sealed with his collection still inside.
**Gimmick — harder for a wizard carrying gold:** the Gold Wraiths native to this crypt sense carried wealth and scale their aggression and spawn density to it.
A wizard who spent down to near-zero gold before entering passes through quietly; a wizard carrying a large reserve draws a noticeably harder version of every room.
The exact scaling curve against gold carried is undecided — see Notes for balancing.

| Room                   | What is there                                      | Enemies                                                                 | Notes                                                                              |
| ---------------------- | -------------------------------------------------- | ----------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Antechamber of coin    | Scattered coin, deliberately left as bait.         | 1 – 3× Gold Wraiths (common, magic)                                     | Count here scales with carried gold: low gold spawns one, high gold spawns three.  |
| The Ledger Hall        | Shelves of account books, gilded spines.           | 2 – 4× Gold Wraiths (common, magic)                                     | Same scaling rule.                                                                 |
| Vault of Small Things  | Display cases of minor treasure, mostly empty now. | 1× Hoard Sentinel (veteran, melee), 1 – 2× Gold Wraiths (common, magic) | Sentinel count is fixed; only the Wraith count scales with gold.                   |
| The Counting Room      | A single enormous abacus, frozen mid-count.        | 2× Hoard Sentinels (veteran, melee)                                     | No gold scaling in this room — a fixed, hard room regardless of wealth.            |
| The Appraiser's Study  | A desk stacked with valuation ledgers.             | 1× Hoard Sentinel (veteran, melee), 1 – 3× Gold Wraiths (common, magic) | Gold scaling returns here.                                                         |
| Treasury threshold     | A door cast from a single sheet of gold.           | 2× Hoard Sentinels (veteran, melee)                                     | No scaling; a breather before the final room regardless of wealth carried.         |
| The Hoardwarden's Seat | A mountain of coin, the throne buried in it.       | The Hoardwarden (champion, magic)                                       | The Hoardwarden itself does not scale with gold — only the rooms leading to it do. |

**Drops:** experience, gold and common-to-rare runes scaled to level 8 – 11, a flat reincarnation point award, and a moderate chance at a mana-stone.
Small chance at a life-stone.
A wizard who enters wealthy and survives earns a visibly larger gold drop than one who entered poor, which is the dungeon's whole point.

## The Silt Cisterns

A second flooded mine, deeper and older than The Drowned Shaft, partially drained rather than fully submerged.
No speed-halving gimmick here — only the lowest two rooms hold standing water, giving variety against The Drowned Shaft rather than repeating its mechanic.

| Room                  | What is there                                   | Enemies                                                             | Notes                                                                |
| --------------------- | ----------------------------------------------- | ------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Dry entrance tunnel   | Cracked support beams, no standing water.       | 2× Silt Crawlers (critter, melee)                                   | No flooding yet; full speed throughout.                              |
| The Drained Gallery   | A chamber that was recently pumped out.         | 3× Silt Crawlers (critter, melee), 1× Cistern Diver (common, magic) | Still dry, standard room.                                            |
| The Pump House        | Rusted machinery, long abandoned.               | 1× Cistern Warden (veteran, melee)                                  | Last dry room before the flooded lower level.                        |
| Lower flooded cistern | Standing water, waist deep.                     | 2× Cistern Divers (common, magic, aquatic)                          | Flooding begins here; no dungeon-wide speed halving, just this room. |
| The Silt Floor        | A shallow, silty basin at the cistern's bottom. | The Silt Behemoth (champion, melee, aquatic)                        | Final room is flooded; the Behemoth is aquatic and unaffected.       |

**Drops:** experience, gold and common-to-rare runes scaled to level 9 – 12, a flat reincarnation point award, and a moderate chance at a mana-stone.
Moderate chance at a life-stone, reflecting the higher recommended level.

## Frostfang Caverns

A glacial cave system that only opens a path through the ice during winter.
**This is the run's single season-gated dungeon entrance.**
The entrance is sealed solid in spring, summer and autumn, and the ice recedes only once winter begins.
Past the entrance there is no further gimmick beyond the season gate itself — the challenge is entirely in the enemy escalation across eight rooms, the longest combat dungeon on this list short of Cindermaw Forge.

| Room                  | What is there                                          | Enemies                                                              | Notes                                                                   |
| --------------------- | ------------------------------------------------------ | -------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Ice-choked entrance   | A tunnel of refrozen meltwater.                        | 3× Frost Motes (critter, magic)                                      | Standard opener.                                                        |
| The Rime Gallery      | Hoarfrost coating every surface.                       | 3× Frostfang Stalkers (common, melee)                                | Standard room.                                                          |
| Frozen waterfall hall | A waterfall frozen mid-fall.                           | 2× Frostfang Stalkers (common, melee), 1× Rime Adept (common, magic) | Standard mixed room.                                                    |
| The Crevasse Crossing | A narrow ice bridge over a dark drop.                  | 1× Crevasse Warden (veteran, melee)                                  | Footing hazard is flavour only, no mechanical penalty.                  |
| The Frost Larder      | Preserved carcasses frozen in the ice walls.           | 2× Rime Adepts (common, magic)                                       | Standard room.                                                          |
| Glacial antechamber   | A chamber lit by trapped light inside the ice.         | 1× Crevasse Warden (veteran, melee), 1× Rime Adept (common, magic)   | Standard mixed room, pre-final breather.                                |
| The Frozen Court      | A ring of ice pillars shaped like a throne room.       | 2× Crevasse Wardens (veteran, melee)                                 | Last room before the final fight, deliberately hard for the level band. |
| The Sovereign's Floe  | A slab of unmelting ice at the cavern's deepest point. | The Frost Sovereign (champion, magic)                                | Straight final fight, no further gimmick.                               |

**Drops:** experience, gold and common-to-rare runes scaled to level 10 – 13, a flat reincarnation point award, and a moderate chance at a mana-stone.
Moderate chance at a life-stone.

## Cindermaw Forge

A volcanic forge-complex built by a long-dead order to work ore no living smith could handle, the longest and hardest combat dungeon on this list.
**Gimmick — the final room holds a small group of elites instead of a single champion:** the Cindermaw Triumvirate is three elite-tier enemies fought together, their combined health and power comfortably exceeding a single champion's, per the tier scale's own warning that a pair of elites is lethal.
Each of the three deviates slightly from the base elite numbers, within the ±25 % allowance, to give them distinct roles.

| Room                       | What is there                                            | Enemies                                                                                                                                                         | Notes                                                                                                           |
| -------------------------- | -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| Forge entrance             | A furnace mouth, cold for the first time in centuries.   | 3× Cindermotes (critter, magic)                                                                                                                                 | Standard opener.                                                                                                |
| The Bellows Hall           | Enormous bellows, long since stilled.                    | 3× Forge-bound Husks (common, melee)                                                                                                                            | Standard room.                                                                                                  |
| The Quenching Pool         | A pool of cooled, blackened metal.                       | 2× Forge-bound Husks (common, melee), 1× Quench Adept (common, magic)                                                                                           | Standard mixed room.                                                                                            |
| The Anvil Floor            | Rows of anvils, hammers still resting on them.           | 1× Forge Warden (veteran, melee)                                                                                                                                | Single strong enemy, breather room.                                                                             |
| The Ember Stacks           | Stacked coal, faintly glowing.                           | 2× Quench Adepts (common, magic)                                                                                                                                | Standard room.                                                                                                  |
| The Smelting Gallery       | Channels for molten ore, long dry.                       | 1× Forge Warden (veteran, melee), 1× Quench Adept (common, magic)                                                                                               | Standard mixed room.                                                                                            |
| The Brand Chamber          | Branding irons for the order's mark, racked on the wall. | 2× Forge Wardens (veteran, melee)                                                                                                                               | Deliberately hard pre-final room.                                                                               |
| The Triumvirate's Approach | A corridor lined with the order's dead.                  | 1× Forge Warden (veteran, melee), 1× Quench Adept (common, magic)                                                                                               | Last breather before the final room.                                                                            |
| The Cindermaw Hearth       | A forge still lit, impossibly, after centuries.          | The Cindermaw Triumvirate — 3× elite (melee, magic, magic), health/power +15 % each, reason: endgame final room needs to clear a single champion's total threat | The three deviate +15 % on health and power each, within the ±25 % tier allowance, to outweigh a lone champion. |

**Drops:** experience, gold and common-to-rare runes scaled to level 11 – 14, a flat reincarnation point award, and the best mana-stone odds on this list.
Moderate-to-good chance at a life-stone, reflecting that this is the hardest combat dungeon documented here.

## Notes for balancing

Honest assessment of what is likely to need a pass, plus what is genuinely undecided rather than guessed at.

- **Likely overpowered:** Blackroot Bandit Fort's max-alert case (an extra veteran guard alongside the Warlord) stacked on top of a champion fight may be too much for the stated level 7 – 10 band.
  Consider either capping the alert bonus below the Warlord room or raising the recommended level.
- **Likely underpowered:** The Hollow Crypts' Crypt Warden fights alone with no room gimmick and no reinforcement — it may read as anticlimactic next to Ashfall Bandit Hold's cleaner but equally simple finish.
  Worth a pass to see if a small flavour mechanic (not a full gimmick) would help without over-complicating the first dungeon a new wizard sees.
- **Likely overpowered:** Frostfang Caverns stacks two veteran-tier Crevasse Wardens in its second-to-last room directly before a champion fight, with no recovery room between them.
  This may be the single hardest non-final room on the whole list and deserves a dedicated playtest pass.
- ⬜ **Open — exact mana-stone and life-stone drop odds per dungeon.**
  This document only ranks dungeons relative to each other (small / moderate / good chance).
  No concrete percentages are set, and none should be invented without a designer decision, given how tightly scarce these two consumables are meant to stay across a run.
- ⬜ **Open — the exact gold-scaling formula for The Gilded Hoard's Gold Wraiths.**
  The dungeon's identity depends on this curve feeling fair at both ends — a wealthy wizard should feel meaningfully punished, not softlocked, and a poor wizard should not feel the gimmick is wasted on them.
  No formula is proposed here.
- ⬜ **Open — reincarnation point formula per dungeon.**
  This document assumes RP award scales with recommended level and room count, but no concrete number or curve is set; that belongs with whoever owns the run-to-RP conversion (see the open **score** question in the glossary).
- ⬜ **Open — whether dungeons support more than one wizard at a time.**
  Every dungeon above is written as a solo encounter.
  If co-op entry is intended, every room's enemy count likely needs a second pass, since none of the tier numbers here assume a second wizard sharing the pull.
- ⬜ **Open — which dungeon should hold the single season-gated entrance.**
  Frostfang Caverns was chosen here because a winter-only ice cavern is the most thematically obvious fit, but this is an arbitrary pick for the purpose of having a complete document, not a settled design decision.
  Swapping it for another dungeon has no mechanical knock-on effect as long as exactly one entrance stays season-gated.
- **Naming tension worth flagging again:** "ruined wizard tower" as a dungeon theme name sits close to the mechanical term `Tower`.
  No code or UI string should ever shorten a dungeon's name to just "the tower" for this reason — Skyreach Spire and Suncoil Ruins both avoid the bare word in their own names deliberately.
- **Volume note:** fifteen dungeons are documented against a brief asking for at least fourteen, specifically so there is a dungeon to cut rather than a minimum to pad up to.
  The Silt Cisterns is the weakest differentiator on the list — it shares a theme and a rough level band with The Drowned Shaft without a gimmick of its own — and is the first candidate if the list needs trimming.
