# Glossary — Wizards Towers

The glossary is not decoration.
It is the **contract between the design documents and the identifiers in the code**:
one concept, one word, one spelling, everywhere — in the design document, in the wiki, in the class names, in the UI strings.

## How to use it

1. **One concept, one term.**
   If two words mean the same thing, one of them is listed under *Banned synonyms* and must never appear again, anywhere.
2. **Every term carries its code form.**
   The `Code` column is authoritative.
   A reviewer may reject a pull request for naming a variable `city_id` when the glossary says `village_id`.
3. **A term with no definition is a design hole.**
   Entries marked ⬜ carry the question that must be answered.
   Do not write code that depends on an open term.
4. **Add the term before you add the feature.**
   If you need a word that is not here, add the row first.

Legend:
✅ decided · ⬜ open

---

## Entities

| Term              | Definition                                                                                                                                                                                                                                        | Code                    | Status |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- | ------ |
| **wizard**        | The character a player embodies. One wizard per player per run.                                                                                                                                                                                   | `Wizard`, `wizard_id`   | ✅      |
| **wizard type**   | The starting template, fixed for the run, deciding the **one** weapon kind a wizard may hold. Four: **Sorcerer** (wand), **Magus** (staff), **Arcanist** (tome), **Oracle** (relic). Never named `wizard`.                                        | `WizardType` (enum)     | ✅      |
| **weapon**        | What a wizard holds: wand, staff, tome or relic. **Exactly one kind**, never the other three. Survives an offline attack. A weapon of the wrong kind is sold for gold or **traded**.                                                              | `Weapon`, `weapon_id`   | ✅      |
| **village**       | A settlement on the world map, procedurally named. Bought with gold or won by quest. Produces gold income. Cannot be sold.                                                                                                                        | `Village`, `village_id` | ✅      |
| **capital**       | The one village a wizard designates as home. They teleport there on logout and reappear there on login. Season rewards are claimed here.                                                                                                          | `capital_village_id`    | ✅      |
| **tower**         | A construction built in a village that produces mana income and defends itself per its upgrades. One per village. Never the Monolith.                                                                                                             | `Tower`, `tower_id`     | ✅      |
| **upgrade**       | A purchasable improvement to a village or a tower. Raises income, adds defences, unlocks runes.                                                                                                                                                   | `Upgrade`, `upgrade_id` | ✅      |
| **guardian**      | A defensive unit stationed in a village by an upgrade. Holds a place and never leaves it. Catalogued in `SPIRITS_GUARDIANS.md`.                                                                                                                   | `Guardian`              | ✅      |
| **spirit**        | A small follower that accompanies a wizard. Follows a person and never holds ground. Catalogued in `SPIRITS_GUARDIANS.md`.                                                                                                                        | `Spirit`                | ✅      |
| **NPC village**   | A village owned by the game. Sells basic runes and issues quests.                                                                                                                                                                                 | `NpcVillage`            | ✅      |
| **enemy**         | Any hostile NPC combatant. Tiers: critter, common, veteran, elite, champion. **Enemies use their own authored attacks, never the rune and spell system.** An elemental weakness is a per-enemy specificity, not a system.                         | `Enemy`, `enemy_id`     | ✅      |
| **special enemy** | An enemy that spawns only from a stated condition — splitting off a dying enemy, summoned, or risen from a corpse. A **season-gated** enemy is not special: it spawns by itself, in one season.                                                   | `is_special`            | ✅      |
| **world boss**    | A powerful PvE entity on the world map, outside the Monolith. Strength varies by season. Catalogued in `WORLD_BOSSES.md`.                                                                                                                         | `WorldBoss`             | ✅      |
| **dungeon**       | An instanced PvE location. Safe from other wizards. Entering **breaks the peace shield**. One entrance is season-gated. Catalogued in `DUNGEONS.md`.                                                                                              | `Dungeon`               | ✅      |
| **maze**          | The puzzle variant of a dungeon, solved by thinking rather than fighting. The only non-combat XP source. A maze requiring a rune picks one that **already appeared in this world**, so it is never globally unsolvable. Catalogued in `MAZES.md`. | `Maze`                  | ✅      |
| **treasure**      | A lootable container on the world map. A source of rare runes.                                                                                                                                                                                    | `Treasure`              | ✅      |

