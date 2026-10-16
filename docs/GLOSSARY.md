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

| Term            | Definition                                                                                                                             | Code                    | Status |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- | ------ |
| **wizard**      | The character a player embodies. One wizard per player per run.                                                                        | `Wizard`, `wizard_id`   | ✅      |
| **village**     | A settlement on the world map, procedurally named. Bought with gold or won by completing a quest for the locals. Produces gold income. | `Village`, `village_id` | ✅      |
| **capital**     | The one village a wizard designates as their home. They teleport to it on logout and reappear there on login.                          | `capital_village_id`    | ✅      |
| **tower**       | A construction built in a village that produces mana income and defends itself per its upgrades. One per village. Never the Monolith.  | `Tower`, `tower_id`     | ✅      |
| **upgrade**     | A purchasable improvement to a village or a tower. Raises income, adds defences, unlocks runes.                                        | `Upgrade`, `upgrade_id` | ✅      |
| **guardian**    | A defensive unit stationed in a village by an upgrade.                                                                                 | `Guardian`              | ⬜ 11.6 |
| **spirit**      | A small follower that accompanies a wizard.                                                                                            | `Spirit`                | ⬜ 10.7 |
| **NPC village** | A village owned by the game. Sells basic runes and issues quests.                                                                      | `NpcVillage`            | ✅      |
| **world boss**  | A powerful PvE entity on the world map, outside the Monolith. Strength varies by season.                                               | `WorldBoss`             | ⬜      |
| **dungeon**     | An instanced PvE location on the world map. Safe from other wizards. One entrance is season-gated.                                     | `Dungeon`               | ⬜      |
| **treasure**    | A lootable container on the world map. A source of rare runes.                                                                         | `Treasure`              | ✅      |

## The Monolith

| Term               | Definition                                                                                                                                                                                                                         | Code                           | Status |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ | ------ |
| **the Monolith**   | The single giant tower at the centre of the world. Proper noun in prose, `Monolith` in code. Never a `tower`.                                                                                                                      | `Monolith`                     | ✅      |
| **Ground Floor**   | The Monolith's base: a neutral safe zone with merchants and the priest. Not a numbered floor.                                                                                                                                      | `GroundFloor`                  | ✅      |
| **floor**          | One numbered level of the Monolith, 1 to 49. Held by at most one wizard. Floor 2 is harder than floor 1, and so on up.                                                                                                             | `MonolithFloor`, `floor_index` | ✅      |
| **Floor 49**       | The final floor. Opens only once floors 1 to 48 have all been raided by somebody, then costs gold and mana pool to enter. Taking it ends the world.                                                                                | `FINAL_FLOOR`                  | ⬜ 27.4 |
| **floor boss**     | Whatever defends a floor. An authored PvE boss on a never-raided floor, the owner's echo afterwards.                                                                                                                               | `FloorBoss`                    | ✅      |
| **echo**           | A snapshot of a wizard taken when they claimed a floor, which then defends it. Carries their stats, weapon, Grimoire and mana pool, plus a behaviour chosen by the owner. Also defends the owner's capital while they are offline. | `WizardEcho`                   | ✅      |
| **decay**          | The weakening an echo suffers each season, which is what eventually reopens a held floor.                                                                                                                                          | `decay_echo()`                 | ⬜ 27.2 |
| **the North Wall** | A giant inscription suspended against the invisible wall at the north edge of the world, naming every wizard who holds a floor and which floor it is.                                                                              | `NorthWall`                    | ✅      |

## Resources

