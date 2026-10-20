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
| **dungeon**     | An instanced PvE location. Safe from other wizards. Entering **breaks the peace shield**. One entrance is season-gated. Two kinds: combat dungeons and **mazes**.                                                            | `Dungeon`                | ⬜       |
| **maze**        | The puzzle variant of a dungeon, solved by thinking rather than fighting. The only non-combat XP source. Entering one breaks the peace shield. May be unsolvable **for you**; must never be unsolvable for everyone.    | `Maze`                   | ⬜ 32.5  |
| **treasure**    | A lootable container on the world map. A source of rare runes.                                                                        | `Treasure`              | ✅      |

## Stats

Every combatant uses the same six stats: wizard, enemy, world boss, echo.
A level-1 wizard with no talents is the baseline.

| Term              | Definition                                                                                                                                      | Code            | Baseline | Status |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | --------------- | -------- | ------ |
| **combatant**     | Anything that carries a stat block: a wizard, an enemy, a world boss, an echo. The word `creature` is banned, and `enemy` is wrong here because a wizard is not one. | `Combatant`     | —        | ✅      |
| **health**        | Damage a combatant absorbs before dying.                                                                                                        | `health`        | 100      | ✅      |
| **power**         | Offensive strength. **One** stat whether the combatant strikes in melee or at range — the backend does not distinguish them.                     | `power`         | 10       | ✅      |
| **magic defence** | Damage reduction. Spelled the British way, with a `c`.                                                                                          | `magic_defence` | 10       | ✅      |
| **speed**         | Movement rate, where 100 is a normal walk.                                                                                                      | `speed`         | 100      | ✅      |
| **luck**          | Chance of a favourable roll: a crit, a second Spark strike, a better drop.                                                                        | `luck`          | 5        | ✅      |
| **attack type**   | Descriptive only, `melee` or `magic`. Never a second power stat.                                                                                 | `attack_type`   | —        | ✅      |

`mana pool` is the sixth stat and lives in **Resources**, because a wizard's grows with tower income.

## The Monolith

| Term               | Definition                                                                                                                                                                                                                       | Code                           | Status |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ | ------ |
| **the Monolith**   | The single giant tower at the centre of the world. Proper noun in prose, `Monolith` in code. Never a `tower`.                                                                                                                    | `Monolith`                     | ✅      |
| **Ground Floor**   | The Monolith's base: a neutral safe zone with merchants and the priest. Not a numbered floor.                                                                                                                                    | `GroundFloor`                  | ✅      |
| **floor**          | One numbered level of the Monolith. A world has **`current wizards - 1`** floors, so a joining wizard unlocks one and the building is a visible population counter. Held by at most one wizard. Each is harder than the one below. Whether the Monolith can **lose** floors when wizards die is undecided.                                                                                                | `MonolithFloor`, `floor_index` | ⬜ 32.3 |
| **Floor 49**       | The final floor, and the name is now wrong: with `wizards - 1` floors, a small world's final floor is not the 49th. Needs a number-free name — **the Summit** proposed. Payable once every lower floor has been raided. Costs gold and a mana-stone, **spent**, plus a held Artifact as a key, **never spent**. Taking it ends the run.                                                                                       | `FINAL_FLOOR`                  | ⬜ 32.3 |
| **the window**     | The ten minutes started by the **first payment** for Floor 49. Wizards prepare, pay from a tower, and are teleported to the Monolith's Ground Floor when it closes. Payment is final: it survives losing every tower afterwards.                                                                                 | `final_window`                 | ✅      |
| **overtime**       | The extension that keeps a world alive while a Floor 49 fight is still unresolved. Ended by sudden death, not by patience. Non-participants may spectate the fight or keep playing the world, their gains counting at **25 %**.                                                                                 | `overtime`                     | ✅      |
| **sudden death**   | The resolution mechanism for an overlong Floor 49 fight: from minute 5, the battle minimap contracts by **10 % of its original size every minute**, reaching zero at minute 15. Linear, not compounding — so it actually arrives.                                                                                 | `sudden_death`                 | ✅      |
| **floor boss**     | Whatever defends a floor. An authored PvE boss on a never-raided floor, the owner's echo afterwards.                                                                                                                             | `FloorBoss`                    | ✅      |
| **echo**           | A snapshot of a wizard taken when they claimed a floor, which then defends it. Carries their stats, weapon, Grimoire and mana pool, plus a behaviour the owner assigns. Also defends the owner's capital while they are offline. A **rival** fights it as it is, decayed; its **owner** re-raiding fights it at full power. | `WizardEcho`                   | ✅      |
| **decay**          | The weakening an echo suffers each season: **-20 % compounding**, so three decays leave an echo at 51 % of its original strength.                                                                                                      | `decay_echo()`                 | ✅      |
| **re-raid**        | How an owner restores their own echo: pay a life-stone, fight the echo **at full power**, and on winning replace it with a fresh snapshot at **decay - 1**. **Losing the fight kills the wizard** — the echo is as lethal to its owner as to anyone else. Never restores to zero, so a skipped season can never be fully repaired. Replaces the word "refresh".                                                                                                      | `re_raid()`                    | ⬜ 32.2 |
| **the North Wall** | A giant inscription suspended against the invisible wall at the north edge of the world, naming every wizard who holds a floor and which floor it is.                                                                            | `NorthWall`                    | ✅      |