## Stats

Every combatant uses the same six stats: wizard, enemy, world boss, echo, guardian.
A level-1 wizard with no talents is the baseline.

| Term              | Definition                                                                                                                                          | Code            | Baseline | Status |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- | -------- | ------ |
| **combatant**     | Anything carrying a stat block: wizard, enemy, world boss, echo, guardian. `creature` is banned; `enemy` is wrong here because a wizard is not one. | `Combatant`     | —        | ✅      |
| **health**        | Damage a combatant absorbs before dying.                                                                                                            | `health`        | 100      | ✅      |
| **power**         | Offensive strength. **One** stat whether the combatant strikes in melee or at range.                                                                | `power`         | 10       | ✅      |
| **magic defence** | Damage reduction. Spelled the British way, with a `c`.                                                                                              | `magic_defence` | 10       | ✅      |
| **speed**         | Movement rate, where 100 is a normal walk.                                                                                                          | `speed`         | 100      | ✅      |
| **luck**          | Chance of a favourable roll: a crit, a second Spark strike, a better drop.                                                                          | `luck`          | 5        | ✅      |
| **attack type**   | Descriptive only, `melee` or `magic`. Never a second power stat.                                                                                    | `attack_type`   | —        | ✅      |

`mana pool` is the sixth stat and lives in **Resources**, because a wizard's grows with tower income.

## The Monolith

A Monolith is composed of the **Lobby**, then `floor1` to `floor{wizards - 1}`, then the **ROOF**.

| Term                   | Definition                                                                                                                                                                                                                                          | Code                           | Status |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ | ------ |
| **the Monolith**       | The single giant tower at the centre of the world. Proper noun in prose, `Monolith` in code. Never a `tower`.                                                                                                                                       | `Monolith`                     | ✅      |
| **the Lobby**          | The Monolith's base: a neutral safe zone with merchants and the priest. Not a numbered floor.                                                                                                                                                       | `LOBBY`                        | ✅      |
| **floor**              | One numbered level of the Monolith. A world has **`current wizards - 1`**, so a joining wizard unlocks one and the building is a visible population counter. Held by at most one wizard.                                                            | `MonolithFloor`, `floor_index` | ✅      |
| **the ROOF**           | The final stage, above the highest floor. Payable once every floor below has been raided. Costs gold and a mana-stone, **spent**, plus a held Artifact as a key, **never spent**. Taking it ends the run.                                           | `ROOF`                         | ✅      |
| **the window**         | The ten minutes started by the **first payment** for the ROOF. Wizards prepare, pay from a tower, and are teleported to the Lobby when it closes. Payment is final.                                                                                 | `final_window`                 | ✅      |
| **overtime**           | The extension keeping a world alive while a ROOF fight is unresolved. Ended by sudden death, not by patience. Non-participants may spectate or keep playing, their gains counting at **25 %**.                                                      | `overtime`                     | ✅      |
| **sudden death**       | The resolution for an overlong ROOF fight: from minute 5 the battle minimap contracts by **10 % of its original size every minute**, reaching zero at minute 15. Linear, not compounding.                                                           | `sudden_death`                 | ✅      |
| **floor boss**         | Whatever defends a floor. An authored PvE boss on a never-raided floor, the owner's echo afterwards.                                                                                                                                                | `FloorBoss`                    | ✅      |
| **echo**               | A snapshot of a wizard taken when they claimed a floor, which then defends it. Carries their stats, weapon, Grimoire and mana pool, plus a behaviour the owner assigns. Also defends the owner's capital while offline.                             | `WizardEcho`                   | ✅      |
| **echo from the past** | An echo whose owner has died. It does **not** vanish and the floor is **not** freed: the echo keeps defending until some wizard raids it.                                                                                                           | `is_orphaned`                  | ✅      |
| **re-snapshot**        | How an owner updates their own echo. At a season's end, spend a **life-stone** to replace one echo with a snapshot of the wizard's end-of-season state. **One per season**, so holding two floors forces a choice. No fight, and nothing to repair. | `re_snapshot()`                | ✅      |
| **flee**               | Abandoning a floor fight. Allowed on any floor; it locks that floor for **12 hours** for the wizard who failed, and nobody else. The **ROOF cannot be fled**: once paid, the fight is to the death.                                                 | `flee_floor()`                 | ✅      |
| **season reward**      | Granted for ending a season holding at least one floor, claimable **at the capital**. It must be collected quickly and a raider can take it first — which is what stops a wizard hoarding strength to raid only at the end.                         | `SeasonReward`                 | ✅      |
| **the North Wall**     | A giant inscription against the invisible wall at the world's north edge, naming every wizard who holds a floor and which floor it is. **The ROOF is never listed** — clearing it ends the run.                                                     | `NorthWall`                    | ✅      |