| Term                    | Definition                                                                                                                                                                                             | Code                         | Status                     |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------- | -------------------------- |
| **gold**                | Currency. Earned from PvE and from owned villages. Spent on villages, upgrades, towers, equipment and Floor 49.                                                                                        | `gold`                       | ✅                          |
| **mana**                | Spellcasting resource, spent per cast and regenerated.                                                                                                                                                 | `mana`                       | ✅                          |
| **mana pool**           | A wizard's maximum mana. Base value plus the income from their towers. Spent permanently as the price of Floor 49, and reduced by some corruptions.                                                    | `mana_pool`                  | ✅                          |
| **income**              | Per-tick resource generation: gold from villages, mana from towers.                                                                                                                                    | `gold_income`, `mana_income` | ✅                          |
| **mana-stone**          | A consumable required to replace a spell already sitting in a Grimoire position. A free position costs nothing.                                                                                        | `ManaStone`                  | ✅                          |
| **reincarnation point** | Meta-progression currency surviving death and world wipe. Earned from wizard kills, dungeons cleared, world bosses and floors held, then spent on talents. Abbreviated **RP** in prose, never in code. | `reincarnation_points`       | ✅                          |
| **talent**              | A permanent unlock bought with RP: a small stat bonus, a wizard type, a weapon, or making a rune findable in future worlds.                                                                            | `Talent`, `talent_id`        | ✅                          |
| **score**               | The per-wizard figure that converts a finished run into RP. The winner receives a bonus on top.                                                                                                        | `run_score`                  | ⬜ 20.3 — formula undefined |

## Magic

A spell is **computed, not authored**.
Its six runes are composed into a result, and the result is then measured to derive its mana cost — which is why no combination can be cheap and strong at the same time.

Order matters **only between `Effect1` and `Effect2`**.
The other four attributes are single positions, so swapping them would mean nothing.

| Term                  | Definition                                                                                                                                                                                                  | Code                          | Status |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ------ |
| **rune**              | The atomic spell ingredient. Each rune belongs to exactly one attribute. Bought from NPC villages, granted by tower upgrades, dropped by bosses, found in treasure.                                         | `Rune`, `rune_id`             | ✅      |
| **attribute**         | One of the six categories a rune can belong to, and therefore one position inside a spell.                                                                                                                  | `RuneAttribute` (enum)        | ✅      |
| **spell slot**        | A position inside a spell that one rune fills. Six per spell: Shape, Range, Element, Duration, Effect1, Effect2. **Not** a wizard's spell count — that is a Grimoire position.                              | `spell_slot`, `slot_index`    | ✅      |
| **spell**             | A castable whole, assembled from runes in its six spell slots. Its behaviour and its mana cost are computed from the result, not authored.                                                                  | `Spell`, `spell_id`           | ✅      |
| **Grimoire**          | The book holding every spell a wizard possesses. Kept untranslated in all languages. Its level sets how many spells fit.                                                                                    | `Grimoire`, `grimoire_level`  | ✅      |
| **Grimoire position** | One of the numbered places in a Grimoire, each holding at most one spell. Grimoire level N gives N positions.                                                                                               | `grimoire_position`           | ✅      |
| **rarity**            | A rune's grade: common, rare or legendary. Rarity scales how strongly a rune acts; it never changes what the rune does.                                                                                     | `Rarity` (enum)               | ✅      |
| **Artifact**          | A world-unique rune won by claiming a floor. One hundred exist per world, each a randomly generated triple of attribute, effect and corruption, assigned to floors at world creation. Rarer than legendary. | `Artifact`, `artifact_id`     | ✅      |
| **corruption**        | The cost attached to an Artifact, paired with its power rather than punishing on its own. Drawn from a defined list of effects. Cured by the Monolith's priest.                                             | `Corruption`, `corruption_id` | ⬜ 27.1 |
| **cast**              | To execute a spell, paying its mana cost and starting its cooldown.                                                                                                                                         | `cast()`                      | ✅      |
| **cooldown**          | The delay before a spell can be cast again. Shortened by the Duration attribute.                                                                                                                            | `cooldown`                    | ✅      |
| **element**           | The attribute that gives a spell its elemental nature.                                                                                                                                                      | `Element` (enum)              | ⬜      |

## Session structure

