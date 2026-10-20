# Mazes — Wizards Towers

- [Mazes — Wizards Towers](#mazes--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [1. What a maze is](#1-what-a-maze-is)
  - [2. The authored-versus-generated principle](#2-the-authored-versus-generated-principle)
  - [3. Maze mechanics](#3-maze-mechanics)
  - [4. Assembled mazes](#4-assembled-mazes)
  - [5. Spoiler-proof versus single-use](#5-spoiler-proof-versus-single-use)
  - [6. Notes for balancing](#6-notes-for-balancing)

## How to read this document

This document lists the reusable puzzle primitives a maze can be built from, called **mechanics**, and then assembles a first batch of **mazes** out of them.
A maze is a dungeon, so everything `GLOSSARY.md` says about dungeons applies: instanced, safe from other wizards, and entering one breaks the peace shield.
What makes a maze a maze rather than a combat dungeon is the subject of section 1.
Section 3 is the material to mine: more mechanics than any one game needs, so there is plenty to cut.
Section 4 shows what combining two or three of them looks like, not a final room list.
Nothing below is implemented, and nothing below should be treated as final until the open questions marked `⬜` are answered.

---

## 1. What a maze is

A maze is the **puzzle variant of a dungeon**: solved by thinking instead of fighting.
It is the game's only **non-combat source of XP** — every other source is combat or a quest, and quests only grant a small amount.
That makes a maze the single place a wizard who does not want to fight still advances, which is why it matters more than its small footprint in the feature list suggests.

A maze is instanced and safe from other wizards, exactly like a combat dungeon.
Entering one **breaks a level-1 wizard's peace shield permanently**, the same as entering any dungeon, so a newcomer cannot farm mazes from behind invulnerability.
That is a real cost for a level-1 wizard, and it is meant to be: a maze is a decision, not a freebie.

The designer's own examples, kept here in his own words because they set the tone:
a pattern to get a door open, having the right rune so the wizard needs to find it, walking on an invisible path.
Everything in section 3 is an elaboration of that short list, built to use this game's own systems rather than generic riddles.

### Personally unsolvable versus globally unsolvable

The designer has said that an unsolvable maze **is not an issue, there are other dungeons**.
That is true for one specific kind of unsolvable and false for another, and the distinction is load-bearing for everything that follows.

A maze that is **personally** unsolvable, because a given wizard lacks the rune, the level, or the Element it demands, is good design.
It teaches a wizard that progress has shape, and it costs that wizard nothing they cannot later undo by levelling, trading or finding the rune elsewhere.
`Grimoire Position Lock` in section 3 is a clean example: a level-1 wizard cannot pass a lock demanding three filled Grimoire positions, and that is the point.

A maze that is **globally** unsolvable, because the world itself never generated the rune the maze demands, is dead content.
No amount of playing fixes it, no amount of levelling fixes it, and the maze sits there forever as a room nobody can ever open.
That is not a difficulty choice, it is a generation bug wearing a difficulty choice's clothes.

⬜ **Open question, and the recommendation this document makes about it.**
Whichever mechanic keys a maze to a specific rune, Element or Artifact must be paired with a **world-generation constraint**: the required rune must be guaranteed to exist somewhere in that world, obtainable by some means, before the maze is allowed to generate with that requirement.
Concretely, that means checking the requirement against the world's actual rune and Artifact distribution at generation time, and re-rolling the maze's requirement if the check fails.
This is not yet decided anywhere in the design documents, and it should be, before any rune-keyed mechanic ships.

---

## 2. The authored-versus-generated principle

Authored puzzle content is the most expensive content per minute of play in this project.
An enigma — the generic kind, not this game's `maze` — is authored once and solved once: a player who has seen the answer knows it forever, and tells everyone else.
This is a solo project built by a non-developer, so that arithmetic is not a nitpick, it is close to the whole argument.

The fix is a strict preference: build mazes whose **shape** is authored once but whose **solution** is **generated fresh per world**.
A pattern lock where generation picks the pattern.
A rune-key door where generation picks the rune.
An invisible path where generation picks the route.
The room, the dressing, the fail state and the UI are the expensive authored part, written once.
The actual answer — which tile, which rune, which order — is cheap, computed per world, and worthless to leak because it changes under the next world anyway.

Every mechanic in section 3 states explicitly what is authored and what is generated, and whether the mechanic survives a player telling everyone the answer.
A mechanic that cannot state a generated part honestly is a mechanic this document does not recommend building as a repeatable category — see section 5 for what that means in practice.

---

## 3. Maze mechanics

At least 22 reusable primitives, the pieces assembled mazes in section 4 are built from.
"Authored part" is written once by the designer.
"Generated part" is computed fresh, normally at world creation or at the moment the maze instance is generated.
"Spoiler-proof?" answers whether a player who already knows the answer from a previous solve still has something to do here.

| Mechanic                       | What the player does                                                                                                      | Authored part                                                        | Generated part                                                                 | Spoiler-proof?              | Notes                                                                                                                                                 |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | -------------------------------------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Rune-Key Door**               | Presents a rune they hold to a lock that opens for exactly one rune.                                                       | The door, the room, the permanent-this-visit fail state.              | Which single rune, attribute plus name, the lock accepts.                       | Yes                           | Needs the generation guarantee from section 1, or it risks being globally unsolvable.                                                                  |
| **Attribute Sequence Lock**     | Touches five motifs, one per rune attribute, on a panel in the order the room hints at.                                    | The panel, the five motifs, the hinting method.                       | The correct order of the five attributes, 120 possibilities.                    | Yes                           | Pure logic, owns nothing, so it is always personally solvable.                                                                                          |
| **Cost-Bar Threshold Gate**     | Casts or holds a spell so their own cost bar's fill lands inside a marked band on a gate.                                  | The gate, the visible band, the hold interaction.                     | Where the band sits on the bar.                                                 | Partial                       | Knowing to aim the bar is strategy, not an answer, since the band moves per instance.                                                                   |
| **Effect-Order Plates**        | Pulls two Effect-tagged levers in sequence, since the order changes the outcome.                                           | The two-lever room, the two differing outcomes.                       | Which outcome is correct, so which lever goes first.                            | Yes                           | Teaches the Effect1-then-Effect2 ordering rule without requiring ownership of either Effect rune.                                                       |
| **Element Resonance Gate**     | Casts the one Element the obstacle resonates with to clear it.                                                             | The obstacle, its visual tell.                                        | Which of the twelve Elements it responds to.                                    | Yes                           | Hard for a Grimoire with no matching Element, but common Elements are purchasable, so a fallback is cheap to guarantee.                                 |
| **Invisible Safe-Tile Path**   | Crosses a floor where only some tiles are safe, found from an environmental tell, not a guess.                             | The room, the soft penalty, the tell mechanism.                       | Which tiles are safe.                                                           | Yes                           | The designer's own named example. Keep the penalty a reset, never damage.                                                                               |
| **Light/Shadow Corridor**      | Casts Gloom or Radiance to flip a corridor's state, since the path is only walkable in one state per segment.              | The corridor, the two states, the toggle object.                      | Which segments need light and which need shadow.                                | Yes                           | Needs a decided fallback for a wizard holding neither element; see section 6.                                                                           |
| **Mana Budget Gauntlet**       | Crosses a chain of doors, each consuming a fixed fraction of the current mana pool, without running dry mid-chain.          | The chain, the soft stuck-until-regen fail.                           | Door count and the fraction each demands.                                       | Partial                       | Soft-fails on purpose, since mana-stones are too precious to be the fix for a bad plan.                                                                 |
| **Echo Mirror Chamber**        | Changes something about their own loadout so an inert mirror of themself crosses a stat threshold the room checks.         | The chamber, the threshold check, the fact the mirror never attacks.  | Which stat and which threshold.                                                 | Yes                           | The threshold reads the player's live stat block, so it cannot be memorised from someone else's solve.                                                 |
| **Weight-Matching Scale**      | Places rune tokens on a balance until both sides match a target, using each rune's real weight.                           | The scale, the room, the offered token set.                           | The target weight and the matching subset.                                      | Yes                           | A quiet lesson in rune weight for a player who has not reached spellcrafting depth.                                                                     |
| **Gold Toll Pedestals**        | Deposits exact gold amounts on pedestals in order, refunded on a wrong guess.                                              | The pedestals, the refund-on-fail rule.                               | The amounts and the order.                                                      | Partial                       | Cap the amounts low, or a wealthy wizard simply buys through what should be a puzzle.                                                                   |
| **Haste Timing Gate**          | Times a dash through a closing gate, using a self-cast Haste effect or a tightly judged approach at base speed.            | The gate's closing rhythm, the two valid approaches.                  | The rhythm's period and offset.                                                 | Yes                           | Keep the non-Haste path real, or a wizard with no Haste rune is personally locked out of a pure timing test.                                            |
| **Season Dial Room**           | Sets a dial to the current season's icon, then performs a further generated action.                                       | The dial, the four icons, the further-action slot.                    | The further action only.                                                        | No, for the dial alone        | Four seasons is a small, public, shared fact. Never ship this as the only step; see section 6.                                                          |
| **Reprise Delay Switch**       | Throws a switch that fires once immediately and again, weaker, after a delay, and must use both pulses.                   | The switch, the two-pulse behaviour, the gate it feeds.                | The delay length and the gate's re-close speed.                                 | Yes                           | Named for the Effect rune Reprise, its idea reused as level geometry rather than spellcraft.                                                            |
| **Tether Anchor Walk**         | Stays within a tether's range of a moving anchor while crossing a hazard, resetting the room if it snaps.                  | The hazard, the anchor's path shape, the snap-and-reset rule.          | The anchor's speed and the tether's maximum range.                              | Yes                           | A soft-fail room, consistent with testing thought rather than survival.                                                                                 |
| **Symbol Pattern Lock**        | Reproduces a symbol pattern shown once elsewhere in the maze onto a door lock.                                             | The lock, the display mechanism.                                      | The pattern itself.                                                              | Yes                           | The designer's own named example. Keep it to four or six symbols, testing memory, not tedium.                                                           |
| **Rune Memory Match**          | Flips tile pairs bearing rune icons from the same attribute family until every pair is matched.                            | The grid, the same-attribute matching rule.                           | The tile layout.                                                                 | Yes                           | Owns nothing, recognises only, so it is safe content for a level-1 wizard.                                                                              |
| **Mad-Libs Rune Riddle**       | Reads a templated riddle whose blank names a generated rune, and acts on the answer.                                       | The riddle template, the delivery mechanism.                          | Which rune fills the blank.                                                      | Partial                       | Write the template generic enough to scan naturally for any of the current 77 runes.                                                                    |
| **Mana-Stone Toll Choice**     | Chooses between spending a mana-stone for an instant shortcut or solving a harder free puzzle.                             | The choice, the harder puzzle's shape.                                | The harder puzzle's specific solution.                                          | Yes, for the puzzle option    | Spend this rarely. Mazes should not quietly expect the one resource a low-combat wizard needs most.                                                     |
| **Decay Clock Room**           | Solves a puzzle while lingering weakens their stats on a compounding curve, fully reset on leaving.                        | The room, the weakening curve, the full reset on exit.                | The inner puzzle and its time budget.                                           | Yes, for the inner puzzle     | Deliberately distinct from Artifact corruption, and never cured by a life-stone, to avoid colliding with that term.                                     |
| **North Wall Cipher**          | Reads a snapshot of the North Wall taken on entry and uses the order shown as a cipher key.                               | The cipher mechanism, the snapshot-on-entry rule.                     | Nothing authored at all — the world's own live state is the puzzle.             | Yes, uniquely so              | Must snapshot on entry, or the puzzle shifts under the player as floors change hands outside.                                                           |
| **Grimoire Position Lock**     | Presents proof of a given number of filled Grimoire positions, a function of wizard level, to a checking lock.            | The lock, the check.                                                   | The exact number demanded, sane for the maze's intended level.                  | Yes                           | A clean example of a personal gate: a level-1 wizard with one position cannot pass a lock demanding three, and that is intended.                       |
| **Chain Lever Cascade**        | Pulls the one lever whose cascade, falling in strength like the Chain effect, reaches every target.                       | The lever field, the falling-strength cascade rule.                   | The field's layout and the one valid starting lever.                            | Yes                           | A level puzzle that is literally the Chain rune's own rule turned into geometry.                                                                        |
| **Nova Pulse Relay**           | Stands on relay plates to position an expanding ring so it reaches every beacon before it fades.                          | The plates, the beacons, the fade timer.                              | Beacon placement.                                                               | Yes                           | Speed matters here, so a slowed wizard is disadvantaged without being locked out. Keep it as texture, not a hard gate.                                  |
| **Vortex Platform Pull**       | Casts a Vortex-shaped spell, if they hold one, to drag floating platforms into a crossable line.                          | The platforms, the gap.                                               | The target arrangement.                                                         | Yes                           | Vortex is rare and heavy. Gating a whole maze behind owning it is a hard personal lock; see section 6.                                                  |
| **Luck Ledger Deduction**      | Examines a ledger of past, fictional outcomes and deduces which option is weighted favourably.                            | The ledger format, the deduction rule.                                | The numbers in the ledger and which option they point to.                       | Yes                           | Named for luck but rolls nothing in front of the player. A reading puzzle about luck, not a luck check.                                                 |

That is 26 mechanics, four more than the floor the brief asks for, deliberately — this is the list to cut down from, not the final roster.

---

## 4. Assembled mazes

Twelve mazes, each combining two or three mechanics from section 3.
Difficulty is a convenience scale invented for this document — Low, Medium, High, Very high — not a tier defined anywhere in `CONTENT CONTRACT.md`.
Rewards are described qualitatively, not in numbers, because the XP curve behind `wizard_level` is itself an open design question (glossary item 32.5).
No maze rewards an Artifact: Artifacts are bound to Monolith floors, never to a dungeon, and that stays true for a maze too.

### 4.1 The Locksmith's Gallery

*Mechanics: Symbol Pattern Lock + Rune-Key Door.*

The gentlest maze in the roster, meant as the first one a new wizard meets, and an honest one about the cost of entering: breaking a level-1 peace shield for this is a fair trade.

- **Stage 1 — the gallery.** Three identical doors and one tapestry showing a short symbol pattern once. Only the door whose lock, once the pattern is reproduced, clicks open is real; the other two are permanently sealed, a dead end rather than a trap.
- **Stage 2 — the vault.** A Rune-Key Door asking for one common-rarity rune. A wizard who does not hold it yet can leave and come back; the lock never times out.

**Difficulty:** Low.
**Reward:** small XP, and a common rune different from the one the lock demanded, so the maze is a net gain even for a wizard who had to go shopping first.

### 4.2 The Resonance Vault

*Mechanics: Element Resonance Gate + Weight-Matching Scale.*

A maze built around the idea that magic has texture: fire undoes ice, cold undoes fire, and weight is a real, checkable number rather than flavour text.

- **Stage 1 — the molten corridor.** A wall of ice blocks the only path forward. Casting the generated matching Element — commonly Ember, but the generation can pick any of the twelve — clears it.
- **Stage 2 — the vault chamber.** A scale and a tray of rune tokens. The wizard loads tokens until the scale balances against a hidden target weight, opening the chest behind it.

**Difficulty:** Medium.
**Reward:** medium XP, one rare rune.

### 4.3 The Mirror Gallery

*Mechanics: Grimoire Position Lock + Echo Mirror Chamber.*

A maze that is honest about being personally gated, and says so to the player rather than hiding it: a notice at the entrance states the Grimoire requirement before the peace shield breaks.

- **Stage 1 — the threshold.** A lock checking the wizard currently has at least three filled Grimoire positions, meaning wizard level 3 or higher. Below that, the maze politely refuses entry and the peace shield is untouched.
- **Stage 2 — the mirror chamber.** An inert mirror echo of the wizard's current loadout stands opposite a sealed exit. Swapping a weapon or a Grimoire spell changes the mirror's resulting stat, and the exit opens once a generated stat threshold is crossed.

**Difficulty:** Medium-high.
**Reward:** medium-large XP, a small amount of RP, consistent with the glossary's statement that dungeons grant RP.

### 4.4 The Umbral Processional

*Mechanics: Light/Shadow Corridor + Invisible Safe-Tile Path.*

The most atmospheric maze in the batch, built entirely around Gloom and Radiance as light and shadow rather than as damage types.

- **Stage 1 — the lit nave.** An introduction room explaining, through environment only, that shadow hides a path and light burns it away.
- **Stage 2 — the corridor.** A sequence of segments, each walkable only in one generated state, light or shadow, crossed by alternating Gloom and Radiance casts.
- **Stage 3 — the invisible floor.** A final room where the safe tiles are visible only in whichever state the corridor ended on, combining both mechanics into one read.

**Difficulty:** Medium.
**Reward:** medium XP, a rune from the Element attribute.

### 4.5 The Auditor's Hall

*Mechanics: Gold Toll Pedestals + Mana Budget Gauntlet.*

A maze about resource planning rather than combat skill, which makes it the clearest non-combat XP source in the roster — nothing here can be solved by being strong.

- **Stage 1 — the counting room.** A row of pedestals demanding exact gold amounts, in a generated order, refunding on a wrong guess so a careful wizard loses nothing but time.
- **Stage 2 — the gauntlet.** A chain of mana-gated doors. Running dry only stalls the wizard until mana regenerates; it never fails the maze outright.

**Difficulty:** Low-medium.
**Reward:** small-medium XP, a modest amount of gold back, since the maze's theme is managing a budget, not draining one.

### 4.6 The Seasonal Clockwork

*Mechanics: Season Dial Room + Chain Lever Cascade.*

Built to prove that `Season Dial Room` cannot carry a maze alone — see section 6 — by pairing it with a mechanic that supplies the real generated difficulty.

- **Stage 1 — the dial.** A dial set to the run's current season. Shared public knowledge, solved in seconds by anyone who has been playing the run at all.
- **Stage 2 — the clockwork.** A field of levers where pulling the wrong one cascades, Chain-like, into a mess that must be reset. The one correct starting lever is generated per instance.

**Difficulty:** Medium.
**Reward:** medium XP, one rune from a generated attribute.

### 4.7 The Tethered Ascent

*Mechanics: Tether Anchor Walk + Haste Timing Gate.*

A platforming-leaning maze, the closest thing in this roster to testing reflexes rather than deduction, included because the brief's own list of mechanics should not be purely cerebral.

- **Stage 1 — the chasm.** A moving anchor and a tether; straying too far snaps it and resets the room, never damages.
- **Stage 2 — the final gate.** A closing gate crossed either with a self-cast Haste effect or with careful timing at base speed.

**Difficulty:** Medium-high.
**Reward:** medium XP, a Duration-attribute rune, thematically tied to the timing involved.

### 4.8 The Archivist's Riddle Room

*Mechanics: Mad-Libs Rune Riddle + Rune Memory Match.*

The teaching maze: everything here is about recognising rune attributes, and nothing here requires owning a single rune, making it accessible the moment a wizard chooses to risk the peace shield.

- **Stage 1 — the archive.** A riddle whose blank is a generated rune name, spoken to an NPC to open the inner door.
- **Stage 2 — the memory grid.** A tile-matching game pairing runes by attribute family rather than by exact rune.

**Difficulty:** Low.
**Reward:** small XP, reliably a common rune of the matched attribute.

### 4.9 The Fading Reliquary

*Mechanics: Decay Clock Room + Mana-Stone Toll Choice.*

A late-run, higher-stakes maze, and the one place in this document where the brief's "most expensive content" warning applies hardest — this is the one to prototype most carefully before building more like it.

- **Stage 1 — the reliquary.** A room that weakens the wizard's stats on a compounding curve for as long as they linger, resetting fully the moment they step out. A generated logic puzzle must be solved inside before the curve bites too deep.
- **Stage 2 — the choice.** An exit offering a mana-stone shortcut or a second, harder generated puzzle for free.

**Difficulty:** High.
**Reward:** large XP, a rare rune, and RP consistent with its difficulty.

### 4.10 The North Wall Archive

*Mechanics: North Wall Cipher + Effect-Order Plates.*

The maze that most depends on a decision outside this document: entering must snapshot the North Wall at that instant, or the puzzle inside shifts as floors change hands outside.

- **Stage 1 — the archive hall.** A snapshot of the North Wall, taken at entry, gives an ordering of names or floor numbers used as a cipher key for the next door.
- **Stage 2 — the vault.** Two Effect-tagged levers whose correct order is partly determined by the cipher just solved.

**Difficulty:** Medium-high, and genuinely variable: a quiet early run with few floors claimed produces a short, easy cipher, a contested late run a long one.
**Reward:** medium-large XP, a rare rune.

### 4.11 The Vortex Garden

*Mechanics: Vortex Platform Pull + Nova Pulse Relay.*

Built around two of the heaviest, rarest Shape runes in the game, and flagged here exactly because that rarity is a real design risk — see section 6.

- **Stage 1 — the garden.** Floating platforms, crossable only once dragged into line by a Vortex-shaped spell.
- **Stage 2 — the relay.** Beacon plates lit by an expanding Nova ring, positioned so the ring reaches every beacon before it fades.

**Difficulty:** High.
**Reward:** large XP, a rare Shape-attribute rune.

### 4.12 The Prism of Luck

*Mechanics: Luck Ledger Deduction + Cost-Bar Threshold Gate.*

A deduction-heavy maze pitched as a late-run finale: nothing here is a luck roll, despite the name, and that contrast is the point.

- **Stage 1 — the ledger hall.** A ledger of fictional past outcomes; deducing the favoured option opens the inner door.
- **Stage 2 — the prism gate.** A gate reading the wizard's live cost bar, open only while a cast holds the bar's fill inside a marked, generated band.

**Difficulty:** High.
**Reward:** large XP, a rare rune, RP.

### 4.13 The Archmage's Final Lock

*Mechanics: Attribute Sequence Lock + Reprise Delay Switch + Effect-Order Plates.*

The capstone of this batch, the only maze in the roster using three mechanics rather than two, pitched as rare, memorable, and expensive to author exactly once, which is why the roster has only one of these.

- **Stage 1 — the five motifs.** An Attribute Sequence Lock, generated order, opening onto the switch hall.
- **Stage 2 — the switch hall.** A Reprise Delay Switch whose second, weaker pulse must be caught before the gate it feeds re-closes.
- **Stage 3 — the final vault.** Effect-Order Plates, generated outcome, guarding the exit chest.

**Difficulty:** Very high.
**Reward:** very large XP, a rare or legendary-rarity rune, meaningful RP.
Never an Artifact, consistent with Artifacts being floor-bound only.

---

## 5. Spoiler-proof versus single-use

**Strongly spoiler-proof, because the generated part is the whole answer:**
Rune-Key Door, Attribute Sequence Lock, Effect-Order Plates, Element Resonance Gate, Invisible Safe-Tile Path, Light/Shadow Corridor, Echo Mirror Chamber, Weight-Matching Scale, Haste Timing Gate, Reprise Delay Switch, Tether Anchor Walk, Symbol Pattern Lock, Rune Memory Match, Mana-Stone Toll Choice, Decay Clock Room, North Wall Cipher, Grimoire Position Lock, Chain Lever Cascade, Nova Pulse Relay, Vortex Platform Pull, Luck Ledger Deduction.
That is 21 of the 26, and it is the category this document recommends building almost exclusively from.

**Partially spoiler-proof, because a transferable strategy leaks even though the exact answer still regenerates:**
Cost-Bar Threshold Gate, Mana Budget Gauntlet, Gold Toll Pedestals, Mad-Libs Rune Riddle.
These are still worth building — a returning player solving faster is normal game feel, not a problem — but they should not be the hardest gate in a maze, because the ceiling on how hard they can be made is lower once the trick is known.

**Not spoiler-proof on its own:**
Season Dial Room.
Four seasons is a small, shared, public fact, and setting a dial to the current one is solved by any player within minutes of first seeing it, then told to everyone else in the run.
It is still listed in section 3 because it is a good **texture** mechanic — a free, thematic first step — but it must never be the only step in a maze that uses it, which is why `4.6 The Seasonal Clockwork` pairs it with a mechanic that supplies the actual generated difficulty.

**Blunt recommendation on single-use content.**
None of the 26 mechanics above is proposed as genuinely single-use — every one keeps a generated part that regenerates per world, by design, because that is this document's whole thesis.
If the designer still wants a hand-authored, never-regenerated riddle as a one-time showpiece — a launch easter egg, a lore moment with a fixed, memorable answer — that is a legitimate thing to want, but it should be budgeted honestly: build **at most one** across the entire project, and treat it as marketing or lore content, not as a maze category.
A solo, non-developer project cannot afford a second one.
Every hour spent on a puzzle that dies the moment one player posts the answer is an hour not spent on a mechanic from section 3 that keeps earning its cost for the life of the game.

---

## 6. Notes for balancing

**The generation-guarantee question is the most important open item in this whole document, and it is unresolved.**
⬜ Section 1 recommends that any rune-, Element- or Artifact-keyed mechanic — `Rune-Key Door`, `Element Resonance Gate`, `Vortex Platform Pull` most directly — must check against the world's actual generated rune and Artifact distribution before it is allowed to spawn with that requirement.
Nobody has decided whether this check happens, or how.
Shipping any of those three mechanics before this is decided risks exactly the dead-content failure the designer flagged.

**`Light/Shadow Corridor` has no decided fallback for a wizard holding neither Gloom nor Radiance.**
⬜ Either guarantee one of the two is cheaply obtainable everywhere, the way `Element Resonance Gate`'s notes argue for common Elements generally, or give the corridor a manual torch-and-crystal interaction that does not require owning either rune.
Undecided, and it blocks `4.4 The Umbral Processional` from being built as described.

**`Vortex Platform Pull` is the single mechanic in section 3 most likely to be a design mistake as written.**
Vortex is weight 5, one of the two heaviest Shape runes in the game, and gating an entire maze's core movement behind owning it is a harsher personal lock than this document is otherwise comfortable with.
⬜ Recommend deciding whether `4.11 The Vortex Garden` needs a non-Vortex alternate route before it is built, not after.

**`Season Dial Room` is underpowered as a standalone mechanic, and that is stated plainly in section 5, not softened.**
It is fine as a texture step paired with something generated, as in `4.6`.
It is a mistake if a future designer builds a maze that uses it as the only gate.

**`Gold Toll Pedestals` favours a wealthy wizard over a clever one, which cuts against the whole point of a non-combat puzzle source.**
Recommend capping the toll amounts low enough that a mid-run wizard's typical gold holdings cannot simply be thrown at the puzzle instead of solving it.

**`Echo Mirror Chamber`'s name risks colliding with the real echo system, the floor defender snapshot, even though the mechanic never fights and never persists.**
⬜ Worth a rename pass before this reaches a glossary entry, the way four other names were already renamed in `RUNES.md` to avoid exactly this kind of collision.

**Whether a maze grants RP at all is inherited from an open glossary item, not decided here.**
`GLOSSARY.md` lists dungeons as an RP source alongside wizard kills, world bosses and floors, and this document has assumed that a maze, being a dungeon, inherits that.
⬜ That inheritance has not been confirmed anywhere, and the `dungeon` entry itself is still open.

**No reward number in section 4 is a real number.**
They are relative — small, medium, large — because the XP curve behind `wizard_level` is explicitly open, glossary item 32.5, and inventing numbers here would be answering a design question this document is not allowed to answer.

**On the quality bar the brief set:**
honestly, the mechanics that lean hardest on this game's own systems — `Weight-Matching Scale`, `Chain Lever Cascade`, `North Wall Cipher`, `Grimoire Position Lock`, `Decay Clock Room` — are also the ones with no equivalent in a generic puzzle game, and they are the strongest entries in section 3 for exactly that reason.
`Symbol Pattern Lock` and `Invisible Safe-Tile Path` are the designer's own named examples and belong in the document regardless, but on their own they would work in almost any game; they earn their place here by being cheap, reliable building blocks to combine with the more game-specific mechanics, not by being distinctive on their own.
That is an honest trade-off, not a flaw: a maze made entirely of bespoke mechanics would be slower and more expensive to build than this solo project can sustain.
