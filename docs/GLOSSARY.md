# Glossary — Wizards Towers

The glossary is not decoration.
It is the **contract between the design documents and the identifiers in the code**:
one concept, one word, one spelling, everywhere — in `ASK.md`, in the wiki, in the class names, in the UI strings.

## How to use it

1. **One concept, one term.**
   If two words mean the same thing, one of them is listed under *Banned synonyms* and must never appear again, anywhere.
2. **Every term carries its code form.**
   The `Code` column is authoritative.
   A reviewer may reject a pull request for naming a variable `city_id` when the glossary says `village_id`.
3. **A term with no definition is a design hole.**
   Entries marked `⬜ OPEN` point at the `ASK.md` question that must be answered.
   Do not write code that depends on an open term.
4. **Add the term before you add the feature.**
   If you need a word that is not here, add the row first.
   It takes ten seconds and saves a rename later.

Legend: ✅ decided · ⬜ OPEN (see `ASK.md`)

---

## Entities

| Term            | Definition                                                                                                                                                               | Code                           | Status                    |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------ | ------------------------- |
| **wizard**      | The character a player embodies. One wizard per player per run.                                                                                                          | `Wizard`, `wizard_id`          | ✅                         |
| **village**     | A small settlement on the world map. A player can pay to take ownership of it, which grants a gold income.                                                               | `Village`, `village_id`        | ✅                         |
| **tower**       | A construction built in a village that provides a mana income. Self-defends according to the upgrades its owner chose. A village holds at most one.                      | `Tower`, `tower_id`            | ✅                         |
| **upgrade**     | A purchasable improvement to a tower or village. Raises gold and mana income, adds defences, or unlocks components.                                                      | `Upgrade`, `upgrade_id`        | ✅                         |
| **monolith**    | The single giant tower at the centre of the world, made of floors. **Not a `tower`.**                                                                                    | `Monolith`                     | ⬜ naming — see note below |
| **floor**       | One level of the monolith. Owned by at most one wizard at a time. Claimed by defeating its boss.                                                                         | `MonolithFloor`, `floor_index` | ⬜ 17.2, 17.5              |
| **floor boss**  | Whatever defends a floor. On an unclaimed floor, an authored PvE boss. On a claimed floor, the owner's **echo**.                                                         | `FloorBoss`                    | ⬜ 17.3                    |
| **echo**        | A copy of a wizard, snapshotted when they claimed a floor, which defends that floor against challengers. Fights with the snapshotted spells, not the owner's live build. | `WizardEcho`                   | ⬜ 17.7, 17.8              |
| **NPC village** | A village owned by the game rather than by a player. Sells basic components.                                                                                             | `NpcVillage`                   | ✅                         |
| **world boss**  | A powerful PvE entity on the world map, outside the monolith.                                                                                                            | `WorldBoss`                    | ⬜                         |
| **dungeon**     | A PvE location on the world map, distinct from the monolith.                                                                                                             | `Dungeon`                      | ⬜                         |
| **treasure**    | A lootable container on the world map. A source of rare components.                                                                                                      | `Treasure`                     | ✅                         |

> ⬜ **Naming decision required: `tower` is overloaded.**
> A village tower and the central mega tower are different objects with different rules, and the game is *called* Wizards Towers.
> Leaving both as "tower" guarantees confusion in the code, in the wiki and in the UI.
> **Proposal:**
> **`tower` stays the village building; the central structure becomes the `monolith`.**
> Alternatives:
> `citadel`, `obelisk`, `the Monolith` as a proper noun.
> Pick one now — this word will appear a thousand times.

## Resources

| Term                    | Definition                                                                                                                               | Code                             | Status       |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- | ------------ |
| **gold**                | Currency. Earned from PvE and from owned villages. Spent on villages, upgrades and components.                                           | `gold`                           | ✅            |
| **mana**                | Spellcasting resource. Pool = the wizard's base pool + the income from their towers.                                                     | `mana`, `mana_pool`              | ✅            |
| **income**              | Per-tick resource generation from owned villages (gold) and towers (mana).                                                               | `gold_income`, `mana_income`     | ✅            |
| **component**           | An atomic spell ingredient. Bought from NPC villages, granted by tower upgrades, dropped by bosses, found in treasure.                   | `SpellComponent`, `component_id` | ✅            |
| **reincarnation point** | Meta-progression currency, earned across runs, spent on permanent passive perks. Abbreviated **RP** in prose; never abbreviated in code. | `reincarnation_points`           | ⬜ 13.4, 13.5 |

