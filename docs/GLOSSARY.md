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
   Entries marked `⬜ OPEN` carry the number of the design question that must be answered.
   Do not write code that depends on an open term.
4. **Add the term before you add the feature.**
   If you need a word that is not here, add the row first.
   It takes ten seconds and saves a rename later.

Legend:
✅ decided · ⬜ open, with the design question number

---

## Entities

| Term            | Definition                                                                                                                            | Code                    | Status |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- | ------ |
| **wizard**      | The character a player embodies. One wizard per player per run.                                                                       | `Wizard`, `wizard_id`   | ✅      |
| **wizard type** | A starting template unlocked with RP, setting base health, mana pool, speed, magic defence, luck and which weapons may be held.       | `WizardType`            | ✅      |
| **weapon**      | What a wizard holds: wand, staff, tome or relic. Survives an offline attack.                                                          | `Weapon`, `weapon_id`   | ✅      |
| **village**     | A settlement on the world map, procedurally named. Bought with gold or won by quest. Produces gold income. Cannot be sold.            | `Village`, `village_id` | ✅      |
| **capital**     | The one village a wizard designates as home. They teleport there on logout and reappear there on login.                               | `capital_village_id`    | ✅      |
| **tower**       | A construction built in a village that produces mana income and defends itself per its upgrades. One per village. Never the Monolith. | `Tower`, `tower_id`     | ✅      |
| **upgrade**     | A purchasable improvement to a village or a tower. Raises income, adds defences, unlocks runes.                                       | `Upgrade`, `upgrade_id` | ✅      |
| **guardian**    | A defensive unit stationed in a village by an upgrade.                                                                                | `Guardian`              | ⬜ 11.6 |
| **spirit**      | A small follower that accompanies a wizard.                                                                                           | `Spirit`                | ⬜ 10.7 |
| **NPC village** | A village owned by the game. Sells basic runes and issues quests.                                                                     | `NpcVillage`            | ✅      |
| **world boss**  | A powerful PvE entity on the world map, outside the Monolith. Strength varies by season.                                              | `WorldBoss`             | ⬜      |
| **dungeon**     | An instanced PvE location. Safe from other wizards. One entrance is season-gated.                                                     | `Dungeon`               | ⬜      |
| **treasure**    | A lootable container on the world map. A source of rare runes.                                                                        | `Treasure`              | ✅      |

## The Monolith

| Term               | Definition                                                                                                                                                                                                                       | Code                           | Status |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ | ------ |
| **the Monolith**   | The single giant tower at the centre of the world. Proper noun in prose, `Monolith` in code. Never a `tower`.                                                                                                                    | `Monolith`                     | ✅      |
| **Ground Floor**   | The Monolith's base: a neutral safe zone with merchants and the priest. Not a numbered floor.                                                                                                                                    | `GroundFloor`                  | ✅      |
| **floor**          | One numbered level of the Monolith, 1 to 49. Held by at most one wizard. Each floor is harder than the one below.                                                                                                                | `MonolithFloor`, `floor_index` | ✅      |
| **Floor 49**       | The final floor. The ten-minute window opens once floors 1 to 48 have all been raided by somebody. Taking it ends the run.                                                                                                       | `FINAL_FLOOR`                  | ✅      |
| **the window**     | The ten minutes between floors 1-48 falling and Floor 49 opening. Wizards prepare, then pay from a tower and are teleported to the Ground Floor.                                                                                 | `final_window`                 | ⬜ 28.3 |
| **floor boss**     | Whatever defends a floor. An authored PvE boss on a never-raided floor, the owner's echo afterwards.                                                                                                                             | `FloorBoss`                    | ✅      |
| **echo**           | A snapshot of a wizard taken when they claimed a floor, which then defends it. Carries their stats, weapon, Grimoire and mana pool, plus a behaviour the owner assigns. Also defends the owner's capital while they are offline. | `WizardEcho`                   | ✅      |
| **decay**          | The weakening an echo suffers each season. Refreshing it costs a life-stone and is only possible once a decay has occurred.                                                                                                      | `decay_echo()`                 | ✅      |
| **the North Wall** | A giant inscription suspended against the invisible wall at the north edge of the world, naming every wizard who holds a floor and which floor it is.                                                                            | `NorthWall`                    | ✅      |

## Resources