## Resources

| Term                    | Definition                                                                                                                                                                    | Code                         | Status |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- | ------ |
| **gold**                | Currency. Earned from PvE and from owned villages. Spent on villages, upgrades, towers and equipment.                                                                         | `gold`                       | ✅      |
| **mana**                | Current spellcasting resource, spent per cast and regenerated.                                                                                                                | `mana`                       | ✅      |
| **mana pool**           | A wizard's **maximum** mana: base value plus tower income. Never write `max_mana_pool` — `mana_pool` is already the maximum, `mana` is the current value.                     | `mana_pool`                  | ✅      |
| **income**              | Per-tick resource generation: gold from villages, mana from towers.                                                                                                           | `gold_income`, `mana_income` | ✅      |
| **mana-stone**          | A consumable spent on magical commitments: replacing a spell in an occupied Grimoire position, and paying for the final floor. A wizard should hold **three to five** across a whole run. Whether swapping a single rune inside an existing spell also costs one is undecided.                                                       | `ManaStone`                  | ⬜ 32.1 |
| **life-stone**          | A consumable spent on vital commitments: refreshing your own echo, curing a corruption at the priest, raising a village shield. Named for what it costs you. A wizard should hold **two or three** across a whole run, plus the starter stone.                  | `LifeStone`                  | ✅      |
| **starter life-stone**  | The one life-stone a wizard begins with, meant for the shield on their first village. Sits outside the two-or-three run average so it cannot be hoarded.                  | `starter_life_stone`         | ✅      |
| **village shield**      | A barrier bought with a life-stone that absorbs a fixed amount of damage, then vanishes.                                                                                      | `VillageShield`              | ✅      |
| **escalating price**    | Every purchase type has its own multiplier, which rises with the number currently held and falls when holdings are lost. Buying a village makes villages dearer, not weapons. | `price_multiplier`           | ✅      |
| **reincarnation point** | Meta-progression currency surviving death and the wipe. Earned from wizard kills, dungeons, world bosses and floors, then spent on talents. **RP** in prose, never in code.   | `reincarnation_points`       | ✅      |
| **talent**              | A permanent unlock bought with RP: a stat bonus, a wizard type, a weapon, or making a rune findable in future worlds.                                                         | `Talent`, `talent_id`        | ✅      |
| **score**               | The per-wizard figure that converts a finished run into RP. Snapshotted **when the world closes**, not when the final floor falls; gains made during overtime count at 25 %. The winner receives a bonus on top. Whether a **dead** wizard banks their score is undecided.                                                               | `run_score`                  | ⬜ 32.4 |

## Magic

A spell is **computed, not authored**.
Its six runes are composed into a result, and the result is then measured to derive its mana cost — which is why no combination can be cheap and strong at the same time.

Order matters **only between `Effect1` and `Effect2`**.
The other four attributes are single positions, so swapping them would mean nothing.

