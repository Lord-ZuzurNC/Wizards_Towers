# Cards — Wizards Towers

How a wizard grows at each level-up: a choice between cards drawn from a deck the player built before the run.

- [Cards — Wizards Towers](#cards--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [Families](#families)
  - [Rarity](#rarity)
  - [The level-up choice](#the-level-up-choice)
  - [Paying to change a choice](#paying-to-change-a-choice)
  - [The deck](#the-deck)
  - [Unlocking cards](#unlocking-cards)
  - [Open questions](#open-questions)

## How to read this document

A wizard grows in two ways at each level-up.
Their base stats and base mana pool grow on their own, by the formulas in `FORMULAS.md`.
On top of that, they choose a **card**, and the card is where builds differ.

A run is meant to reach about **level 30**, so a wizard makes roughly thirty choices over eight days, about one per hour of play.

The card catalogue itself is not designed yet; this document sets the rules every card follows.

## Families

| Family      | What taking it grants                                                                    |
| ----------- | ---------------------------------------------------------------------------------------- |
| **Stat**    | A bonus to `health`, `power`, `magic_defence`, `speed` or `luck`.                        |
| **Mana**    | A bonus to the mana pool, or to anything around mana: regeneration, a spell's cost.      |
| **Rune**    | A rune, at the rarity the card rolled.                                                   |
| **Weapon**  | A weapon of the wizard type's own kind.                                                  |
| **Special** | Anything no other family covers; each Special card is unique, one copy per deck at most. |

**Two Special cards are already designed.**

- **Keepsake Wisp.** Taking it summons the Keepsake Wisp for the rest of the run: a spirit carrying nothing mechanical, which greets the wizard by the name of their previous life. See `SPIRITS_GUARDIANS.md`.
- **A world boss summon.** It is never offered: when drawn, it is played on the spot, its world boss spawns, it leaves the run deck, and another card is drawn in its place. The wizard learns the boss is coming at the same moment as everyone around.

## Rarity

A card's rarity is rolled when it is drawn into a choice, so the same card can come up stronger one time and ordinary the next.

| Rarity        | Chance | Strength        |
| ------------- | -----: | --------------- |
| **common**    |   85 % | as written      |
| **rare**      |   10 % | 50 % stronger   |
| **legendary** |    5 % | twice as strong |

A Rune card grants its rune at the rolled rarity, which then scales as every rune does in `RUNES.md`.

## The level-up choice

**A level-up grants a choice, kept until the wizard opens it.**
The world never pauses, so a choice never opens on its own in the middle of a fight.
The wizard opens it whenever they feel safe: in the Lobby, inside a dungeon or a maze, anywhere.
Choices not yet opened stack up, and are opened one at a time.

**A choice shows three cards; the wizard takes one.**
The three are drawn from the wizard's run deck.
The card taken leaves the run deck for the rest of the run; the two others go back into it.

**Copies weigh the draw.**
A deck may hold several copies of the same card, and each copy is drawn on its own, so five copies of a card make it five times as likely as a single one.

**When the deck runs low.**
A choice with fewer than three cards left shows what remains.
A wizard whose run deck is empty still levels up, and still gains their base stats, but gets no card.

## Paying to change a choice

Three actions change a choice, each paid with a different resource.

| Action         | Cost                       | Effect                                                                                                                 |
| -------------- | -------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **reroll**     | 1 mana-stone               | The cards on offer go back into the deck and new ones are drawn; a locked card stays.                                  |
| **lock**       | gold, rising with each use | One card on offer is kept for the next choice, which then shows that card and only two new ones.                       |
| **extra pick** | 1 life-stone               | Bought ahead: the **next** choice lets the wizard take two cards instead of one, whatever that choice turns out to be. |

**The extra pick is bought blind.**
It is paid before the next choice is drawn, so the wizard pays without knowing what they will be offered.
At most one extra pick applies to a single choice.

**Reroll competes with the Grimoire.**
A mana-stone spent on a reroll is a Grimoire position not unlocked.
A wizard may well stop at five positions and spend every other mana-stone on rerolls, keeping one for the ROOF; that is a build, not a mistake.

## The deck

**A deck is 50 cards, one per wizard type.**
A player keeps up to four decks in their profile, one for each wizard type, built between runs.
At the start of a run, the deck of the chosen wizard type becomes that wizard's run deck.

**Every player starts with the same deck.**
Each wizard type has one starter deck, identical for every player.
Unlocked cards widen what a deck can hold; they are meant to add variety, not raw power, because players who have played longer must not simply outclass newcomers in PvP.

## Unlocking cards

**Cards are unlocked with reincarnation points, once an achievement allows it.**
Each unlockable card is tied to an achievement accomplished during a run; the achievement makes the card purchasable, and RP buy it.
Achievements are catalogued in `ACHIEVEMENTS.md`.

**Only the Sorcerer is open to everyone.**
The Magus, the Arcanist and the Oracle each need an achievement, then RP, and only then can a player build their deck.
RP also unlock the weapons that may drop during a run; see `GLOSSARY.md`, talent.

## Open questions

- ⬜ **The catalogue: 150 to 200 cards**, enough for three or four truly different decks per wizard type, even if most players' decks will share a large common base.
- ⬜ **The starter deck of each wizard type**, and what share of it each family takes.
- ⬜ **How rarity applies to a Weapon card**, since every weapon already has a fixed rarity in `WEAPONS.md`.
- ⬜ **The world boss summon:** which boss, and where it spawns.
- ⬜ **The lock price**, see `FORMULAS.md`.
- ⬜ **The achievements**, and which card each one allows.