| Term                    | Definition                                                                                                                                                                    | Code                         | Status |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- | ------ |
| **gold**                | Currency. Earned from PvE and from owned villages. Spent on villages, upgrades, towers and equipment.                                                                         | `gold`                       | ✅      |
| **mana**                | Current spellcasting resource, spent per cast and regenerated.                                                                                                                | `mana`                       | ✅      |
| **mana pool**           | A wizard's **maximum** mana: base value plus tower income. Never write `max_mana_pool` — `mana_pool` is already the maximum, `mana` is the current value.                     | `mana_pool`                  | ✅      |
| **income**              | Per-tick resource generation: gold from villages, mana from towers.                                                                                                           | `gold_income`, `mana_income` | ✅      |
| **mana-stone**          | A consumable spent on magical commitments: replacing a spell in an occupied Grimoire position, and paying for Floor 49.                                                       | `ManaStone`                  | ⬜ 28.1 |
| **life-stone**          | A consumable spent on vital commitments: refreshing your own echo, curing a corruption at the priest, raising a village shield. Named for what it costs you.                  | `LifeStone`                  | ⬜ 28.1 |
| **village shield**      | A barrier bought with a life-stone that absorbs a fixed amount of damage, then vanishes.                                                                                      | `VillageShield`              | ⬜ 28.1 |
| **escalating price**    | Every purchase type has its own multiplier, which rises with the number currently held and falls when holdings are lost. Buying a village makes villages dearer, not weapons. | `price_multiplier`           | ✅      |
| **reincarnation point** | Meta-progression currency surviving death and the wipe. Earned from wizard kills, dungeons, world bosses and floors, then spent on talents. **RP** in prose, never in code.   | `reincarnation_points`       | ✅      |
| **talent**              | A permanent unlock bought with RP: a stat bonus, a wizard type, a weapon, or making a rune findable in future worlds.                                                         | `Talent`, `talent_id`        | ✅      |
| **score**               | The per-wizard figure that converts a finished run into RP. The winner receives a bonus on top.                                                                               | `run_score`                  | ⬜ 20.3 |

## Magic

A spell is **computed, not authored**.
Its six runes are composed into a result, and the result is then measured to derive its mana cost — which is why no combination can be cheap and strong at the same time.

Order matters **only between `Effect1` and `Effect2`**.
The other four attributes are single positions, so swapping them would mean nothing.

| Term                  | Definition                                                                                                                                                                                           | Code                          | Status |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ------ |
| **rune**              | The atomic spell ingredient. Each rune belongs to exactly one attribute. Bought from NPC villages, granted by tower upgrades, dropped by bosses, found in treasure.                                  | `Rune`, `rune_id`             | ✅      |
| **attribute**         | One of the six categories a rune can belong to, and therefore one position inside a spell.                                                                                                           | `RuneAttribute` (enum)        | ✅      |
| **spell slot**        | A position inside a spell that one rune fills. Six exist: Shape, Range, Element, Duration, Effect1, Effect2. Level 1 opens the first four; Effect slots open from level 2.                           | `spell_slot`, `slot_index`    | ⬜ 28.2 |
| **spell**             | A castable whole, assembled from runes in its spell slots. Behaviour and mana cost are computed from the result, never authored.                                                                     | `Spell`, `spell_id`           | ✅      |
| **cost bar**          | The crafting display: a bar running from 1 to the wizard's mana pool that fills as runes are added. No figure is ever shown.                                                                         | `CostBar`                     | ✅      |
| **Grimoire**          | The book holding every spell a wizard possesses. Kept untranslated in all languages. Its level sets how many spells fit.                                                                             | `Grimoire`, `grimoire_level`  | ✅      |
| **Grimoire position** | One of the numbered places in a Grimoire, each holding at most one spell. Grimoire level N gives N positions.                                                                                        | `grimoire_position`           | ⬜ 28.2 |
| **rarity**            | A rune's grade: common, rare or legendary. Rarity scales how strongly a rune acts; it never changes what the rune does.                                                                              | `Rarity` (enum)               | ✅      |
| **Artifact**          | A world-unique rune won by claiming a floor. One hundred per world, each a generated triple of attribute, effect and corruption. Power banded by floor: 1-19 normal, 20-39 enhanced, 40-48 powerful. | `Artifact`, `artifact_id`     | ✅      |
| **corruption**        | The cost attached to an Artifact, paired with its power rather than punishing on its own. Every drain has a floor. Cured by the priest for a life-stone.                                             | `Corruption`, `corruption_id` | ✅      |
| **cast**              | To execute a spell, paying its mana cost and starting its cooldown.                                                                                                                                  | `cast()`                      | ✅      |
| **cooldown**          | The delay before a spell can be cast again. Shortened by the Duration attribute.                                                                                                                     | `cooldown`                    | ✅      |
| **element**           | The attribute that gives a spell its elemental nature.                                                                                                                                               | `Element` (enum)              | ⬜      |

## Session structure

A run is the life of a world, not a trip into a dungeon.
Everything a wizard owns is run-scoped and lost with them: villages, towers, floors, gold, runes, spells.
Only reincarnation points, talents and cosmetics cross the wipe.