## Resources

| Term                    | Definition                                                                                                                                                                                               | Code                         | Status |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- | ------ |
| **gold**                | Currency. Earned from PvE and from owned villages. Spent on villages, upgrades, towers and equipment.                                                                                                    | `gold`                       | ✅      |
| **mana**                | Current spellcasting resource, spent per cast and regenerated.                                                                                                                                           | `mana`                       | ✅      |
| **mana pool**           | A wizard's **maximum** mana: base value plus tower income. Never write `max_mana_pool`.                                                                                                                  | `mana_pool`                  | ✅      |
| **income**              | Per-tick resource generation: gold from villages, mana from towers.                                                                                                                                      | `gold_income`, `mana_income` | ✅      |
| **mana-stone**          | A consumable spent on magical commitments: **unlocking a Grimoire position**, and paying for the ROOF. A run yields roughly the wizard's maximum level plus three.                                       | `ManaStone`                  | ✅      |
| **life-stone**          | A consumable spent on vital commitments: **re-snapshotting an echo**, curing a corruption at the priest, raising a village shield. A wizard holds **two or three** across a run, plus the starter stone. | `LifeStone`                  | ✅      |
| **starter life-stone**  | The one life-stone a wizard begins with, meant for the shield on their first village. Sits outside the run average so it cannot be hoarded.                                                              | `starter_life_stone`         | ✅      |
| **village shield**      | A barrier bought with a life-stone that absorbs a fixed amount of damage, then vanishes.                                                                                                                 | `VillageShield`              | ✅      |
| **escalating price**    | Every purchase type has its own multiplier, rising with the number held. **Cumulative for the whole run — it never resets**, not even when a holding is sold or lost.                                    | `price_multiplier`           | ✅      |
| **trade**               | A consensual transfer of items between two wizards, and the only one in the game. The route for a weapon its finder cannot use: sell it to a shop for gold, or trade it to a wizard who can hold it.     | `Trade`                      | ✅      |
| **reincarnation point** | Meta-progression currency surviving death and the wipe. Earned from wizard kills, dungeons, world bosses and floors, then spent on talents. **RP** in prose, never in code.                              | `reincarnation_points`       | ✅      |
| **talent**              | A permanent unlock bought with RP: a stat bonus, a wizard type, a weapon, or making a rune findable in future worlds.                                                                                    | `Talent`, `talent_id`        | ✅      |
| **score**               | The per-wizard figure converting a run into RP. **Banked at the wizard's death, or at the end of the run** — under any ending. Overtime gains count at 25 %. The winner receives a bonus on top.         | `run_score`                  | ✅      |

## Magic

A spell is **computed, not authored**.
Its five runes are composed into a result, and the result is then measured to derive its mana cost — which is why no combination can be cheap and strong at the same time.

Order matters **only between `Effect1` and `Effect2`**.
The other three attributes are single positions, so swapping them would mean nothing.

