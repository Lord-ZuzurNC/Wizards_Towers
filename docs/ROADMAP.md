# Roadmap — Wizards Towers

- [Roadmap — Wizards Towers](#roadmap--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [What the alpha is](#what-the-alpha-is)
  - [Done so far](#done-so-far)
  - [Placeholders still standing](#placeholders-still-standing)
  - [Milestone 1 — Real combat](#milestone-1--real-combat)
  - [Milestone 2 — A living world](#milestone-2--a-living-world)
  - [Milestone 3 — Identity and saving](#milestone-3--identity-and-saving)
  - [Milestone 4 — Territory and economy](#milestone-4--territory-and-economy)
  - [Milestone 5 — Dungeons and mazes](#milestone-5--dungeons-and-mazes)
  - [Milestone 6 — The Monolith and the end of a run](#milestone-6--the-monolith-and-the-end-of-a-run)
  - [Milestone 7 — The alpha itself](#milestone-7--the-alpha-itself)

## How to read this document

This is a guide, not a contract: it orders the large steps between today and an alpha, and lists the design decisions each step waits on.
The order of the milestones is settled; what sits inside each one may move.

**Every milestone ends with a playable test, checked by hand before the next one starts.**

Each milestone has two lists:
- **Decisions**: what must be settled before its code starts. A decision is ticked once it is written into the document named beside it.
- **Build**: what the milestone delivers. An item is ticked once its code is merged and tested.

**Decisions are settled one milestone ahead.**
While milestone N is being built, the decisions of milestone N + 1 are argued and written down, so code never waits on design.

A decision marked **undocumented** has no design at all yet: no document mentions it beyond a passing phrase.

## What the alpha is

**One complete run, reduced: every part of the game is present, but only part of its content.**
Queue, world, four seasons, combat against monsters and wizards, villages, the Monolith and a world ending, scored at the end.

Content is cut, not systems:
- some enemies, some world bosses, some dungeons, some mazes;
- some runes, some cards, some Artifacts;
- placeholder art and sound where the real ones are not ready.

**Played by a small group of testers on a real server.**

## Done so far

- [x] **Groundwork**: a Godot 4.7 project split into `core/`, `client/`, `server/`; a headless test runner that also catches leaks; an enforced formatter.
- [x] **Network**: client-server handshake with a protocol version; a client of another version is refused.
- [x] **Movement**: 8 directions, predicted by the client and decided by the server to the pixel; rooms joined by exits; other wizards drawn 100 ms behind to stay smooth.
- [x] **Combat, first pass**: a spell on a training dummy through the `FORMULAS.md` damage formula; XP, levels, and a card choice of three.
- [x] **Economy, first pass**: gold from dummies; buying a village at an escalating price; the level-2 rule for a second village; a purchase judged where the wizard stood when the key was pressed.
- [x] **Rendering**: drawn at screen resolution with no frame cap; Pixel Operator font; every colour from BLK NX64, checked by test.
- [x] **World map, first pass**: 8 biomes, impassable sea, spines, craters and rift cores; a camera that follows; the biome underfoot named.
- [x] **Controls**: a spell grid of ten positions, five keys and the same five with Shift; key names as the player's own keyboard prints them.
- [x] **Seasons**: four seasons; water freezes in winter; rift banks burn in summer; the glacier slows in winter; World Collapse when winter runs out, everyone back in the start room.

## Placeholders still standing

Each of these is a stand-in that a milestone below replaces.

- [ ] Every number is provisional (`data/placeholder_values.tres`).
- [ ] Nobody dies: health stops at 1. → milestone 1
- [ ] The world map is hand-made and drawn in one piece. → milestone 2
- [ ] No lag compensation. → milestone 1
- [ ] Nothing is saved. → milestone 3
- [ ] The spell bar is two plain rows, not the design in `ART_DIRECTION.md`, *Spell bar*. → milestone 7
- [ ] A season lasts 2 minutes instead of 48 hours. → milestone 7

## Milestone 1 — Real combat

The heart of the game; everything else plugs into it.

**Decisions**
- [ ] `raw_damage`, from the spell's magnitude and the caster's `power` (`FORMULAS.md`).
- [ ] The mana cost of a spell from `spell_weight`, and its cooldown from Duration and Element (`FORMULAS.md`).
- [ ] The XP needed for each `wizard_level` (`FORMULAS.md`).
- [ ] How long Ember's burn and Rime's slow last, and what they deal (`FORMULAS.md`).
- [ ] **What happens when a wizard dies**: `GLOSSARY.md` says a wizard lives one run at most; what does the player do next, watch or leave? (`GLOSSARY.md`, wizard ending)
- [ ] **The inventory**: where carried runes and weapons live, and how many. **Undocumented.**
- [ ] Lag compensation: kept deferred for the alpha, or built now (`TECH_STACK.md`).
- [ ] The runes and Artifacts in the alpha subset (`RUNES.md`, `ARTIFACTS.md`).

**Build**
- [ ] Spells assembled from runes: Shape, Element, Duration, Effect.
- [ ] The Grimoire and spell editing.
- [ ] Weapons and wizard types.
- [ ] Wizard against wizard.
- [ ] Status effects.
- [ ] The death of a wizard.
- [ ] The peace shield.

## Milestone 2 — A living world

**Decisions**
- [ ] The theme of every dungeon and world boss, by biome (`WORLD_MAP.md`).
- [ ] Hand-painted masks for some worlds, or generated only (`WORLD_MAP.md`).
- [ ] The enemies and world bosses in the alpha subset (`ENNEMIES.md`, `bestiary/`, `WORLD_BOSSES.md`).
- [ ] Interest management: whether the alpha needs it (`TECH_STACK.md`).

**Build**
- [ ] The real map, generated from the mask and streamed in pieces.
- [ ] Each client receives only what stands near it.
- [ ] Enemies of the bestiary, their behaviour, and where and when they appear by biome and season.
- [ ] World bosses.
- [ ] Treasures.

## Milestone 3 — Identity and saving

Before the economy: villages held while their owner is offline mean nothing without an identity that lasts.

**Decisions**
- [ ] Plain accounts for the alpha, or the social sign-ins already (`TECH_STACK.md`).

**Build**
- [ ] Accounts.
- [ ] A wizard that lasts: on reconnecting, the player finds their wizard and villages again.
- [ ] Saving in PostgreSQL.
- [ ] Recovery after a server crash.

## Milestone 4 — Territory and economy

**Decisions**
- [ ] **Quests**: what a quest is, who gives it, what it pays, how many there are. **Undocumented**; only `GLOSSARY.md` says an NPC village "issues quests" and a village can be "won by quest".
- [ ] The open questions of `UPGRADES_VILLAGE.md` (7).
- [ ] The open questions of `UPGRADES_TOWER.md` (4).
- [ ] The open questions of `SPIRITS_GUARDIANS.md` (4).
- [ ] `base_price` and `multiplier` for each purchase type, and whether escalating price counts per tower or per wizard (`FORMULAS.md`).

**Build**
- [ ] Villages in full: income, upgrades, guardians, crops, raids and theft, village shield.
- [ ] Towers and their mana income; the capital.
- [ ] NPC villages: their rune shop and their quests.
- [ ] Trade.
- [ ] Mana-stones and life-stones.

## Milestone 5 — Dungeons and mazes

**Decisions**
- [ ] The open questions of `MAZES.md` (5).
- [ ] The dungeons and mazes in the alpha subset (`DUNGEONS.md`, `MAZES.md`).

**Build**
- [ ] Dungeons: instances for one wizard, the alpha subset.
- [ ] Mazes: the alpha subset.

## Milestone 6 — The Monolith and the end of a run

The Monolith assumes everything else exists, so it comes last.

**Decisions**
- [ ] The card catalogue in the alpha subset, and the starter deck of each wizard type (`CARDS.md`).
- [ ] The lock price (`FORMULAS.md`, `CARDS.md`).
- [ ] The score weights, their conversion to RP, and the winner's bonus (`FORMULAS.md`).
- [ ] The list of achievements (`ACHIEVEMENTS.md`).
- [ ] The tower cap (`UPGRADES_TOWER.md`).

**Build**
- [ ] The queue and the Lobby.
- [ ] Floors, floor bosses and echoes.
- [ ] The final battle on the ROOF, overtime and sudden death.
- [ ] World endings and wizard endings.
- [ ] Score, reincarnation points, talents, achievements.
- [ ] Real decks of cards.
- [ ] Offline play: the offline summary and raid alerts.

## Milestone 7 — The alpha itself

**Decisions**
- [ ] The host for public worlds (`TECH_STACK.md`).
- [ ] **Talking between players**: chat, emotes, or neither. **Undocumented.**
- [ ] **Teaching a new player**: a tutorial, or none. **Undocumented.**
- [ ] The real length of a season for the alpha, against the 48 hours of `GLOSSARY.md`.
- [ ] The number of testers and how their feedback is gathered.

**Build**
- [ ] The final interface: the spell bar of `ART_DIRECTION.md`, menus, and settings with key rebinding.
- [ ] A first pass of art and sound.
- [ ] Hosting, and logs to diagnose problems.
- [ ] The test protocol with the testers.