| Term             | Definition                                                                                                                                                  | Code                | Status              |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- | ------------------- |
| **world**        | One server instance with its own procedurally generated map, holding its villages, towers and Monolith. **Ends** — it is not permanent.                     | `World`, `world_id` | ✅                   |
| **run**          | The whole life of one world: at most four seasons, so 4 × 48 h. Ends when a wizard takes Floor 49, or when winter runs out. A wizard lives one run at most. | `Run`, `run_id`     | ⬜ rename — see note |
| **season**       | One of spring, summer, autumn and winter. Each lasts 48 h and is one quarter of a run. Drives crops, dungeon entrances, world boss strength and echo decay. | `Season` (enum)     | ✅                   |
| **bad ending**   | A run that expires in winter with Floor 49 unclaimed. Every wizard dies and nobody receives the winner's bonus.                                             | `BAD_ENDING`        | ✅                   |
| **peace shield** | Protection carried by a level-1 wizard, lost permanently on reaching level 2. Not a timer — the wizard decides when to drop it by levelling.                | `peace_shield`      | ⬜ 28.4              |
| **session**      | One player's continuous connection to a world. Neither a run nor a world. Purely technical.                                                                 | `PlayerSession`     | ✅                   |

---

⬜ **Naming decision: `run` vs `world` vs `rune`.**
`run` is the roguelite term for the whole lifespan of a world. `world` is the server-side term for the same instance. They are synonyms — pick one and ban the other.
`run` and `rune` are visually close; a future reader will confuse them. If `run` stays, consider `Run`/`run` capitalisation as the only distinction. If `world` stays, `run` disappears and `rune` has no neighbour.

---

## Offline and ownership

| Term                    | Definition                                                                                                                                                                                         | Code              | Status |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- | ------ |
| **landlord management** | The panel where a wizard manages villages and towers, and is forced to ruin a tower after dropping below the cap.                                                                                  | `LandlordPanel`   | ⬜ 26.6 |
| **ruin**                | What becomes of a tower a wizard must give up. The tower and its upgrades are gone; the village's upgrades survive.                                                                                | `ruin_tower()`    | ✅      |
| **offline summary**     | The report shown on login, listing what happened to the wizard's holdings while they were away.                                                                                                    | `OfflineSummary`  | ⬜ 21.2 |
| **echo behaviour**      | The attack strategy (aggressive, defensive, balanced) and movement strategy (hit-and-run, static, circling, keep-distance) a wizard assigns per echo.                                              | `EchoBehaviour`   | ✅      |
| **skin**                | A packaged file replacing visual assets, chosen through an in-game selector. Local to the player who installs it; the server never redistributes it. Skin authors license their work as they wish. | `Skin`, `skin_id` | ✅      |

## Banned synonyms

Never use the word on the left.
Use the word on the right.

| ✗ Never write                          | ✓ Always write        | Why                                                                                                           |
| -------------------------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------- |
| city, town, settlement                 | **village**           | Early answers used both for the same object. It is `village`.                                                 |
| mega tower, big tower, central tower   | **the Monolith**      | `tower` means the village building and nothing else.                                                          |
| component, ingredient                  | **rune**              | "Component" was the early word and was replaced when spell slots were defined.                                |
| wizard clone, ghost, copy, replica     | **echo**              | "Clone" implies a live mirror, "ghost" implies a replay of inputs. It is neither: a snapshot with derived AI. |
| match, round, lobby, life              | **run**               | A run is a whole world's life. **season** is a real term and is no longer banned.                             |
| perk, skill, ability                   | **talent**            | Talents are what RP buy.                                                                                      |
| legendary rune                         | **Artifact**          | `legendary` is already a rarity grade, so the old name collided with it.                                      |
| `max_mana_pool`                        | **`mana_pool`**       | `mana_pool` is already the maximum. `mana` is the current value.                                              |
| HP, life, hitpoints                    | **health**            | Matches Godot's own conventions.                                                                              |
| mob, monster, creature                 | **enemy**             | `enemy` for the generic, `world boss` and `floor boss` for the named ones.                                    |
| spell slot (as a wizard's spell count) | **Grimoire position** | `spell slot` was redefined: it is a position *inside* a spell that a rune fills.                              |

## Pending additions

Add a row as soon as the matching design question is answered.

- 28.1 — whether life-stone and mana-stone share a pool, and what drops them.
- 28.2 — whether Grimoire level or wizard level gates how many of the six spell slots are usable.
- 28.3 — how the ten-minute Floor 49 window works, and whether it is reachable.
- 28.4 — whether the peace shield is also granted to a wizard who reincarnates at level 1 into an existing world.
- 15.6 — the skin-modding unit is settled (`skin`), but confirm the packaging format (`skin_id` vs folder).