The two Effect slots must hold **different** runes, and a spell may contain **at most one Artifact**.

| Term                  | Definition                                                                                                                                                                                                                                                                                              | Code                          | Status |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ------ |
| **rune**              | The atomic spell ingredient. Each rune belongs to exactly one attribute. Bought from NPC villages, granted by tower upgrades, dropped by bosses, found in treasure.                                                                                                                                     | `Rune`, `rune_id`             | ✅      |
| **attribute**         | One of the **four** categories a rune belongs to: Shape, Element, Duration, Effect. Effect fills two ordered slots, so four attributes make five spell slots.                                                                                                                                           | `RuneAttribute` (enum)        | ✅      |
| **reach**             | Whether a spell acts on the wizard, at arm's length, outward, or at a designated point: `self`, `melee`, `ranged`, `placed`. **Not chosen** — a property of the Shape rune, printed so the player sees it.                                                                                              | `reach` (enum)                | ✅      |
| **spell slot**        | A position inside a spell that one rune fills. Five exist: Shape, Element, Duration, Effect1, Effect2. The first three are **mandatory**; the two Effect slots are **optional, ordered, and may not repeat a rune**.                                                                                    | `spell_slot`, `slot_index`    | ✅      |
| **spell**             | A castable whole, assembled from runes in its spell slots. Behaviour and mana cost are computed from the result, never authored.                                                                                                                                                                        | `Spell`, `spell_id`           | ✅      |
| **spell editing**     | Creating or changing a spell in an unlocked Grimoire position. Free, but only **from the wizard's own tower**. One exception: when an Artifact is lost, the broken spell is editable **from anywhere**, because the wizard did not choose that repair.                                                  | `edit_spell()`                | ✅      |
| **weight bar**        | The crafting display: a bar running from 1 to the wizard's mana pool that fills as rune **weight** is added. No figure is ever shown.                                                                                                                                                                   | `WeightBar`                   | ✅      |
| **headroom**          | The unfilled remainder of the weight bar. What a tome grants more of.                                                                                                                                                                                                                                   | `headroom`                    | ✅      |
| **Grimoire**          | The book holding every spell a wizard possesses. Kept untranslated in all languages. Capacity derives from the wizard's level — there is **no separate Grimoire level**.                                                                                                                                | `Grimoire`                    | ✅      |
| **Grimoire position** | One of the numbered places in a Grimoire, each holding at most one spell. Count is `max(1, wizard_level - 1)`. **Unlocking one costs a mana-stone.**                                                                                                                                                    | `grimoire_position`           | ✅      |
| **rarity**            | A grade shared by runes, Artifacts and weapons alike: common, rare or legendary. **One scale, no separate ladders.** Rarity scales how strongly a thing acts; it never changes what it does.                                                                                                            | `Rarity` (enum)               | ✅      |
| **weight**            | The cost pressure one rune contributes, and the primary input to the computed mana cost. Authored per rune in `RUNES.md`; multiplied by rarity (×1.0 / ×1.4 / ×2.0). **A weight is never a mana cost.** Range 0 to 6 at common.                                                                         | `weight`                      | ✅      |
| **Artifact**          | A rune bound to a **floor**, not a wizard: hold the floor, use the rune. **100 in the catalogue**; a world deals one to each of floors 1-48. **At most one per spell.** Losing the floor empties the slot, refillable with no mana-stone. Banded by floor: 1-19 normal, 20-39 enhanced, 40-48 powerful. | `Artifact`, `artifact_id`     | ✅      |
| **corruption**        | The cost attached to an Artifact. **Effect and corruption are separate catalogues, paired at world generation**, graded so a `powerful` Artifact draws a `severe` corruption. Every drain has a floor. Cured by the priest for a life-stone.                                                            | `Corruption`, `corruption_id` | ✅      |
| **cast**              | To execute a spell, paying its mana cost and starting its cooldown.                                                                                                                                                                                                                                     | `cast()`                      | ✅      |
| **cooldown**          | The delay before a spell can be cast again. Shortened by the Duration attribute.                                                                                                                                                                                                                        | `cooldown`                    | ✅      |
| **element**           | The attribute giving a spell its elemental nature. Fourteen exist, listed in `RUNES.md`.                                                                                                                                                                                                                | `Element` (enum)              | ✅      |