| Term                  | Definition                                                                                                                                                                                           | Code                          | Status |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ------ |
| **rune**              | The atomic spell ingredient. Each rune belongs to exactly one attribute. Bought from NPC villages, granted by tower upgrades, dropped by bosses, found in treasure.                                  | `Rune`, `rune_id`             | ✅      |
| **attribute**         | One of the **five** categories a rune can belong to: Shape, Range, Element, Duration, Effect. Effect fills two ordered slots, so five attributes make six spell slots.                                                                                                           | `RuneAttribute` (enum)        | ✅      |
| **spell slot**        | A position inside a spell that one rune fills. Six exist: Shape, Range, Element, Duration, Effect1, Effect2. The first four are **mandatory** for a spell to be castable; the two Effect slots are **optional and ordered**. Levels 1 and 2 unlock them.                           | `spell_slot`, `slot_index`    | ✅      |
| **spell**             | A castable whole, assembled from runes in its spell slots. Behaviour and mana cost are computed from the result, never authored. **Where it may be crafted or edited is undecided.**                                                                     | `Spell`, `spell_id`           | ⬜ 32.1 |
| **cost bar**          | The crafting display: a bar running from 1 to the wizard's mana pool that fills as runes are added. No figure is ever shown.                                                                         | `CostBar`                     | ✅      |
| **Grimoire**          | The book holding every spell a wizard possesses. Kept untranslated in all languages. How many it holds is derived from the wizard's level — there is **no separate Grimoire level**.                                                                                             | `Grimoire`                    | ✅      |
| **Grimoire position** | One of the numbered places in a Grimoire, each holding at most one spell. Count is `max(1, wizard_level - 1)`: levels 1 and 2 give one, level 3 gives two, and each level after adds one.                                                                                        | `grimoire_position`           | ✅      |
| **rarity**            | A rune's grade: common, rare or legendary. Rarity scales how strongly a rune acts; it never changes what the rune does.                                                                              | `Rarity` (enum)               | ✅      |
| **Artifact**          | A rune bound to a **floor**, not to a wizard: hold the floor, use the rune. **100 exist as a catalogue**; world generation deals one to each of floors 1-48, so every world draws a different 48. Lose the floor and the rune leaves your spell — refilling the slot costs no mana-stone. One is enough to open the final floor; holding spares **denies entry to others**. Power banded by floor: 1-19 normal, 20-39 enhanced, 40-48 powerful. | `Artifact`, `artifact_id`     | ✅      |
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
| **bad ending**   | A run that expires in winter with the final floor unclaimed. Every wizard dies and nobody receives the winner's bonus.                                             | `BAD_ENDING`        | ✅                   |
| **collapse**     | The other way a world can end: sudden death finishes and the world falls with every finalist still in it. Whether it is the bad ending or an ending of its own is undecided.                                             | `COLLAPSE`          | ⬜ 32.4              |
| **peace shield** | Protection carried by a level-1 **wizard's person**. Broken permanently by their **first attack**, by **entering a dungeon**, or by reaching **level 2**. A second village and every village upgrade require level 2, so turtling at level 1 yields almost no income.                | `peace_shield`      | ✅                   |
| **queue**        | The waiting list that opens a new world. 20 wizards required for the first 5 minutes, then one fewer each minute, resting at **10** and never going lower. The screen shows a far minimap of the world and its principal spawns, never which one is yours.                | `WorldQueue`        | ✅                   |
| **wizard level** | The only progression number in a run. Gates the peace shield, the second village, village upgrades, spell slots and Grimoire positions. XP comes from combat and from **quests**, which grant a small amount; **mazes** are the proposed non-combat source.                | `wizard_level`      | ⬜ 32.5              |
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
| mob, monster, creature                 | **enemy**             | `enemy` for the generic, `world boss` and `floor boss` for the named ones. For anything with a stat block including a wizard, write **combatant**. |
| enigma dungeon, puzzle dungeon    | **maze**           | Renamed in round 10 by the designer. Plural **mazes**.                                                           |
| `melee_power`, `magic_power`      | **`power`**        | One stat for both. `attack type` says which, and it is descriptive only.                                         |
| refresh (an echo)                 | **re-raid**        | A refresh was a payment. A re-raid is a fight against your own echo at full power, which you can lose.           |
| `grimoire_level`                  | **`wizard_level`**        | Retired in round 8. Grimoire capacity is derived: `max(1, wizard_level - 1)`. Two names for one number.           |
| spell slot (as a wizard's spell count) | **Grimoire position** | `spell slot` was redefined: it is a position *inside* a spell that a rune fills.                              |

## Pending additions

Add a row as soon as the matching design question is answered.

- 32.1 — where spells may be crafted or edited, whether a forced Artifact repair is exempt, and whether a mana-stone is charged for swapping one rune.
- 32.2 — whether an echo fight can be fled, and whether progression is steep enough for the re-raid to be a sane bet.
- 32.3 — the name of the final floor now that floor count varies, and whether the Monolith can lose floors.
- 32.4 — whether the collapse is its own ending, and whether a dead wizard banks their score.
- 32.5 — the generation constraint guaranteeing a puzzle's required rune exists, and how many enigma types to build.
- 15.6 — the skin-modding unit is settled (`skin`), but confirm the packaging format (`skin_id` vs folder).