## Magic

| Term           | Definition                                                                                                | Code                       | Status       |
| -------------- | --------------------------------------------------------------------------------------------------------- | -------------------------- | ------------ |
| **spell**      | A player-authored combination of components, occupying one spell slot, castable on the map.               | `Spell`, `spell_id`        | ✅            |
| **spell slot** | One of a wizard's limited slots. A slot holds at most one spell.                                          | `spell_slot`, `slot_index` | ✅            |
| **recipe**     | The ordered component list that defines a spell. Distinct from the `spell` instance that occupies a slot. | `SpellRecipe`              | ⬜ 12.2       |
| **cast**       | To execute a spell, paying its mana cost and starting its cooldown.                                       | `cast()`                   | ✅            |
| **cooldown**   | The delay before a spell can be cast again.                                                               | `cooldown`                 | ✅            |
| **corruption** | A risk accumulated by casting, which degrades the wizard in some way.                                     | `corruption`               | ⬜ 13.2, 13.3 |
| **element**    | A category a component belongs to. Losing access to an element locks every spell that uses it.            | `Element` (enum)           | ⬜            |

## Session structure

> These four terms are the ones that decide the genre.
> Shape **(d)** has been chosen — a persistent world whose roguelite loop lives inside the monolith — so they are defined accordingly.
> If 18.1 is ever revisited, this whole block changes.

| Term        | Definition                                                                                                                                                                      | Code            | Status                            |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- | --------------------------------- |
| **world**   | One persistent server instance with its own procedurally generated map. Does not reset. Holds the villages, the towers and the monolith.                                        | `World`         | ✅                                 |
| **run**     | One descent into a monolith floor: procedural rooms, randomized component offers, a push-or-bail decision, and a death that costs what you carried. The unit of roguelite play. | `Run`, `run_id` | ⬜ 18.1(d) confirmed, details open |
| **carry**   | What a wizard holds *during* a run and loses on death inside the monolith, as opposed to what persists in the world.                                                            | `carried_*`     | ⬜ 18.2                            |
| **session** | One player's continuous connection to a world. Not a run, not a world. Purely technical.                                                                                        | `PlayerSession` | ✅                                 |

## Banned synonyms

Never use the word on the left. Use the word on the right.

| ✗ Never write                        | ✓ Always write                             | Why                                                                                                                        |
| ------------------------------------ | ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| city, town, settlement               | **village**                                | `ASK.md` 1.3 says "buy a city", 3.2 says "a village/city". Same object. Pick one and it is `village`.                      |
| mega tower, big tower, central tower | **monolith** (pending the naming decision) | `tower` must mean exactly one thing.                                                                                       |
| wizard clone, ghost, copy, replica   | **echo**                                   | "clone" implies a live mirror; "ghost" implies a recorded input replay. Both are wrong — it is a snapshot with derived AI. |
| match, round, season, life           | **run**                                    | Shape (d) was chosen. These words belong to shapes (a) and (c) and will mislead.                                           |
| perk, talent, skill                  | pick **one**, then list the other two here | ⬜ undecided — do not scatter three words for the meta-progression unlock.                                                  |
| HP, life, hitpoints                  | **health**                                 | Godot's own conventions use `health`.                                                                                      |
| mob, monster, creature               | **enemy** (PvE)                            | `enemy` for the generic, `world boss` / `floor boss` for the named ones.                                                   |

## Pending additions

Add a row as soon as the matching `ASK.md` question is answered:

- 17.5 — what owning a floor grants: this will need a term (`floor boon`? `floor tribute`?).
- 17.9 — the mechanism that stops the monolith from freezing: `decay`? `challenge window`?
- 18.3 — the source of per-run randomness: `offer`, `draft`, `modifier`?
- 18.4 — the limited per-run component selection: `loadout`? `draft`?
- 15.6 / 19.2 — the skin-modding unit: `skin`, `skin pack`, `texture override`?