## Session structure

A run is the life of a world, not a trip into a dungeon.
Everything a wizard owns is run-scoped and lost with them: villages, towers, floors, gold, runes, spells.
Only reincarnation points, talents and cosmetics cross the wipe.

| Term                         | Definition                                                                                                                                                                                                                                           | Code                | Status |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- | ------ |
| **world**                    | One server instance with its own procedurally generated map, holding its villages, towers and Monolith. **Ends** — it is not permanent.                                                                                                              | `World`, `world_id` | ✅      |
| **run**                      | The whole life of one world: at most four seasons, so 4 × 48 h. Ends when a wizard takes the ROOF, or when winter runs out. A wizard lives one run at most.                                                                                          | `Run`, `run_id`     | ✅      |
| **season**                   | One of spring, summer, autumn and winter. Each lasts 48 h and is one quarter of a run. Drives crops, dungeon entrances, world boss strength and seasonal enemies.                                                                                    | `Season` (enum)     | ✅      |
| **good ending**              | An ending in which a wizard **won** by taking the ROOF. Good for that wizard specifically; every other wizard got a bad ending.                                                                                                                      | `GOOD_ENDING`       | ✅      |
| **bad ending**               | Any ending in which no wizard won. Several exist, each with its own name and screen.                                                                                                                                                                 | `BadEnding` (enum)  | ✅      |
| **World Collapse**           | The bad ending where winter expires with the ROOF unclaimed.                                                                                                                                                                                         | `WORLD_COLLAPSE`    | ✅      |
| **Devoured by the Monolith** | The bad ending where sudden death completes and the world falls with every finalist still standing in it. No winner's bonus, because nobody won.                                                                                                     | `DEVOURED`          | ✅      |
| **Murdered by its own kin**  | A bad ending named for a world undone by its wizards rather than by the Monolith.                                                                                                                                                                    | `MURDERED`          | ⬜      |
| **Invasion of Monsters**     | A bad ending named for a world overrun. `monster` is legal **here**, in an ending's proper name, and remains banned as a word for an enemy.                                                                                                          | `INVASION`          | ⬜      |
| **peace shield**             | Protection carried by a level-1 **wizard's person**. Broken permanently by their **first attack**, by **entering a dungeon or maze**, or by reaching **level 2**.                                                                                    | `peace_shield`      | ✅      |
| **queue**                    | The waiting list that opens a new world. 20 wizards required for the first 5 minutes, then one fewer each minute, resting at **10** and never lower. The screen shows a far minimap of the world and its principal spawns, never which one is yours. | `WorldQueue`        | ✅      |
| **wizard level**             | The only progression number in a run. Gates the peace shield, the second village, village upgrades and Grimoire positions. XP comes from combat, from **quests**, and from **mazes** — the only non-combat source.                                   | `wizard_level`      | ✅      |
| **session**                  | One player's continuous connection to a world. Neither a run nor a world. Purely technical.                                                                                                                                                          | `PlayerSession`     | ✅      |

⬜ `Murdered by its own kin` and `Invasion of Monsters` are named but their trigger conditions are not yet written.

## Offline and ownership

