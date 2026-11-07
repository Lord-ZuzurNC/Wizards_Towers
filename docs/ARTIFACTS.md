# Artifacts — Wizards Towers

An Artifact is a world-unique rune bound to a floor of the Monolith, not to a wizard.
Hold the floor, use the rune in your spell.
Lose the floor and the rune leaves your spell.

- [Artifacts — Wizards Towers](#artifacts--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [Shape Artifacts](#shape-artifacts)
  - [Element Artifacts](#element-artifacts)
  - [Duration Artifacts](#duration-artifacts)
  - [Effect Artifacts](#effect-artifacts)
  - [Corruptions](#corruptions)
  - [Catalogue counts](#catalogue-counts)
  - [Notes for balancing](#notes-for-balancing)

## How to read this document

This catalogue holds exactly **100** Artifacts.
At generation, a world deals one Artifact to every possible floor, and **two** to floors 10, 20, 30 and 40.
That is 53 of the 100 for the 49 possible floors, a different set each time.
The ROOF is not a floor and is never dealt an Artifact.

Every Artifact has a **band** that says which floors may deal it.

| Band         | Floors | Role                                       |
| ------------ | ------ | ------------------------------------------ |
| **normal**   | 1-19   | Early-run power, found by any wizard.      |
| **enhanced** | 20-39  | Mid-run power, found by a wizard climbing. |
| **powerful** | 40-49  | Late-run power, found near the top.        |

**Bands are fixed, and a locked floor keeps its Artifact dormant.**
A Monolith has `current wizards - 1` floors, so a floor exists only once enough wizards have joined.
Its Artifact is dealt at generation all the same, and wakes when a joining wizard unlocks the floor.
A world that never fills never reaches its enhanced or powerful floors, and that is intended.

**Effect and corruption are paired at world generation, never authored together.**
One table per attribute lists Artifacts with their **effect only**, and one shared **Corruptions** table lists the costs they can be paired with.
Because a corruption can land on any Artifact, no corruption references a specific Artifact's effect.
Every corruption is a universal cost, such as a stat penalty, a resource drain or a behavioural restriction.

**Every drain has a floor, binding rule.**
Any corruption that drains a stat or a resource states an explicit lower bound where it stops.
No corruption may reduce a wizard to zero or to something unplayable.

**Curing a corruption.**
A corruption is cured by the priest in the Lobby for one life-stone.

Each Artifact table has five columns.

| Column           | Meaning                                                                         |
| ---------------- | ------------------------------------------------------------------------------- |
| **Name**         | World-unique, two to four words, never a bare glossary term.                    |
| **Band**         | Which floors may deal this Artifact: normal, enhanced, or powerful.             |
| **Weight**       | Its weight on the weight bar, like any rune, provisional; see below.            |
| **What it does** | The effect alone, in the terms this project already uses for stats and systems. |
| **Notes**        | Synergy, intended use, or a warning about the combination that breaks it.       |

The four groups below mirror the four rune attributes: Shape, Element, Duration, Effect.
An Artifact occupies the same slot an ordinary rune of that attribute would occupy, so an Artifact Effect still fills one of the two ordered Effect slots.
Each entry does something an ordinary rune cannot, never a bigger number on something an ordinary rune already does.

---

## Shape Artifacts

An Artifact Shape changes the geometry of the spell in a way no ordinary Shape can: it reads the caster's holdings, the map, or another system, rather than just drawing a bigger bolt, cone or ring.

| Name                          | Band     | Weight | What it does                                                                                                                   | Notes                                                                                 |
| ----------------------------- | -------- | -----: | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| **The Landlord's Volley**     | enhanced |      2 | Fires one converging bolt per village the caster currently owns, minimum one, capped at six.                                   | Scales with the economy it is built to protect.                                       |
| **Crownless Wall**            | normal   |      4 | The Wall advances slowly in the direction it was cast instead of standing still.                                               | A moving choke point.                                                                 |
| **The Surveyor's Rain**       | enhanced |      5 | Rain falls in the exact footprint of the caster's largest owned village, redrawn each cast as that village grows.              | Grows with the economy that feeds it.                                                 |
| **Last Page Standing**        | powerful |      6 | Fires one projectile per filled Grimoire position, in position order, each carrying that spell's own Element and Effects.      | A full Grimoire is a volley; an empty one is a single bolt.                           |
| **The Beggar's Orb**          | normal   |      3 | The Orb's detonation radius triples while the caster owns zero villages, shrinking back to normal as villages are bought.      | The starting wizard's best friend, briefly.                                           |
| **The North Wall's Finger**   | powerful |      3 | A bolt bends toward whichever wizard is currently closest to being named on the North Wall, wherever they are standing.        | Reveals the hunter to a sharp-eyed target the instant they strike.                    |
| **Guardian's Second Shadow**  | normal   |      4 | The Aura also centres on the nearest guardian defending an owned village, if one is standing nearby.                           | Trades a defender's teeth for the caster's radius.                                    |
| **The Maze-Walker's Lance**   | enhanced |      3 | Inside a maze, the Lance passes through solid walls as if they were not there.                                                 | Built for one room type and useless everywhere else.                                  |
| **Hoarder's Vortex**          | enhanced |      6 | The Vortex's pull strength scales with the gold the caster is currently carrying.                                              | A rich wizard becomes a black hole.                                                   |
| **The Seed of Four Seasons**  | normal   |      4 | The Seed never expires; it burns in summer, freezes solid in winter, blooms in spring and wilts in autumn.                     | A village-defence Seed with four different faces.                                     |
| **The Siege Spray**           | enhanced |      3 | The Spray deals full damage to village stones, towers and guardians instead of its usual falloff against structures.           | A wall-cracker, not a duellist's tool.                                                |
| **The Tireless Rival**        | enhanced |      4 | The Beam deals double damage against a floor's defending echo.                                                                 | Rewards committing to one fight.                                                      |
| **The Spirit's Second Throw** | normal   |      5 | The Swarm's fragments also home on whatever the caster's spirit is currently targeting, not only the caster's own target.      | Turns the spirit into a spotter.                                                      |
| **Tether of Shared Blood**    | powerful |      6 | Tethered to a floor's defending echo, the Tether also binds that echo's owner wherever they stand, applying the spell to both. | Hurts an owner through their own echo; nothing extra if the owner is offline or dead. |
| **The Peddler's Nova**        | normal   |      3 | On a kill, the Nova drops gold on the spot, scaled by the Nova's own weight-derived power, as a treasure would.                | A farming tool wearing a combat Shape.                                                |
| **The Borrowed Wall**         | normal   |      4 | The Wall is cast at full strength even at zero mana cost pressure while the caster stands inside an owned village.             | A homecoming Shape; ordinary everywhere else.                                         |
| **The Maze-Caster's Orb**     | enhanced |      4 | The Orb's detonation opens a one-time shortcut between the current maze room and any room the caster has already solved.       | Turns a maze the caster already beat into a shortcut through the one they're in.      |
| **The Siege Judgement**       | powerful |      7 | Against a village stone, loses its usual telegraphed delay entirely; against a wizard, the delay is unchanged.                 | The siege shape's finishing move, kept honest everywhere else.                        |
| **The Grimoire Satellite**    | enhanced |      5 | Adds one extra orbiting satellite for every filled Grimoire position beyond the caster's third.                                | Grows with wizard level, up to seven extra satellites at the ten-position cap.        |
| **The Guardian's Beam**       | normal   |      3 | Cast from inside an owned village, the Beam also fires simultaneously from that village's guardian.                            | Two beams for the price of standing at home.                                          |
| **The Season's Swarm**        | normal   |      5 | The Swarm gains one extra fragment for every season that has passed this run, capped at four extra.                            | A late-run Swarm, thin at the very start.                                             |
| **The Vault Seed**            | enhanced |      4 | The Seed triggers when a nearby treasure is opened rather than when stepped on, striking whoever opened it.                    | A trap for the greedy, not the careless.                                              |
| **The Tideturn Nova**         | powerful |      4 | The Nova knocks back a floor's defending echo twice as far as it knocks back a wizard.                                         | A crowd-control Nova built for one specific crowd.                                    |

## Element Artifacts

An Artifact Element gives damage a nature no ordinary Element has: it reads gold, crops, seasons, structures or an echo's own state, rather than just a flavour of harm.

| Name                                | Band     | Weight | What it does                                                                                                                     | Notes                                                                          |
| ----------------------------------- | -------- | -----: | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **The Tithe**                       | enhanced |      4 | Deals damage scaled to the target's own carried gold, converting a portion of it to the caster on a hit.                         | Does nothing against a wizard carrying no gold.                                |
| **The Famine**                      | normal   |      3 | Damage also kills the crops standing in the area it lands.                                                                       | A scorched-earth Element.                                                      |
| **The Debtor's Chill**              | enhanced |      3 | Cold damage that also raises the target's next purchase price one escalation step, as if they had just bought something.         | Makes a rival's rebuild as painful as the caster's own next purchase.          |
| **The Last Stone**                  | powerful |      5 | Ignores magic defence entirely, but only against a target already below 25% health.                                              | A finishing blow and nothing else; it cannot open a fight.                     |
| **The Stolen Season**               | normal   |      3 | Damage is strongest in winter and weakest in spring, following the run's own season clock.                                       | Rewards aggression exactly when the run's own deadline is closest.             |
| **The Petitioner's Spark**          | enhanced |      3 | Lightning with a double-strike chance that scales with the caster's luck and with how many floors they currently hold.           | Weakest at a single held floor, strongest once the caster has gathered many.   |
| **The Priest's Due**                | normal   |      3 | On a kill, cures one of the caster's own corruptions instead of granting the usual reward.                                       | A free visit to the priest, paid for in raw power.                             |
| **The Nameless Frost**              | enhanced |      3 | Damage that cannot be identified by element, denying the target information about the caster's build.                            | Good for ambush, useless for a floor fight the caster actually wants credited. |
| **The Second Winter**               | powerful |      4 | Cold damage; a hit against an echo bars that floor from its owner's next re-snapshot.                                            | A siege weapon built for exactly one kind of target.                           |
| **The Open Ledger**                 | enhanced |      4 | Damage scales with the number of villages the target owns, not the caster's own.                                                 | Hunts landlords; wastes a slot against a newcomer.                             |
| **The Guildless Flame**             | normal   |      2 | Burn duration extends on a target standing inside a village they do not own, and shortens inside their own.                      | Rewards raiding over defending at home.                                        |
| **The Quarrymind**                  | enhanced |      4 | Blunt damage that also splashes onto the nearby village stone even when the primary target is a wizard.                          | A sloppy siege tool.                                                           |
| **The Hollow Verdure**              | enhanced |      4 | Spreads not through nearby bodies but to whichever enemy within range is currently richest.                                      | A plague that follows wealth.                                                  |
| **The Brine of Ten Thousand Tides** | powerful |      5 | The magic-defence reduction lingers as its own mark after the Brine's base duration ends.                                        | Opens a target for a long time.                                                |
| **The Watcher's Gloom**             | normal   |      3 | Strong against any wizard who has not yet appeared on the North Wall, tapering off as the target's level rises.                  | A newcomer-hunter's Element.                                                   |
| **The Last Light**                  | enhanced |      5 | Stronger against echoes and against anything standing inside a maze.                                                             | A floor-raider's and a maze-runner's Element in one.                           |
| **The Blood Price**                 | powerful |      6 | Costs health, but returns more the lower the target's own missing health is, rewarding a finishing blow.                         | The opposite of a safe opener; a closer's weapon only.                         |
| **The Unbroken Null**               | normal   |      6 | True damage that nothing resists, and on a kill removes one random corruption from the caster permanently.                       | A slow path to a clean wizard, never a path to a strong one.                   |
| **The Second Unmaking**             | powerful |      7 | Against an echo, strips its assigned attack and movement strategy for the fight, forcing it to default to aggressive and static. | Against a living wizard it behaves as a weak Null and nothing more.            |
| **The Queue's Patience**            | enhanced |      4 | Grows stronger the longer the caster has survived in this world.                                                                 | Weakest for a wizard who has just joined.                                      |
| **The Guardian's Rust**             | normal   |      5 | Metal damage that deals bonus damage against guardians and village stones specifically.                                          | A siege Element with teeth only for buildings and their defenders.             |
| **The Deep Floor Chill**            | enhanced |      3 | Cold damage whose slow is stronger the higher the floor number it is cast on.                                                    | Weakest near the Lobby, strongest deep in the climb.                           |
| **The World Boss's Ash**            | powerful |      4 | Fire damage whose burn can only be stacked to its full strength against a world boss.                                            | A specialist's Element for the single hardest fight in the open world.         |

## Duration Artifacts

An Artifact Duration bends time in a way no ordinary Duration can: it syncs to the season clock, the run's own deadlines, or the caster's absence, rather than just lasting longer or shorter.

| Name                          | Band     | Weight | What it does                                                                                                                                                   | Notes                                                                             |
| ----------------------------- | -------- | -----: | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **The Season's Patience**     | enhanced |      5 | Persists until the current season changes, then ends on its own regardless of elapsed time.                                                                    | A Duration measured in days, not seconds.                                         |
| **The Sleeper's Clock**       | powerful |      5 | Keeps ticking down while the caster is offline, so a spell cast before logging off can still resolve while away.                                               | A one-shot guard for the exact moment a wizard is most exposed.                   |
| **The Overtime Bell**         | powerful |      4 | Behaves as Instant normally, but becomes Eternal for the length of the final battle's sudden death.                                                            | A single-purpose rune for a phase of the run that may happen only once.           |
| **The Raider's Breath**       | enhanced |      3 | Persists for as long as the caster stays inside the current floor fight, Instant outside it.                                                                   | Timed to a fight the caster might not win.                                        |
| **The Cradle Hour**           | normal   |      3 | Doubles its own length for the caster's first cast after returning from an offline-attack recovery.                                                            | A single strong moment after a rough login.                                       |
| **The Grudge Clock**          | enhanced |      4 | Extends one tick every time the exact same target has already survived this spell, resetting on that target's death.                                           | Rewards a running feud; useless on a stranger.                                    |
| **Grave Standing**            | powerful |      7 | An Eternal effect that, if the caster dies, keeps existing for the rest of the season, defending their last capital, acting without needing the caster nearby. | The one exception to Eternal's near-range rule.                                   |
| **The Long Winter**           | normal   |      3 | A Sustained drain that gets cheaper to hold open every season the current run survives.                                                                        | Punishes an early cast and rewards patience across the whole run.                 |
| **The Final Window**          | powerful |      5 | Persists for the full ten minutes of the window if cast during it, Brief otherwise.                                                                            | One cast, one window, no second chance.                                           |
| **The Hoarder's Lingering**   | enhanced |      4 | A Lingering effect whose strength scales with how many mana-stones the caster currently holds.                                                                 | Rewards stockpiling the resource it is built around.                              |
| **The Turning Floors**        | normal   |      3 | Ticks down one step every time any floor of the Monolith changes hands.                                                                                        | Long in a quiet world, short in a contested one.                                  |
| **The Dungeon Clock**         | normal   |      2 | Persists for exactly as long as the caster remains inside the current dungeon or maze, Instant outside it.                                                     | A Duration with a door built into it.                                             |
| **Guardian's Watch**          | enhanced |      4 | A Lingering effect that automatically rearms once per season while the caster still holds the floor it is bound to.                                            | Self-sustaining for as long as the floor is held.                                 |
| **The Mana-Stone Tally**      | enhanced |      4 | A Sustained drain whose per-tick cost shrinks for every mana-stone the caster has spent this run.                                                              | Rewards spending, not hoarding, the opposite lesson of Hoarder's Lingering.       |
| **The Crop Cycle**            | normal   |      3 | A Lingering effect that automatically re-triggers at the start of each season while the caster still owns the village it was cast near.                        | Offline defence that renews itself on the season clock.                           |
| **The Floorholder's Echoing** | enhanced |      5 | An Echoing effect whose second resolution is not weaker than the first when the target is a floor's defending echo.                                            | Two full hits from one cast against the one target that matters.                  |
| **The Reincarnation Bell**    | normal   |      2 | Behaves as Instant normally, but gains a short Delayed window whose length shortens for every life-stone the caster currently carries.                         | A stone reserve buys back the speed this rune costs.                              |
| **Garrison's Eternal**        | enhanced |      6 | An Eternal effect whose near-range doubles while the caster stands inside any village they own.                                                                | A homecoming bonus on top of Eternal's usual restriction, not an exception to it. |
| **The Blight Ward**           | powerful |      5 | A Lingering effect whose strength is topped back up every time a wizard starts a raid on the bound floor.                                                      | Feeds on the attacks against the floor it defends.                                |
| **The Worldbreaker's Toll**   | powerful |      4 | A Sustained drain that costs no mana per tick at all while held open against a world boss specifically.                                                        | Free to hold open against the one fight that usually drains the fastest.          |
| **The Grimoire's Rest**       | normal   |      2 | A Brief effect whose length extends by a fixed amount for every empty Grimoire position the caster currently has.                                              | Rewards a minimalist Grimoire.                                                    |
| **The Raid Clock**            | enhanced |      3 | A Delayed effect whose delay shortens each time the caster wins a floor raid this season.                                                                      | Gets faster with every floor taken this season.                                   |
| **The Priest's Countdown**    | normal   |      3 | A Lingering effect that, once per run, can be paid off early in the Lobby for one life-stone instead of running its full course.                               | A second, optional door out of a Duration the caster regrets starting.            |
| **The Final Floor's Breath**  | powerful |      5 | Behaves as Sustained normally, but becomes Instant with no mana cost at all while cast inside the window.                                                      | Useless for the entire run except its final ten minutes.                          |

## Effect Artifacts

An Artifact Effect is where the catalogue leans hardest on the game's own systems: floors, echoes, villages, crops, seasons, offline defence, gold, stones, the weight bar, Grimoire positions, world bosses, mazes, permadeath, and reincarnation points.
Each entry below still occupies one of the two ordered Effect slots, the same as any ordinary Effect rune.

| Name                             | Band     | Weight | What it does                                                                                                                                                                                                                  | Notes                                                                             |
| -------------------------------- | -------- | -----: | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **Fief's Toll**                  | enhanced |      5 | Deals bonus damage equal to a share of the target's current gold income rate, paid instantly to the caster as gold.                                                                                                           | Taxes the rich, pays the caster.                                                  |
| **Last Stand on the Wall**       | powerful |      5 | Killing the current floor-leader grants the caster's next raid attempt this season a damage bonus.                                                                                                                            | A bounty rune aimed at whoever is already winning.                                |
| **Contested Ground**             | enhanced |      4 | The first hit against an echo marks the caster as the floor fight's current highest-damage contributor, overriding anyone else.                                                                                               | A lead that must be defended by staying in the fight, not just by striking first. |
| **Season's Appetite**            | normal   |      3 | Bonus damage against an echo scales with how many season ends it has stood through since its snapshot was taken.                                                                                                              | Punishes an owner who never re-snapshots.                                         |
| **The Snapshot Oath**            | powerful |      5 | Defeating a floor's echo with this Effect makes the caster's next re-snapshot cost no life-stone.                                                                                                                             | Turns a won raid into cheaper upkeep.                                             |
| **Still Watching**               | normal   |      3 | Lets the caster assign a second behaviour profile to their echoes, activating if the first fails to land a hit for ten seconds.                                                                                               | A deeper echo than most players will bother affording.                            |
| **The Rotten Harvest**           | enhanced |      4 | Against crops, spreads permanently rather than for a season, continuing to spoil yield until replanted.                                                                                                                       | A long-term economic weapon aimed at someone else's fields.                       |
| **The Shieldbreaker's Patience** | enhanced |      4 | Removes a village shield outright on a hit, regardless of how much absorption remains, bypassing its damage pool.                                                                                                             | One job, done completely, and nothing else attempted.                             |
| **The Ruinous Petition**         | powerful |      6 | Against a tower, forces an immediate ruin, as if the owner had just fallen below their tower cap.                                                                                                                             | Tears down a rival's tower outright.                                              |
| **Second Mortgage**              | enhanced |      4 | On a hit, the target's next village or tower purchase rises one escalation step, as if they had just bought something.                                                                                                        | Spreads the pain of buying.                                                       |
| **Stonewarden's Mark**           | powerful |      5 | Marks a village stone so the next hit from any wizard against it counts toward the caster's own conquest credit.                                                                                                              | Stealing credit for a siege is a gamble on who swings next.                       |
| **The Priest's Shortcut**        | enhanced |      4 | On a kill, cures one of the caster's own corruptions for free, consuming a carried life-stone instead of visiting the priest.                                                                                                 | Only as reliable as the caster's own stone reserve, which is never large.         |
| **The Hoarded Stone**            | enhanced |      5 | A Drain that banks a fraction of returned mana toward a mana-stone instead of spending it immediately, capped at **two stones per run**.                                                                                      | Slow by design; a whole run of use yields one or two stones.                      |
| **Grimoire's Ransom**            | enhanced |      4 | On a kill, if a Grimoire position is empty, fills it for the rest of the season with a random known rune combination, free.                                                                                                   | A free spell with no say in what it turns out to be.                              |
| **Level's Grace**                | normal   |      3 | Against critter and common enemies, the caster takes 10% more damage and deals 10% less; against elite and champion enemies, takes 10% less and deals 10% more. No change against veterans, echoes, wizards and world bosses. | A hunter of strong enemies that pays for it while farming.                        |
| **The Scholar's Shortcut**       | normal   |      3 | Grants a small amount of XP on landing a hit against another wizard, independent of whether it kills them.                                                                                                                    | Trades easy enemy experience for harder-won wizard experience.                    |
| **The World Boss's Scar**        | enhanced |      4 | Against a world boss specifically, ignores a portion of magic defence no ordinary Element can touch.                                                                                                                          | A specialist's rune for the single hardest fight in the open world.               |
| **The Maze-Breaker**             | powerful |      5 | Inside a maze, a hit triggers a puzzle's solved state directly, once per visit, as if the correct rune had been applied.                                                                                                      | One skipped puzzle per visit.                                                     |
| **The Treasure Hunter's Grasp**  | normal   |      2 | Opening a treasure with this Effect slotted guarantees at least a common-rarity rune drop.                                                                                                                                    | A guaranteed floor on treasure quality.                                           |
| **The Permanent Record**         | enhanced |      4 | On the caster's death, banks a small amount of extra RP beyond the usual death payout.                                                                                                                                        | Score banks at death, so it pays under any ending.                                |
| **Truce-Breaker's Mark**         | normal   |      3 | Deals bonus damage against any wizard currently flying a truce flag.                                                                                                                                                          | The answer to a wizard who chose to sit behind a truce flag.                      |
| **The War-Banner's Call**        | normal   |      3 | While flying a war flag, also applies at reduced strength to the nearest other wizard flying a war flag.                                                                                                                      | Rewards a coordinated gang-up and punishes a sloppy one.                          |
| **The Borrowed Beast**           | normal   |      3 | Killing an enemy with this Effect turns the nearest enemy of the same tier into an ally of the caster for 20 seconds.                                                                                                         | Turns a pack against itself.                                                      |
| **Spirit's Last Errand**         | normal   |      3 | On the caster's death, a living spirit keeps fighting with this Effect for a short time before vanishing for good.                                                                                                            | A small, honest gift at the worst possible moment.                                |
| **The Crop Circle**              | normal   |      3 | Against a target standing on a village's crop tile, plants a hazard that lingers through to next season regardless of its own Duration.                                                                                       | Long memory for a battlefield.                                                    |
| **Last Season's Promise**        | powerful |      5 | Damage rises the closer the run is to its final season, read directly off the season clock.                                                                                                                                   | Dead weight for most of the run, a real weapon at the very end of it.             |
| **The Escalator's Edge**         | normal   |      3 | Bonus damage scales with how many total purchases, of any kind, the target has made this run.                                                                                                                                 | Hunts veterans with a deep treasury, not newcomers.                               |
| **The Nine-Floor Reckoning**     | enhanced |      4 | Bonus damage scales with how many floors separate the target's highest held floor from the caster's own.                                                                                                                      | Scales from the caster's own single held floor upward; never a dead stat.         |
| **The Dungeon Debt**             | normal   |      3 | Inside a dungeon or maze, bonus damage scales with how long the caster has already spent inside it this visit.                                                                                                                | Rewards a slow, thorough clear, and nothing about the open world.                 |
| **The Unspent Hour**             | enhanced |      4 | Deals double damage if the caster has not spent a mana-stone this entire season; spending one resets the bonus.                                                                                                               | A hoarder's reward for a hoarder's discipline.                                    |

---

## Corruptions

Corruptions are not authored onto an Artifact.
They are rolled at world generation and paired with whichever Artifact lands on a given floor, so the same corruption can appear on a Shape, an Element, a Duration or an Effect Artifact alike.
Every corruption below is written to make sense bolted onto anything, with no reference to any specific Artifact's effect.
A corruption is cured by the priest in the Lobby for one life-stone.

**Severity follows the band.**
Every corruption is graded **mild**, **harsh** or **severe**.
A `normal` Artifact draws a mild corruption, an `enhanced` one a harsh corruption, a `powerful` one a severe corruption.
The draw is random within the grade, so every world still differs.

| Corruption                | What it costs                                                                                                          | Floor                                        | Severity | Notes                                                             |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- | -------- | ----------------------------------------------------------------- |
| **Thinned Luck**          | Luck drops by 1 while slotted.                                                                                         | luck 1                                       | mild     | Barely noticeable outside a luck-stacked build.                   |
| **Heavy Feet**            | Speed drops by 10 while slotted.                                                                                       | speed 60                                     | mild     | A small, constant drag.                                           |
| **Dulled Ward**           | Magic defence drops by 2 while slotted.                                                                                | magic_defence 2                              | mild     | Cheap to carry on anything with defence to spare.                 |
| **Thin Coffers**          | Gold income drops 5% while slotted.                                                                                    | 80% of unmodified                            | mild     | A tax too small to plan around.                                   |
| **Slow Current**          | Mana regeneration slows by 10% while slotted.                                                                          | 70% of unmodified                            | mild     | Lengthens the wait between casts, not the cast itself.            |
| **Fallow Patch**          | Crop yield on owned villages drops 10% while slotted.                                                                  | 70% of normal                                | mild     | A small bite out of a village's own food.                         |
| **Marked Ledger**         | The caster's next village or tower purchase rises one escalation step.                                                 | 1 step outstanding                           | mild     | A single purchase, slightly dearer.                               |
| **Thin Lessons**          | XP gained from enemies drops 10% while slotted.                                                                        | 70% of unmodified                            | mild     | A slower grind, not a stalled one.                                |
| **Loud Footsteps**        | The caster's name is visible on the North Wall for one minute after each cast of the bound spell.                      | n/a (duration cost)                          | mild     | Reveals a habit, not a position in real time.                     |
| **Shallow Rest**          | Health regeneration outside combat slows by 15% while slotted.                                                         | 70% of unmodified                            | mild     | A longer wait between fights, nothing more.                       |
| **Stiff Cooldown**        | The bound spell's cooldown lengthens by a small fixed amount.                                                          | capped at +25% of base cooldown              | mild     | Noticeable only on a spell already cast often.                    |
| **Dimmed Find**           | Treasure openings roll one tier worse than normal while slotted.                                                       | floored at common                            | mild     | Worse luck on loot, never no loot.                                |
| **Strained Watch**        | The caster's own capital guardian takes 10% more damage while slotted.                                                 | guardian health floor 50% of its own maximum | mild     | A home defence left slightly thinner.                             |
| **Heavier Weave**         | The bound spell's weight rises by a small fixed amount.                                                                | capped at +25% of base weight                | mild     | Nudges the weight bar, does not break it.                         |
| **Weakened Frame**        | Power drops by 15% while slotted.                                                                                      | power 5                                      | harsh    | A real bite out of damage output.                                 |
| **Thin Blood**            | Health drops by 15% while slotted.                                                                                     | health 30                                    | harsh    | Leaves a wizard fragile, never defenceless.                       |
| **Shallow Well**          | Mana pool drops by 20% while slotted.                                                                                  | mana_pool 15                                 | harsh    | Fewer casts before running dry.                                   |
| **Cracked Ward**          | Magic defence drops by 30% while slotted.                                                                              | magic_defence 4                              | harsh    | A real opening for anyone paying attention.                       |
| **Leaden Step**           | Speed drops by 25% while slotted.                                                                                      | speed 50                                     | harsh    | Hard to outrun anything while this is carried.                    |
| **Clouded Fortune**       | Luck drops by 3 while slotted.                                                                                         | luck 1                                       | harsh    | Crits and good drops both suffer.                                 |
| **Hollow Treasury**       | Gold income drops 20% while slotted.                                                                                   | 50% of unmodified                            | harsh    | A real drag on an economic build.                                 |
| **Bound Stones**          | The caster cannot spend a mana-stone while slotted, except to remove this Artifact itself.                             | n/a (behavioural)                            | harsh    | Locks away the run's rarest resource until the floor is given up. |
| **Sworn Enemy**           | The caster cannot raise a truce flag while slotted.                                                                    | n/a (behavioural)                            | harsh    | Forecloses every path to a quiet season.                          |
| **Locked Page**           | One Grimoire position, chosen at random when slotted, is locked and cannot hold a spell until the Artifact is removed. | n/a (behavioural)                            | harsh    | Shrinks the Grimoire by one for as long as it is carried.         |
| **Starved Spell**         | The bound spell cannot benefit from Haste, Mend or Ward while slotted.                                                 | n/a (behavioural)                            | harsh    | Cuts off three of the friendliest Effect runes from one spell.    |
| **Blighted Field**        | Crop yield on owned villages drops 35% while slotted.                                                                  | 40% of normal                                | harsh    | A real wound to a village's food supply.                          |
| **Costly Comeback**       | The caster's next re-snapshot this season costs an extra life-stone, once.                                             | n/a (one-time cost)                          | harsh    | A single expensive upkeep.                                        |
| **Steep Toll**            | The caster's village purchases cost 25% more gold while slotted.                                                       | capped at double unmodified cost             | harsh    | A long-term drag on every rebuild.                                |
| **Shattered Frame**       | Health drops by 35% while slotted.                                                                                     | health 20                                    | severe   | A wizard carrying this cannot afford a second mistake.            |
| **Gutted Strength**       | Power drops by 35% while slotted.                                                                                      | power 3                                      | severe   | A real sacrifice for whatever the Artifact grants.                |
| **Dry Well**              | Mana pool drops by 40% while slotted.                                                                                  | mana_pool 10                                 | severe   | Casting becomes a rationed resource.                              |
| **Broken Ward**           | Magic defence drops by 50% while slotted.                                                                              | magic_defence 1                              | severe   | Nearly every hit lands at full force.                             |
| **Chained Feet**          | Speed drops by 40% while slotted.                                                                                      | speed 40                                     | severe   | Running away stops being an option.                               |
| **Cursed Fortune**        | Luck drops by 4 while slotted.                                                                                         | luck 1                                       | severe   | Nearly every favourable roll disappears.                          |
| **Bankrupt Streak**       | Gold income drops 40% while slotted.                                                                                   | 25% of unmodified                            | severe   | A crippling drag on an economic build.                            |
| **Open Beacon**           | The caster's position is revealed on the North Wall every time the bound spell is cast, for one minute.                | n/a (behavioural)                            | severe   | Every cast announces exactly where the caster is standing.        |
| **Static Echoes**         | The caster's own echoes default to static movement and cannot be reassigned while slotted.                             | n/a (behavioural)                            | severe   | Leaves every held floor defended by the dumbest possible echo.    |
| **Dormant Guardian**      | A random owned village's guardian stays inactive while slotted, reactivating only if the Artifact is removed.          | n/a (behavioural)                            | severe   | One village stands undefended for as long as this is carried.     |
| **Narrow Pocket**         | The caster can hold at most one mana-stone at a time while slotted; any excess is lost on pickup.                      | n/a (behavioural)                            | severe   | Caps the run's rarest resource at its smallest useful amount.     |
| **Doubled Exchange**      | The caster's spell-swap cost in mana-stones doubles while slotted.                                                     | capped at 2 stones per swap                  | severe   | Makes rebuilding the Grimoire expensive.                          |
| **Self-Inflicted Weight** | Self-damage from the caster's own spells, such as Ichor, Sacrifice, Tether or Footprints, doubles while slotted.       | never below 1 health on its own              | severe   | Doubles a risk the caster already chose to take elsewhere.        |
| **Lonely Mending**        | The caster cannot be healed by another wizard's Mend or Leech while slotted, only by their own.                        | n/a (behavioural)                            | severe   | Cuts off outside support in a group fight.                        |

**Catalogue count:** 42 corruptions — 14 mild, 14 harsh, 14 severe.

---

## Catalogue counts

| Attribute | Normal | Enhanced | Powerful | Total   |
| --------- | ------ | -------- | -------- | ------- |
| Shape     | 9      | 9        | 5        | 23      |
| Element   | 7      | 10       | 6        | 23      |
| Duration  | 8      | 9        | 7        | 24      |
| Effect    | 12     | 12       | 6        | 30      |
| **Total** | **36** | **40**   | **24**   | **100** |

## Notes for balancing

**Artifact weights are provisional, and follow one rule.**
An Artifact weighs what the rune it builds on weighs, plus its band, plus at most one step of judgment.

| Part     | Value                                                                                                  |
| -------- | ------------------------------------------------------------------------------------------------------ |
| Anchor   | The weight in `RUNES.md` of the rune the Artifact builds on, or 3, the median, when it builds on none. |
| Band     | +0 normal, +1 enhanced, +2 powerful.                                                                   |
| Judgment | -1 when the effect only applies against one kind of target, +1 when it lasts or reaches unusually far. |

The values will move once a fight can be measured; what they fix now is the ratio between Artifacts.
An Artifact has no rarity, only its band, so its weight is never multiplied.

