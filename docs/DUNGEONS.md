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
  - [The Thawroot Burrow](#the-thawroot-burrow)
  - [The Sunheart Bloom](#the-sunheart-bloom)
  - [Vespergrave](#vespergrave)
  - [Cindermaw Forge](#cindermaw-forge)
  - [Notes for balancing](#notes-for-balancing)

## How to read this document

This is a content list, not an implementation spec.
Every dungeon below is a self-contained combat encounter: a short identity paragraph, a room-by-room table, and a line on what completion drops.
The summary table lets a designer scan all thirty entries before drilling into one.
Room tables use four fixed columns — **Room**, **What is there**, **Enemies**, **Notes** — so every dungeon reads the same way regardless of theme.
Enemy entries always carry a tier from the shared tier scale below, and an attack type of either `melee` or `magic`, per the project's single `power` stat convention.
Where an enemy's numbers deviate from its tier by more than a token amount, the Notes column says why, capped at the ±25 % allowed by the tier scale.

This document covers **combat dungeons only**.
The puzzle variant, the maze, is documented elsewhere and is not repeated here.

A naming note worth flagging up front: the theme **ruined wizard tower** is flavour only.
It does not refer to the mechanical `Tower` entity that a village builds for mana income, and it is never the Monolith.
Three dungeons below use this theme and their in-fiction name is simply "a tower that used to belong to a wizard," nothing more.
No code or UI string ever shortens such a dungeon's name to "the tower".

## What a dungeon is

A dungeon is an **instanced** PvE location on the world map.
It is safe from other wizards — there is no PvP inside.
That safety is a deliberate design feature: a dungeon is the one place a wizard can slow down, read a room, and not get ambushed by a rival mid-fight.
A handful of the dungeons below then deliberately undercut that safety with a time-pressure or lingering gimmick, which is the point — the dungeon is still PvE-safe, but it is not passive-safe.
Entering any dungeon permanently breaks a level-1 wizard's peace shield, the same as their first attack or reaching level 2 does.
A level-1 wizard who steps through a dungeon entrance has chosen to leave newcomer protection behind.

**A dungeon stands where its theme belongs.**
Its entrance is placed in the region of the map that matches its theme, as a world boss stands in its own territory.

**One wizard at a time.**
The entrance seals itself by magic once a wizard steps through, and reopens when that wizard leaves or dies.
Nothing stops another wizard from waiting at the entrance.

**Each wizard completes a dungeon once, and it rests for an hour.**
A wizard can complete each dungeon only once per run, so at most 20 over the eight days.
Once a wizard completes an ordinary dungeon, it stays closed to everyone for one hour, then reopens with its enemies and rewards restored for the wizards who have not completed it yet.
A season-gated dungeon never reopens: the first completion closes it for the rest of the run.

**A world draws twenty dungeons.**
At generation, a world draws 20 distinct dungeons at random from this catalogue, so no two worlds offer the same run.
An ordinary dungeon is open from the start of the run.
A season-gated dungeon is never guaranteed to be drawn; when it is, it opens at the start of its own season and closes at its end.

**Season-gated dungeons.**
Each season has at least one dungeon that exists only while that season lasts.
The first wizard to complete it receives a mana-stone and a life-stone, guaranteed, and the dungeon closes for the rest of the run.
When its season ends, the dungeon closes on the spot; a wizard still inside is thrown out at the entrance and gets no completion reward.

**A rest zone follows every third room.**
It holds no enemy, is not counted as a room, and health and mana regenerate there at an accelerated rate.

Completing an ordinary dungeon grants experience, gold and runes, counts toward the wizard's score, and gives a chance — never a guarantee — at a mana-stone or a life-stone.
Those two consumables are scarce by design, so stone odds in dungeons are **low** everywhere.

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

A level-1 wizard with no talents is the baseline these numbers are measured against: health 100, power 10, mana pool 100, magic defence 10, speed 100, luck 5.

## Summary table

| Name                  | Rooms | Recommended level | Theme               | Final enemy                          | Season      |
| --------------------- | ----: | ----------------- | ------------------- | ------------------------------------ | ----------- |
| The Mudlark Sewers    |     4 | 1 – 6             | Sewers              | The Sludge Matriarch (champion)      | Any         |
| The Millrace          |     5 | 1 – 6             | Goblin mill         | The Wheelboss (champion)             | Any         |
| The Hollow Crypts     |     4 | 3 – 8             | Crypts              | Crypt Warden (champion)              | Any         |
| Ashfall Bandit Hold   |     5 | 5 – 10            | Bandit fort         | The Pass Reaver (champion)           | Any         |
| Gnashtooth Warren     |     5 | 5 – 10            | Goblin warren       | Gnashtooth the Trapper (champion)    | Any         |
| Thistlewake Grove     |     5 | 7 – 12            | Fae grove           | Grove Matriarch (champion)           | Any         |
| Bramblefang Warren    |     6 | 7 – 14            | Beast warren        | Alpha Direwolf (champion)            | Any         |
| The Drowned Shaft     |     6 | 9 – 16            | Flooded mines       | The Drowned Colossus (champion)      | Any         |
| Rustbelly Hive        |     5 | 9 – 16            | Beast warren        | Hive Queen (champion)                | Any         |
| Mournwillow Fen       |     6 | 11 – 18           | Fae grove           | The Willow Widow (champion)          | Any         |
| Cinder Rift           |     6 | 11 – 18           | Elemental rift      | The Ember Hunter (champion)          | Any         |
| The Clockwork Vault   |     6 | 11 – 18           | Construct vault     | The Vault Mainspring (champion)      | Any         |
| Blackroot Bandit Fort |     7 | 13 – 20           | Bandit fort         | Bandit Warlord (champion)            | Any         |
| Skyreach Spire        |     7 | 13 – 20           | Ruined wizard tower | The Unbound Archmage (champion)      | Any         |
| Redtusk Warcamp       |     7 | 13 – 20           | Orc warcamp         | Warchief Redtusk (champion)          | Any         |
| Suncoil Ruins         |     6 | 15 – 22           | Ruined wizard tower | The Arc Warden (champion)            | Any         |
| The Gilded Hoard      |     7 | 15 – 22           | Crypts              | The Hoardwarden (champion)           | Any         |
| The Silt Cisterns     |     5 | 17 – 24           | Flooded mines       | The Silt Behemoth (champion)         | Any         |
| The Weeping Ossuary   |     6 | 17 – 24           | Ossuary             | The Ossuary Keeper (champion)        | Any         |
| The Glass Observatory |     6 | 19 – 26           | Ruined wizard tower | The Starglass Magus (champion)       | Any         |
| The Mirror Court      |     6 | 21 – 28           | Fae court           | The Mirrored Queen (champion)        | Any         |
| The Sunken Abbey      |     7 | 23 – 30           | Flooded abbey       | The Drowned Abbess (champion)        | Any         |
| The Void Scar         |     6 | 25 – 32           | Elemental rift      | The Unmade Heart (champion)          | Any         |
| Frostfang Caverns     |     8 | 19 – 26           | Elemental rift      | The Frost Sovereign (champion)       | Winter only |
| The Thawroot Burrow   |     5 | 5 – 12            | Root burrow         | The Rootmother (champion)            | Spring only |
| The Meltwater Grotto  |     5 | 9 – 16            | Ice grotto          | The Thaw Leviathan (champion)        | Spring only |
| The Sunheart Bloom    |     6 | 11 – 18           | Giant flower        | The Heartseed Warden (champion)      | Summer only |
| The Wasp Cathedral    |     6 | 17 – 24           | Giant nest          | The Paper Matriarch (champion)       | Summer only |
| Vespergrave           |     6 | 15 – 22           | Haunted graveyard   | The Lantern Keeper (champion)        | Autumn only |
| Cindermaw Forge       |     9 | 21 – 28           | Elemental rift      | The Cindermaw Triumvirate (3 elites) | Any         |

## The Mudlark Sewers

The drains under the oldest village of the map, and the first dungeon a brand-new wizard can survive.
**Gimmick — the water rises:** from the third room on, the water is knee-high, and everything except the rats moves at reduced `speed`.

| Room              | What is there                                  | Enemies                                                         | Notes                                                                     |
| ----------------- | ---------------------------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Outflow grate     | A rusted grate over a trickle of filthy water. | 3× Sewer Rats (critter, melee)                                  | Teaches the room-clear loop.                                              |
| The junction      | Four tunnels meeting over a sluice.            | 4× Sewer Rats (critter, melee), 1× Drain Lurker (common, melee) | The Lurker waits submerged until the first rat falls.                     |
| Flooded cistern   | A vaulted cistern, the water now knee-high.    | 2× Drain Lurkers (common, melee)                                | The water slows the wizard and the Lurkers alike.                         |
| The sludge throne | A mound of refuse under a broken drain.        | The Sludge Matriarch (champion, melee)                          | health and power −25 %, reason: the entry-level dungeon of the catalogue. |

**Drops:** experience, gold and common runes scaled to level 1 – 6.
No stone chance: the first dungeon of a run must not decide who unlocks a Grimoire position first.

## The Millrace

A watermill a goblin band took over, still turning, still grinding something.
**Gimmick — the wheel turns:** each time a wizard enters, rooms two to four come in a new order, so no two visits play alike.

| Room           | What is there                                  | Enemies                                                               | Notes                                                                |
| -------------- | ---------------------------------------------- | --------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Sluice gate    | A gate jammed with driftwood.                  | 2× Goblin Sneaks (critter, melee)                                     | Standard opener; always first.                                       |
| Grain loft     | Sacks stacked high, flour hanging in the air.  | 3× Goblin Sneaks (critter, melee), 1× Goblin Slinger (common, magic)  | The flour hides the Slinger until it throws.                         |
| The gear pit   | Wooden gears turning in the floor.             | 2× Goblin Bruisers (common, melee)                                    | Standing on a gear carries anyone slowly round the room.             |
| Millstone hall | Two great stones grinding against each other.  | 1× Goblin Bruiser (common, melee), 2× Goblin Slingers (common, magic) | The Slingers keep the stones between them and the wizard.            |
| The wheelhouse | The axle of the great wheel, spray everywhere. | The Wheelboss (champion, melee)                                       | health and power −25 %, reason: an entry-level dungeon; always last. |

**Drops:** experience, gold and common runes scaled to level 1 – 6.
No stone chance, for the same reason as The Mudlark Sewers.

## The Hollow Crypts

A burial ground predating the current villages, four low chambers cut into a hillside.
This is the baseline dungeon: no gimmick, a clean escalation from critter to champion, built to teach a new wizard what a dungeon run feels like.
It is deliberately easy, so a wizard who has fallen behind in levels still has a dungeon to clear.
Every enemy here is undead, melee-leaning, and slow by design so a level-3 wizard can read their attacks.

| Room             | What is there                                  | Enemies                                                         | Notes                                                                  |
| ---------------- | ---------------------------------------------- | --------------------------------------------------------------- | ---------------------------------------------------------------------- |
| Entrance alcove  | Collapsed stairwell, a few open sarcophagi.    | 3× Grave Husks (critter, melee)                                 | Teaches the room-clear loop.                                           |
| Bone ossuary     | Walls stacked floor to ceiling with remains.   | 4× Grave Husks (critter, melee), 1× Rot Acolyte (common, magic) | The acolyte casts from the back row; kill it first or eat chip damage. |
| Sealed vault     | A cracked stone door, runes scratched over it. | 2× Bound Skeletons (common, melee)                              | Small gimmick: the door only opens once both skeletons are down.       |
| Warden's chamber | A raised dais, cold air, a single stone seat.  | Crypt Warden (champion, magic)                                  | Opens with a ranged volley the moment the door is breached.            |

**Drops:** experience, gold and common-to-rare runes scaled to level 3 – 8, and a small chance at a mana-stone.
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
| Captain's antechamber | A locked strongbox, empty.                 | 1× Hold Lieutenant (veteran, melee)                               | A real fight for a level-8 wizard, by design.                    |
| Captain's hall        | A long table, a banner of a torn standard. | The Pass Reaver (champion, melee)                                 | No reinforcements, no gimmick — a clean final fight.             |

**Drops:** experience, gold and common-to-rare runes scaled to level 5 – 10, and a small-to-moderate chance at a mana-stone.

## Gnashtooth Warren

A goblin warren whose owner cares more about traps than about goblins.
**Gimmick — the traps bite everyone:** every trap hurts a goblin exactly as much as a wizard, so luring enemies into their own traps is the intended play.

| Room               | What is there                               | Enemies                                  | Notes                                                              |
| ------------------ | ------------------------------------------- | ---------------------------------------- | ------------------------------------------------------------------ |
| Burrow mouth       | Bones and snares scattered at the entrance. | 3× Goblin Sneaks (critter, melee)        | The first snare is in plain sight, to teach the gimmick.           |
| The pit run        | A corridor of covered pits.                 | 2× Goblin Bruisers (common, melee)       | The Bruisers charge in a straight line, pits or not.               |
| Spike gallery      | Spring-loaded spikes set into both walls.   | 3× Goblin Slingers (common, magic)       | Pressure plates fire the spikes across the whole room.             |
| Trapper's workshop | Half-built traps on every bench.            | 1× Goblin Trapmaster (veteran, magic)    | Arms a new snare under the wizard every few seconds.               |
| The gnashing den   | A pit ringed with jaw traps.                | Gnashtooth the Trapper (champion, magic) | Knocked into one of his own jaw traps, he is stunned for a moment. |

**Drops:** experience, gold and common-to-rare runes scaled to level 5 – 10, and a small chance at a mana-stone.

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

**Drops:** experience, gold and common-to-rare runes scaled to level 7 – 12, and a moderate chance at a mana-stone.
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

**Drops:** experience, gold and common-to-rare runes scaled to level 7 – 14, and a moderate chance at a mana-stone.

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

**Drops:** experience, gold and common-to-rare runes scaled to level 9 – 16, and a moderate chance at a mana-stone.
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

**Drops:** experience, gold and common-to-rare runes scaled to level 9 – 16, and a moderate chance at a mana-stone.

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

**Drops:** experience, gold and common-to-rare runes scaled to level 11 – 18, and a moderate chance at a mana-stone.
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

**Drops:** experience, gold and common-to-rare runes scaled to level 11 – 18, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## The Clockwork Vault

A sealed strongroom whose builder trusted machines over guards, and whose machines never stopped.
**Gimmick — the Tinker Imps repair:** every construct in a room is kept alive by its Tinker Imps, so the fight is won by killing the Imps first.

| Room           | What is there                                   | Enemies                                                             | Notes                                                  |
| -------------- | ----------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------ |
| Brass door     | A round door of brass plates, half open.        | 2× Cogwork Sentries (common, melee)                                 | Standard opener, no Imp yet.                           |
| Repair bay     | Workbenches covered in spare limbs.             | 2× Cogwork Sentries (common, melee), 2× Tinker Imps (common, magic) | First Imps: a Sentry left alone with them never falls. |
| Pendulum hall  | A blade pendulum swinging across the room.      | 1× Brass Warder (veteran, melee)                                    | The pendulum hits the Warder as hard as the wizard.    |
| Spring chamber | Coiled springs underfoot.                       | 3× Cogwork Sentries (common, melee), 1× Tinker Imp (common, magic)  | Stepping on a spring throws anyone a short distance.   |
| Escapement     | Two great toothed wheels locking and unlocking. | 2× Brass Warders (veteran, melee), 2× Tinker Imps (common, magic)   | The hardest room before the end, by design.            |
| The mainspring | The coiled heart of the vault.                  | The Vault Mainspring (champion, melee)                              | Two Tinker Imps climb out of the walls at half health. |

**Drops:** experience, gold and common-to-rare runes scaled to level 11 – 18, and a small chance at a mana-stone.

## Blackroot Bandit Fort

A proper fortified bandit holding, built into an old quarry wall, with a working alarm system.
It is deliberately hard for its level band, and a wooden sign nailed at the quarry gate warns the careless before they step in.
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

**Drops:** experience, gold and common-to-rare runes scaled to level 13 – 20, and a moderate chance at a mana-stone.
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

**Drops:** experience, gold and common-to-rare runes scaled to level 13 – 20, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## Redtusk Warcamp

An orc warband's camp, loud from the first palisade to the warchief's tent.
**Gimmick — the war drum:** while a room's Orc Drummer lives, every orc in that room has +15 % `power`.

| Room            | What is there                            | Enemies                                                              | Notes                                                                          |
| --------------- | ---------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| Palisade gate   | Sharpened stakes, a gate of lashed logs. | 2× Orc Pickets (common, melee)                                       | Standard opener, no drum yet.                                                  |
| Drum circle     | A ring of drums around a fire.           | 3× Orc Pickets (common, melee), 1× Orc Drummer (common, magic)       | The Drummer stays behind the fire.                                             |
| Training yard   | Straw dummies, broken weapons.           | 2× Redtusk Berserkers (veteran, melee)                               | No drum: a straight fight.                                                     |
| Shaman's tent   | Smoke, hanging bones, a cracked totem.   | 1× Redtusk Shaman (veteran, magic), 1× Orc Drummer (common, magic)   | The Shaman heals the Drummer first.                                            |
| Beast pens      | Muddy pens, a broken gate.               | 2× War Boars (common, melee), 1× Redtusk Handler (veteran, melee)    | The Boars charge whoever the Handler points at.                                |
| Trophy hall     | Banners of beaten warbands.              | 1× Redtusk Bloodguard (elite, melee), 1× Orc Drummer (common, magic) | An elite under the drum: the Drummer is the priority.                          |
| Warchief's tent | A throne of shields.                     | Warchief Redtusk (champion, melee)                                   | Carries his own drum on his back; it breaks only from a hit landed behind him. |

**Drops:** experience, gold and common-to-rare runes scaled to level 13 – 20, and a small chance at a mana-stone.

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

**Drops:** experience, gold and common-to-rare runes scaled to level 15 – 22, and a moderate chance at a mana-stone.
Small chance at a life-stone.

## The Gilded Hoard

A crypt built by a wizard obsessed with wealth, sealed with his collection still inside.
**Gimmick — harder for a wizard carrying gold:** the Gold Wraiths native to this crypt sense carried wealth and scale to it.
The scaling reads the wizard's **rank in carried gold** among the world's living wizards, taken at the moment they enter:

| Rank in carried gold | Gold Wraiths gain  |
| -------------------- | ------------------ |
| 1 – 4                | ×2 `power`         |
| 5 – 8                | ×2 `magic_defence` |
| 9 – 14               | ×2 `health`        |
| 15 and below         | nothing            |

A rank, not an amount, so the curve never has to be retuned as the economy inflates, and it can never softlock a wizard.

| Room                   | What is there                                      | Enemies                                                             | Notes                                                                              |
| ---------------------- | -------------------------------------------------- | ------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Antechamber of coin    | Scattered coin, deliberately left as bait.         | 2× Gold Wraiths (common, magic)                                     | Wraiths scale with the wizard's gold rank, see above.                              |
| The Ledger Hall        | Shelves of account books, gilded spines.           | 3× Gold Wraiths (common, magic)                                     | Same rank rule.                                                                    |
| Vault of Small Things  | Display cases of minor treasure, mostly empty now. | 1× Hoard Sentinel (veteran, melee), 2× Gold Wraiths (common, magic) | Only the Wraiths scale; the Sentinel never does.                                   |
| The Counting Room      | A single enormous abacus, frozen mid-count.        | 2× Hoard Sentinels (veteran, melee)                                 | No gold scaling in this room — a fixed, hard room regardless of wealth.            |
| The Appraiser's Study  | A desk stacked with valuation ledgers.             | 1× Hoard Sentinel (veteran, melee), 2× Gold Wraiths (common, magic) | Same rank rule for the Wraiths.                                                    |
| Treasury threshold     | A door cast from a single sheet of gold.           | 2× Hoard Sentinels (veteran, melee)                                 | No scaling; a breather before the final room regardless of wealth carried.         |
| The Hoardwarden's Seat | A mountain of coin, the throne buried in it.       | The Hoardwarden (champion, magic)                                   | The Hoardwarden itself does not scale with gold — only the rooms leading to it do. |

**Drops:** experience, gold and common-to-rare runes scaled to level 15 – 22, and a moderate chance at a mana-stone.
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

**Drops:** experience, gold and common-to-rare runes scaled to level 17 – 24, and a moderate chance at a mana-stone.
Moderate chance at a life-stone, reflecting the higher recommended level.

## The Weeping Ossuary

A bone-house carved under a cliff, its walls of skulls always wet.
**Gimmick — the bones get back up:** every skeleton that falls leaves a heap of bones that rises again after 20 seconds, unless the heap itself is destroyed.

| Room             | What is there                             | Enemies                                                                   | Notes                                                                                  |
| ---------------- | ----------------------------------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| Weeping stair    | Water seeping through a stair of skulls.  | 3× Ossuary Skeletons (common, melee)                                      | Teaches the gimmick on weak enemies.                                                   |
| Hall of niches   | Walls of stacked remains, a narrow aisle. | 2× Ossuary Skeletons (common, melee), 1× Ossuary Acolyte (veteran, magic) | The Acolyte raises a heap at once instead of waiting.                                  |
| The weeping well | A well brimming with dark water.          | 2× Weeping Wights (veteran, magic)                                        | No skeleton here: a breather from the gimmick.                                         |
| Charnel gallery  | Bones heaped along the floor.             | 4× Ossuary Skeletons (common, melee)                                      | Three heaps already lie on the floor when the wizard enters.                           |
| Reliquary        | A sealed casket on a stone altar.         | 1× Bone Colossus (elite, melee)                                           | Built from the heaps: every heap left standing in the dungeon adds +5 % to its health. |
| Keeper's crypt   | A crypt of polished bone.                 | The Ossuary Keeper (champion, magic)                                      | At half health, raises every heap in the room at once.                                 |

**Drops:** experience, gold and rare runes scaled to level 17 – 24, and a small chance at a mana-stone or a life-stone.

## The Glass Observatory

A tower that used to belong to a wizard who watched the stars through lenses of his own making.
**Gimmick — the beams:** beams of light cross every room and burn whatever they touch, wizard or enemy; a mirror struck by any attack turns and redirects its beam.

| Room            | What is there                             | Enemies                                                             | Notes                                                                               |
| --------------- | ----------------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Lens hall       | Lenses of every size hanging from chains. | 3× Glass Wisps (common, magic)                                      | One fixed beam, to teach the hazard.                                                |
| Mirror stair    | A spiral stair lined with mirrors.        | 2× Prism Sentinels (veteran, melee)                                 | The first mirror that turns.                                                        |
| Star chart room | Charts pinned over every wall.            | 1× Lens Adept (veteran, magic), 2× Glass Wisps (common, magic)      | The Adept turns mirrors too, against the wizard.                                    |
| The orrery      | A brass orrery the size of the room.      | 2× Prism Sentinels (veteran, melee), 1× Lens Adept (veteran, magic) | The orrery turns every beam a quarter round every ten seconds.                      |
| Refractor       | A single huge prism.                      | 1× Shardglass Golem (elite, melee)                                  | Takes double damage from a beam.                                                    |
| The great lens  | The telescope itself, aimed at the room.  | The Starglass Magus (champion, magic)                               | Fires through the great lens; turning the mirrors back on him is the intended play. |

**Drops:** experience, gold and rare runes scaled to level 19 – 26, and a small chance at a mana-stone or a life-stone.

## The Mirror Court

A fae court held inside a hall of mirrors, where every guest is a reflection of the last one.
**Gimmick — the court copies you:** every enemy takes on the Element of the wizard's last spell for its own attacks, so a varied Grimoire fights better than a single strong spell.

| Room                | What is there                               | Enemies                                                                | Notes                                                                 |
| ------------------- | ------------------------------------------- | ---------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Glass antechamber   | A hall of mirrors, none showing the wizard. | 2× Court Pages (common, magic), 1× Mirror Duelist (veteran, melee)     | Teaches the copying on weak enemies.                                  |
| Hall of reflections | Mirrors facing mirrors, to infinity.        | 3× Mirror Duelists (veteran, melee)                                    | Straight fight, but every hit carries the copied Element.             |
| The masquerade      | Masked dancers who never stop.              | 1× Masked Courtier (elite, magic), 2× Court Pages (common, magic)      | The Courtier copies the last two spells, not one.                     |
| The jester's stage  | A stage, a curtain, an empty seat.          | 1× Court Jester (elite, magic)                                         | Swaps places with the wizard once per fight.                          |
| Throne approach     | A carpet between two rows of mirrors.       | 2× Mirror Duelists (veteran, melee), 1× Masked Courtier (elite, magic) | The hardest room before the end.                                      |
| The mirrored throne | A throne of glass facing a wall of glass.   | The Mirrored Queen (champion, magic)                                   | Copies the whole last spell, not only its Element, and casts it back. |

**Drops:** experience, gold and rare-to-legendary runes scaled to level 21 – 28, and a small chance at a mana-stone or a life-stone.

## The Sunken Abbey

An abbey the sea took in one night, still ringing its bell under the water.
**Gimmick — the tide follows:** two minutes after a room is cleared, the tide floods it; a wizard still inside is slowed and takes light damage over time.

| Room                | What is there                                   | Enemies                                                                | Notes                                                                      |
| ------------------- | ----------------------------------------------- | ---------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| Nave porch          | A flooded porch, statues to the waist in water. | 3× Drowned Novices (common, melee)                                     | The first flood comes behind the wizard.                                   |
| Cloister            | A square garden turned into a pool.             | 2× Tidebound Monks (veteran, melee), 1× Drowned Novice (common, melee) | Standard fight under tide pressure.                                        |
| Bell tower base     | The bell rope, hanging into the water.          | 1× Bell Wraith (elite, magic)                                          | Each ring of the bell brings the next flood forward by ten seconds.        |
| Scriptorium         | Floating pages, ink clouding the water.         | 2× Tidebound Monks (veteran, melee), 1× Brine Chanter (veteran, magic) | The Chanter stands in deep water and is slowed by nothing.                 |
| Crypt stairs        | Stairs going down into black water.             | 2× Brine Chanters (veteran, magic)                                     | A breather before the last rooms.                                          |
| Chapter house       | A round hall, benches floating.                 | 2× Tidebound Monks (veteran, melee), 1× Bell Wraith (elite, magic)     | The hardest room before the end.                                           |
| The abbess's chapel | An altar above the waterline, barely.           | The Drowned Abbess (champion, magic)                                   | Rings the drowned bell: each ring raises the water in the chapel one step. |

**Drops:** experience, gold and rare-to-legendary runes scaled to level 23 – 30, and a moderate chance at a mana-stone or a life-stone.

## The Void Scar

A wound in the world where something was erased, and the edges are still fraying.
**Gimmick — mana leaks:** entering each room costs the wizard a share of current mana, and mana regenerates at half rate inside the Scar.

| Room              | What is there                                  | Enemies                                                         | Notes                                                          |
| ----------------- | ---------------------------------------------- | --------------------------------------------------------------- | -------------------------------------------------------------- |
| Rim of the scar   | Ground breaking off into nothing.              | 3× Void Motes (common, magic)                                   | The first leak, on weak enemies.                               |
| The fracture      | A bridge of floating stone.                    | 2× Null Wardens (veteran, melee)                                | Standard fight with a thinning mana pool.                      |
| Gravity well      | Debris orbiting a point of darkness.           | 1× Void Maw (elite, magic)                                      | The bestiary's Void Maw, unchanged.                            |
| Echo chamber      | Sounds arriving before what makes them.        | 2× Null Wardens (veteran, melee), 2× Void Motes (common, magic) | The hardest room before the end.                               |
| The tear          | A rip in the air, wide enough to walk through. | 2× Rift Stalkers (elite, melee)                                 | Two elites; a wizard who arrives low on mana should turn back. |
| Heart of the scar | Nothing at all, and something in it.           | The Unmade Heart (champion, magic)                              | Pulls the wizard toward itself and drains mana on touch.       |

**Drops:** experience, gold and rare-to-legendary runes scaled to level 25 – 32, and a moderate chance at a mana-stone or a life-stone.

## Frostfang Caverns

A glacial cave system whose entrance sits on an island in the middle of a lake.
**Winter's season-gated dungeon.**
The island cannot be reached until winter freezes the lake hard enough to walk across.
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

**Drops:** experience, gold and common-to-rare runes scaled to level 19 – 26, and a moderate chance at a mana-stone.
Moderate chance at a life-stone.

## The Thawroot Burrow

A tunnel system that opens when the spring thaw softens the ground and new roots push through it.
**Spring's season-gated dungeon.**
The burrow exists only in spring; the start of summer dries the roots and the whole burrow caves in.
**Gimmick — the roots keep growing:** every room cleared lets new roots creep across the rooms behind, so backtracking toward the entrance costs a short fight with a fresh critter.

| Room            | What is there                                      | Enemies                                                            | Notes                                                    |
| --------------- | -------------------------------------------------- | ------------------------------------------------------------------ | -------------------------------------------------------- |
| Thawmouth       | Wet earth, meltwater dripping from the ceiling.    | 3× Sprout Mites (critter, melee)                                   | Standard opener.                                         |
| The Root Tangle | A chamber laced with living roots, waist high.     | 2× Rootlash Vines (common, melee), 1× Sprout Mite (critter, melee) | The vines are rooted in place; the mites are not.        |
| Seedwater Pool  | A pool of meltwater full of floating seeds.        | 2× Thaw Sprites (common, magic)                                    | The sprites stand in the pool and keep their distance.   |
| The Old Trunk   | An old trunk the burrow grew around.               | 1× Barkhide Warden (veteran, melee)                                | Single strong enemy, a breather before the end.          |
| The Mother Root | A hollow where every root of the burrow converges. | The Rootmother (champion, magic)                                   | Calls a Sprout Mite from the walls at regular intervals. |

**Drops:** experience, gold and common-to-rare runes scaled to level 5 – 12, and a small chance at a mana-stone.

## The Meltwater Grotto

A grotto of winter ice that the spring thaw opens a little more each day.
**Spring's second season-gated dungeon.**
**Gimmick — the ice melts:** on the first day of spring only the first three rooms are reachable; the last two open on the second day, so the grotto cannot be finished before then.

| Room               | What is there                                | Enemies                                                            | Notes                                                      |
| ------------------ | -------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------------------------- |
| Icefall entrance   | A curtain of dripping icicles.               | 3× Melt Sprites (critter, magic)                                   | Standard opener.                                           |
| Dripping hall      | Water running down walls of ice.             | 2× Frostwing Bats (common, melee), 1× Melt Sprite (critter, magic) | The Bats strike from the ceiling.                          |
| Frozen pool        | A pool crusted with thin ice.                | 2× Slush Elementals (common, magic)                                | Ice gives way under heavy blows; a wizard on it is slowed. |
| The thawed gallery | A gallery that was solid ice the day before. | 1× Floe Guardian (veteran, melee)                                  | Opens on spring's second day.                              |
| The meltwater lake | An underground lake, freshly liquid.         | The Thaw Leviathan (champion, melee)                               | Opens on spring's second day.                              |

**Drops:** experience, gold and common-to-rare runes scaled to level 9 – 16, and a small chance at a mana-stone.

## The Sunheart Bloom

A flower the size of a hill that opens at the start of summer, its inner chambers reachable through the petals.
**Summer's season-gated dungeon.**
The bloom opens when summer begins and wilts shut when autumn begins.
**Gimmick — nectar heals:** pools of nectar lie across several rooms, and any enemy standing in one regenerates health; a fight is won by drawing enemies out of the pools first.

| Room            | What is there                                       | Enemies                                                             | Notes                                                                             |
| --------------- | --------------------------------------------------- | ------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Petal stair     | Broad petals curling upward like steps.             | 3× Pollen Motes (critter, magic)                                    | Standard opener, no nectar yet.                                                   |
| The Nectar Hall | A wide chamber with two nectar pools.               | 2× Nectar Beetles (common, melee), 1× Pollen Mote (critter, magic)  | First nectar room: pull the beetles out before fighting.                          |
| Stamen Gallery  | A forest of tall golden stalks.                     | 3× Pollen Motes (critter, magic), 1× Stamen Lancer (common, melee)  | No nectar here; the stalks block line of sight.                                   |
| The Sweet Well  | A single deep nectar pool in the floor.             | 1× Bloomguard (veteran, melee)                                      | The Bloomguard tries to fight from inside the pool.                               |
| Sepal Chamber   | Green walls, the light filtered and dim.            | 2× Nectar Beetles (common, melee), 1× Stamen Lancer (common, melee) | Two small pools near the far wall.                                                |
| The Heartseed   | The flower's core, a seed glowing like a small sun. | The Heartseed Warden (champion, magic)                              | The Warden stands on the seed, which heals it like nectar until it is pushed off. |

**Drops:** experience, gold and common-to-rare runes scaled to level 11 – 18, and a small chance at a mana-stone.
Small chance at a life-stone.

## The Wasp Cathedral

A wasp nest grown to the size of a cathedral, built of chewed paper over a summer.
**Summer's second season-gated dungeon.**
**Gimmick — the nest grows:** on summer's second day, every room holds one more Paper Wasp than on the first.

| Room             | What is there                           | Enemies                                                           | Notes                                                         |
| ---------------- | --------------------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------- |
| Paper narthex    | Walls of grey paper, humming.           | 3× Paper Wasps (critter, melee)                                   | Standard opener.                                              |
| Comb nave        | Rows of hexagonal cells, some hatching. | 3× Paper Wasps (critter, melee), 1× Wasp Drone (common, magic)    | A cell hatches a Paper Wasp every 20 seconds until destroyed. |
| Choir of drones  | A buzzing that never stops.             | 2× Wasp Drones (common, magic), 1× Wasp Sentinel (veteran, melee) | The noise hides the Sentinel's approach.                      |
| Brood chapel     | Larvae in every cell.                   | 2× Wasp Sentinels (veteran, melee)                                | Hitting a larva cell enrages every wasp in the room.          |
| Royal transept   | The widest chamber, paper-thin floor.   | 1× Wasp Praetor (elite, melee), 2× Paper Wasps (critter, melee)   | The hardest room before the end.                              |
| The queen's apse | A paper throne dripping with wax.       | The Paper Matriarch (champion, magic)                             | Calls two Paper Wasps at a time, at regular intervals.        |

**Drops:** experience, gold and rare runes scaled to level 17 – 24, and a small chance at a mana-stone or a life-stone.

## Vespergrave

An old graveyard on the open map, quiet for three seasons, that turns haunted once autumn sets in.
**Autumn's season-gated dungeon.**
The graveyard is ordinary ground in spring and summer, becomes an instanced dungeon when autumn begins, and goes quiet again when winter begins.
**Gimmick — lantern light:** the ghosts here cannot be harmed outside lantern light; each room holds lanterns to light, and a ghost that drifts out of the light becomes untouchable again.

| Room                | What is there                                      | Enemies                                                          | Notes                                                                              |
| ------------------- | -------------------------------------------------- | ---------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| The Lychgate        | A roofed gate, one unlit lantern hanging from it.  | 3× Whisperlings (critter, magic)                                 | Teaches the lantern rule on weak enemies.                                          |
| Rows of the Unnamed | Leaning headstones with their names worn away.     | 3× Restless Dead (common, melee)                                 | The restless dead are solid; no lantern needed for them.                           |
| The Ossuary Chapel  | A small chapel stacked with bones, two lanterns.   | 2× Grave Wails (common, magic), 1× Restless Dead (common, melee) | The wails are ghosts: light both lanterns first.                                   |
| Gravedigger's Hut   | A shovel still in the earth, a cold stove.         | 1× The Gravedigger (veteran, melee)                              | Solid, single strong enemy.                                                        |
| The Mourning Path   | A long path between yew trees, lanterns far apart. | 3× Grave Wails (common, magic)                                   | The lanterns are spaced so no single one covers every ghost.                       |
| The Lantern Crypt   | A crypt full of lanterns, all of them dark.        | The Lantern Keeper (champion, magic)                             | The Keeper puts lanterns out during the fight; relight them to keep it vulnerable. |

**Drops:** experience, gold and common-to-rare runes scaled to level 15 – 22, and a small chance at a mana-stone.
Small chance at a life-stone.

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

**Drops:** experience, gold and common-to-rare runes scaled to level 21 – 28, and the best mana-stone odds on this list.
Moderate-to-good chance at a life-stone, reflecting that this is the hardest combat dungeon documented here.

## Notes for balancing

- **Blackroot Bandit Fort is hard on purpose.**
  Its max-alert case puts an extra veteran beside the Warlord, and the sign at the gate is the warning.
- **The Hollow Crypts is easy on purpose.**
  It is the catch-up dungeon for a wizard behind in levels.
- **Frostfang Caverns is eased by the rest zones.**
  A rest zone after its sixth room sits right before the two veteran Crevasse Wardens of the Frozen Court.
- **Stone odds are low everywhere.**
  Exact percentages are tuned once every mana-stone and life-stone source is counted.
- **The Void Scar now tops the catalogue at level 25 – 32, above Cindermaw Forge.**
  It sits just past the level-30 target, for the wizards who outpace it.