| Term                    | Definition                                                                                                                                                                                                           | Code              | Status |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- | ------ |
| **landlord management** | The panel where a wizard manages villages and towers. On login after losing a level, it **forces** them to choose a tower to ruin if they now exceed the tower cap.                                                  | `LandlordPanel`   | ✅      |
| **ruin**                | What becomes of a tower a wizard must give up. The tower and its upgrades are gone; the village's upgrades survive.                                                                                                  | `ruin_tower()`    | ✅      |
| **offline summary**     | The report shown on login, listing what happened while the wizard was away: villages raided, floors lost, season rewards pending, and any tower that must now be ruined.                                             | `OfflineSummary`  | ✅      |
| **raid alert**          | The notice a wizard receives when one of their villages comes under raid while they are online, so they may travel there and defend it in person.                                                                    | `RaidAlert`       | ✅      |
| **echo behaviour**      | The attack strategy (aggressive, defensive, balanced) and movement strategy (hit-and-run, static, circling, keep-distance) a wizard assigns per echo.                                                                | `EchoBehaviour`   | ✅      |
| **untouchable**         | The state of a level-1 wizard who logs off owning no village: nothing can be taken because nothing is held. Not an exploit — such a wizard is the weakest on the server and still loses a level on an offline death. | `is_untouchable`  | ✅      |
| **skin**                | A packaged file replacing visual assets, chosen through an in-game selector. Local to the player who installs it; the server never redistributes it. Skin authors license their work as they wish.                   | `Skin`, `skin_id` | ⬜      |

⬜ A **skin**'s packaging format: a single `skin_id` archive, or a folder.

## Banned synonyms

**The ban is scoped to the thing being named.**
If you are naming *this concept*, the words on the left are forbidden and the word on the right is required.
The same word can be legal elsewhere: `Invasion of Monsters` is a valid ending name even though `monster` is banned as a word for an **enemy**.

| ✗ Never write for this concept         | ✓ Always write        | Why                                                                                                                                                |
| -------------------------------------- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| city, town, settlement                 | **village**           | Early answers used both for the same object.                                                                                                       |
| mega tower, big tower, central tower   | **the Monolith**      | `tower` means the village building and nothing else.                                                                                               |
| Ground Floor                           | **the Lobby**         | The Monolith's base is `LOBBY` in code, so prose follows.                                                                                          |
| Floor 49, the Summit, final floor      | **the ROOF**          | Floor count varies with population, so no number can name the top.                                                                                 |
| component, ingredient                  | **rune**              | Replaced when spell slots were defined.                                                                                                            |
| Range, Touch, Near, Far, Horizon       | **(deleted)**         | Range was cut as an attribute. The surviving axis is `reach`, a property of the Shape rune.                                                        |
| cost bar                               | **weight bar**        | What the player adds is weight; the cost is derived and never shown as a figure.                                                                   |
| wizard clone, ghost, copy, replica     | **echo**              | "Clone" implies a live mirror, "ghost" a replay of inputs. It is neither: a snapshot with derived AI.                                              |
| refresh, re-raid                       | **re-snapshot**       | Both older mechanics are gone. There is no fight against your own echo.                                                                            |
| decay (of an echo)                     | **(deleted)**         | Echo decay was dropped together with the re-raid.                                                                                                  |
| match, round, life                     | **run**               | A run is a whole world's life. `lobby` is banned for a run but **is** the Monolith's base.                                                         |
| perk, skill, ability                   | **talent**            | Talents are what RP buy.                                                                                                                           |
| legendary rune                         | **Artifact**          | `legendary` is a rarity grade, so the old name collided with it.                                                                                   |
| `max_mana_pool`                        | **`mana_pool`**       | `mana_pool` is already the maximum. `mana` is the current value.                                                                                   |
| HP, life, hitpoints                    | **health**            | Matches Godot's own conventions.                                                                                                                   |
| mob, monster, creature                 | **enemy**             | `enemy` for the generic, `world boss` and `floor boss` for the named ones. For anything with a stat block including a wizard, write **combatant**. |
| enigma dungeon, puzzle dungeon         | **maze**              | Plural **mazes**.                                                                                                                                  |
| `melee_power`, `magic_power`           | **`power`**           | One stat for both. `attack type` says which, descriptively.                                                                                        |
| `grimoire_level`                       | **`wizard_level`**    | Grimoire capacity is derived: `max(1, wizard_level - 1)`.                                                                                          |
| spell slot (as a wizard's spell count) | **Grimoire position** | `spell slot` is a position *inside* a spell that a rune fills.                                                                                     |