A run is the life of a world, not a trip into a dungeon.
Everything a wizard owns is run-scoped and lost with them: villages, towers, floors, gold, runes, spells.
Only reincarnation points, talents and cosmetics cross the wipe.

| Term             | Definition                                                                                                                                                                  | Code                | Status |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- | ------ |
| **world**        | One server instance with its own procedurally generated map, holding its villages, towers and Monolith. **Ends** — it is not permanent.                                     | `World`, `world_id` | ✅      |
| **run**          | The whole life of one world: eight days, four seasons, ending when a wizard takes Floor 49 or when winter does. A wizard lives one run at most, because death is permanent. | `Run`, `run_id`     | ✅      |
| **season**       | One quarter of a run, two days long. Changes crops, dungeon entrances and world boss strength, and ticks echo decay.                                                        | `Season` (enum)     | ✅      |
| **bad ending**   | A run that expires in winter with Floor 49 unclaimed. Every wizard dies and nobody receives the winner's bonus.                                                             | `BAD_ENDING`        | ✅      |
| **peace shield** | Temporary protection granted to a wizard who joins a world already in progress.                                                                                             | `peace_shield`      | ⬜ 9.4  |
| **session**      | One player's continuous connection to a world. Neither a run nor a world. Purely technical.                                                                                 | `PlayerSession`     | ✅      |

## Offline and ownership

| Term                    | Definition                                                                                                                          | Code                   | Status  |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ---------------------- | ------- |
| **landlord management** | The panel where a wizard manages their villages and towers, and where they are forced to ruin a tower after dropping below the cap. | `LandlordPanel`        | ⬜ 26.6  |
| **ruin**                | What becomes of a tower a wizard is forced to give up. The tower and its upgrades are gone; the village's upgrades survive.         | `ruin_tower()`         | ✅       |
| **offline summary**     | The report shown on login, listing what happened to the wizard's holdings while they were away.                                     | `OfflineSummary`       | ⬜ 21.2  |
| **echo behaviour**      | The attack and movement strategy a wizard assigns to each of their echoes.                                                          | `EchoBehaviour` (enum) | ⬜ 23.2  |

## Banned synonyms

Never use the word on the left.
Use the word on the right.

| ✗ Never write                               | ✓ Always write        | Why                                                                                                                    |
| ------------------------------------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| city, town, settlement                      | **village**           | Early design answers used both for the same object. It is `village`.                                                   |
| mega tower, big tower, central tower        | **the Monolith**      | `tower` means the village building and nothing else.                                                                   |
| component, ingredient                       | **rune**              | "Component" was the early word and was replaced when spell slots were defined. One word only.                          |
| wizard clone, ghost, copy, replica          | **echo**              | "Clone" implies a live mirror, "ghost" implies a replay of recorded inputs. It is neither: a snapshot with derived AI. |
| match, round, lobby, life                   | **run**               | A run is a whole world's life. Note that **season** is now a real term and no longer banned.                           |
| perk, skill, ability                        | **talent**            | Talents are what RP buy. Decided.                                                                                      |
| legendary rune                              | **Artifact**          | `legendary` is already a rarity grade, so the old name collided with it.                                               |
| HP, life, hitpoints                         | **health**            | Matches Godot's own conventions.                                                                                       |
| mob, monster, creature                      | **enemy**             | `enemy` for the generic, `world boss` and `floor boss` for the named ones.                                             |
| spell slot (meaning a wizard's spell count) | **Grimoire position** | `spell slot` was redefined: it is now a position *inside* a spell that a rune fills.                                   |

## Pending additions

Add a row as soon as the matching design question is answered.

- 27.1 — the list of corruption effects, and whether any of them is unbounded.
- 27.2 — the price of refreshing an echo, which decides whether decay does anything at all.
- 27.3 — whether Grimoire level or wizard level gates how many of the six spell slots are usable.
- 27.4 — how the ten-minute Floor 49 window works, and whether it is reachable.
- 15.6 — the skin-modding unit: `skin`, `skin pack`, `texture override`?
