# Runes — Wizards Towers

A rune is the atomic ingredient of a spell.
Each rune belongs to exactly one **attribute**, and an attribute is a position inside a spell.

There are **four attributes** and **five spell slots**, because the Effect attribute occupies two of them.

| Slot | Attribute | Mandatory | Opens at |
| ---- | --------- | --------- | -------- |
| 1    | Shape     | yes       | level 1  |
| 2    | Element   | yes       | level 1  |
| 3    | Duration  | yes       | level 1  |
| 4    | Effect1   | no        | level 2  |
| 5    | Effect2   | no        | level 2  |

A spell is castable once the three mandatory slots hold a rune.
The two Effect slots are optional and **ordered**: `Chain → Split` is not the same spell as `Split → Chain`.

**The two Effect slots must hold different runes.**
`Chain → Chain` is not a legal spell.

**A spell may contain at most one Artifact.**
Artifacts are the floor-bound runes catalogued in `ARTIFACTS.md`, and no spell may stack two of them.

## Reach

Reach is **not chosen**.
It is a property of the Shape rune the player already picked, printed so the player can see it.

| Reach      | Meaning                                                           |
| ---------- | ----------------------------------------------------------------- |
| **self**   | Resolves on or around the wizard, and travels with them.          |
| **melee**  | Resolves immediately in front of the wizard, within arm's length. |
| **ranged** | Travels away from the wizard toward a target or a direction.      |
| **placed** | Resolves at a point the wizard designates, at a distance.         |

## How to read this document

**Nothing here has a mana cost, and that is deliberate.**
A spell's cost is computed from what the assembled runes produce, never authored rune by rune.
What each rune carries instead is a **weight**, and the weights are what the cost computation reads.

Three rules govern every table below.

**Rarity scales, it never changes.**
An Ember at legendary rarity does exactly what one at common rarity does, harder.
One rune, one behaviour, three magnitudes.

| Rarity        | Multiplier | Weight multiplier |
| ------------- | ---------- | ----------------- |
| **common**    | ×1.0       | ×1.0              |
| **rare**      | ×1.6       | ×1.4              |
| **legendary** | ×2.5       | ×2.0              |

A rune at legendary rarity is stronger than one at common, but it also weighs more, so it pushes the spell's weight bar further.
A wizard cannot simply fill five slots with legendaries and expect to cast the result.

**Weight is the cost pressure, not the power.**
A rune with weight 3 and a rune with weight 3 cost the same to include even if one is far more useful in a given build.
That is the lever that makes a cheap spell worth building.

**Every value in the tables is the common-rarity value.**
Multiply by the table above for rare and legendary.

---

## Shape

Shape decides the geometry of the spell: what the magic *is* when it leaves the wizard.

It is the slot with the strongest influence on how a spell feels to use, and the one players will recognise first.
It is also the slot that now determines Reach, since Range no longer exists.

| Rune            | Reach  | What it does                                                                                                          | Weight | Notes                                                                                                                                                                                             |
| --------------- | ------ | --------------------------------------------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Bolt**        | ranged | A single fast projectile that strikes the first thing it touches.                                                     | 1      | The cheapest shape. The default of every new wizard.                                                                                                                                              |
| **Lance**       | ranged | A slower, heavier projectile that pierces the first target and continues.                                             | 2      | Rewards lining enemies up.                                                                                                                                                                        |
| **Spray**       | melee  | A wide cone of short-lived fragments in front of the caster.                                                          | 2      | Damage falls off sharply with distance.                                                                                                                                                           |
| **Slash**       | melee  | A short forward arc with heavy penetration, striking everything in the arc at once.                                   | 2      | Melee Reach forces the wizard into danger, and that is the price of its penetration.                                                                                                              |
| **Beam**        | ranged | A continuous line that persists while held, striking everything along it.                                             | 3      | Consumes mana per tick rather than per cast.                                                                                                                                                      |
| **Nova**        | self   | A ring expanding outward from the caster, striking everything it passes.                                              | 3      | Cannot be aimed. Hits enemies and rival wizards without discrimination.                                                                                                                           |
| **Orb**         | ranged | A slow floating sphere that drifts forward and detonates on contact or expiry.                                        | 3      | The only shape that can be outrun.                                                                                                                                                                |
| **Seed**        | placed | A dormant mark on the ground that triggers when anything steps on it.                                                 | 3      | Survives logout. The village-defence shape.                                                                                                                                                       |
| **Footprints**  | self   | A trail of the spell laid down behind the wizard as they walk, following their path.                                  | 3      | Harms the caster if they double back onto it. The only shape drawn by movement, not by aim. Under `Eternal`, the far end goes dormant beyond the owner's range while the near stretch stays live. |
| **Boulder**     | ranged | A large sphere that rolls straight ahead, shrinking as it travels.                                                    | 3      | Stops dead against a building. Strongest at point-blank, spent by the end of its roll.                                                                                                            |
| **Trident**     | ranged | Three simultaneous linear strikes: one forward, one at forty-five degrees each side.                                  | 3      | Very fast. Covers an escape angle without demanding precise aim.                                                                                                                                  |
| **Pool**        | placed | A patch of ground that holds the spell for a time, striking whatever stands in it.                                    | 3      | The cheapest placed shape. Wants `Lingering`, and is close to pointless with `Instant`.                                                                                                           |
| **Rain**        | placed | A column of falling strikes over a target area.                                                                       | 4      | Needs a flat target. Useless against a single moving enemy.                                                                                                                                       |
| **Wall**        | placed | A standing barrier of the chosen element, blocking movement and damaging on contact.                                  | 4      | Defensive, and the best shape for holding a village gate.                                                                                                                                         |
| **Aura**        | self   | A radius centred on the caster that persists and affects everything inside it.                                        | 4      | Moves with the wizard, which its Reach now states rather than making the player pay for it.                                                                                                       |
| **Tether**      | ranged | A line binding the caster to one target, applying the spell to both ends.                                             | 4      | Breaks at a distance. The only shape that damages its owner by design.                                                                                                                            |
| **Satellite**   | self   | Three orbiting bodies circling the wizard, each detonating on contact with an enemy.                                  | 4      | The caster is immune to their own satellites. The only shape that fights while the wizard runs.                                                                                                   |
| **Swarm**       | ranged | Several small homing fragments that each seek a different target.                                                     | 5      | Splits its power across however many targets exist.                                                                                                                                               |
| **Vortex**      | placed | A pulling field that drags enemies toward its centre while it lasts.                                                  | 5      | Deals little damage alone. Devastating with a second Effect.                                                                                                                                      |
| **Judgement**   | placed | A single immense stationary strike on one point, after a visible delay.                                               | 6      | The heaviest single-target shape. Telegraphed and avoidable.                                                                                                                                      |
| **Bombardment** | placed | A wide area bombarded by falling masses, each exploding where it lands. It is slow, explosive and have very few hits. | 6      | By far the best shape against buildings. The siege shape, and the reason a village needs walls.                                                                                                   |

**Reach distribution:** 4 self, 2 melee, 8 ranged, 7 placed.

## Element

Element gives the spell its nature.
It decides what the damage *is*, and therefore what resists it.

| Rune         | What it does                                                                       | Weight | Notes                                                                                       |
| ------------ | ---------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------- |
| **Ember**    | Fire damage, and a short burn afterwards.                                          | 2      | The reliable one. Burns through village crops.                                              |
| **Rime**     | Cold damage, and a brief slow.                                                     | 2      | The best element for escaping a stronger wizard.                                            |
| **Spark**    | Lightning damage, instant, with a chance to strike twice.                          | 2      | The only element with built-in randomness, scaled by luck.                                  |
| **Gale**     | Wind damage, light, pushing what it hits.                                          | 2      | Low damage, high control. Can shove an enemy off a floor.                                   |
| **Stone**    | Blunt damage, slow to land, ignoring a portion of magic defence.                   | 3      | The answer to a high-defence echo.                                                          |
| **Verdure**  | Living damage that spreads to what stands nearby.                                  | 3      | Spreads through crops and through packed enemies.                                           |
| **Brine**    | Corrosive damage that reduces the target's magic defence while it lasts.           | 3      | Opens a target for a second, heavier spell.                                                 |
| **Gloom**    | Shadow damage that is stronger against a target that cannot see the caster.        | 3      | Rewards ambush. Weak in the open.                                                           |
| **Toxin**    | Poison damage over time that also lowers the target's `power` while it lasts.      | 3      | Low immediate damage, almost pure debuff. The only element that weakens what it hits.       |
| **Radiance** | Light damage, stronger against the undead and against echoes.                      | 4      | The anti-echo element. A floor raider's choice.                                             |
| **Ichor**    | Blood damage that costs the caster health and returns it on a hit.                 | 4      | The only element that can kill its own caster.                                              |
| **Null**     | Pure force with no elemental nature, which nothing resists and nothing is weak to. | 5      | Expensive, predictable, and never the wrong answer.                                         |
| **Unmaking** | Void damage that also removes a buff or a lingering effect from the target.        | 5      | The only element that interacts with other wizards' spells.                                 |
| **Rust**     | Metal damage that ignores magic defence entirely.                                  | 5      | The longest cooldown of any element. Where Stone ignores a portion, this ignores all of it. |

## Duration

Duration decides how the spell exists in time.

It is the attribute players understand last and exploit hardest, because it changes cooldown as well as persistence.

| Rune          | What it does                                                                                                       | Weight | Notes                                                                                |
| ------------- | ------------------------------------------------------------------------------------------------------------------ | ------ | ------------------------------------------------------------------------------------ |
| **Instant**   | The spell resolves once, immediately, and is gone.                                                                 | 1      | The default. Shortest cooldown.                                                      |
| **Brief**     | The spell persists for about two seconds.                                                                          | 2      | Enough for a Beam or an Aura to matter.                                              |
| **Delayed**   | The spell resolves after a visible pause, then fires.                                                              | 2      | Cheap, telegraphed, and brutal when it connects.                                     |
| **Sustained** | The spell persists while the wizard holds the cast and pays mana per tick.                                         | 3      | Converts a spell from a cost into a drain.                                           |
| **Lingering** | The spell leaves its effect behind for several seconds after resolving.                                            | 3      | What makes a Wall or a Seed worth building, and now the backbone of offline defence. |
| **Echoing**   | The spell resolves a second time, weaker, a moment later.                                                          | 4      | Two hits from one cast and one cooldown.                                             |
| **Eternal**   | The spell persists indefinitely, but **only acts while the wizard is near it**; beyond that range it lies dormant. | 5      | Deliberately not an offline defence. Only one Eternal spell can be active at a time. |

**`Patient` was removed.**
It armed a spell until a condition was met, which is precisely what the **Seed** Shape already does, so it charged the player for a behaviour they had usually already bought.
Offline persistence now belongs to `Lingering` and to `Seed`, and `Eternal` has been explicitly barred from that role.

## Effect

Effect is where a spell stops being a shaped element and becomes an idea.

Two Effect slots exist, they are optional, they must hold **different** runes, and **their order changes the result**.
As a rule of thumb: the first Effect modifies the spell, and the second Effect modifies the first.

| Rune          | What it does                                                                                   | Weight | Notes                                                              |
| ------------- | ---------------------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------ |
| **Pierce**    | The spell passes through its first target and continues.                                       | 2      | Redundant on a Lance. Transformative on a Bolt.                    |
| **Knockback** | The spell shoves what it hits away from the caster.                                            | 2      | Can push an enemy off a floor or out of a village.                 |
| **Pull**      | The spell drags what it hits toward the caster.                                                | 2      | Sets up a melee Shape or a second Nova.                            |
| **Slow**      | The spell reduces the target's speed while it lasts.                                           | 2      | Stacks with Rime rather than replacing it.                         |
| **Anchor**    | The spell's position is fixed in the world and does not move with its target.                  | 2      | Converts an Aura into a zone. Converts a Tether into a trap.       |
| **Humility**  | The spell deals more damage the fewer villages the caster owns.                                | 2      | The comeback rune. Strongest in the hands of someone losing.       |
| **Covet**     | The spell damages structures far more than it damages wizards.                                 | 2      | The village-razing rune. Nearly harmless in a duel.                |
| **Reverence** | The spell cannot harm a village, a tower or a crop, and hits wizards harder for the restraint. | 2      | The duellist's rune, and a declaration of intent.                  |
| **Chain**     | The spell jumps from its target to a nearby one, weaker each jump.                             | 3      | The classic. Scales with how packed the enemies are.               |
| **Split**     | The spell divides into two smaller copies on resolving.                                        | 3      | After Chain it jumps then splits. Before it, it splits then jumps. |
| **Bounce**    | The spell reflects off walls and floor edges instead of expiring.                              | 3      | Lethal in a Monolith corridor, useless in the open field.          |
| **Seek**      | The spell curves toward the nearest valid target.                                              | 3      | Removes the need to aim. Removes the reward for aiming.            |
| **Root**      | The spell holds what it hits in place briefly.                                                 | 3      | The strongest control effect in the game and priced accordingly.   |
| **Blind**     | The spell removes the target's ability to see the caster.                                      | 3      | Turns Gloom from situational into a build.                         |
| **Mend**      | The spell restores health instead of removing it.                                              | 3      | Inverts the whole spell. Wants a self or melee Shape.              |
| **Ward**      | The spell grants a shield absorbing a fixed amount of damage.                                  | 3      | The only Effect that works while the caster is doing nothing.      |
| **Haste**     | The spell increases the target's speed while it lasts.                                         | 3      | On an Aura, the best escape in the game.                           |
| **Mark**      | The spell tags the target, and the wizard's next spell against them is stronger.               | 3      | Rewards planning two casts ahead.                                  |
| **Waning**    | The spell becomes weaker the longer it persists, but starts far stronger.                      | 3      | The front-loaded option. Good with Instant, absurd with Brief.     |
| **Sacrifice** | The spell costs health in addition to mana, and hits far harder for it.                        | 3      | Cheap on the weight bar, expensive on the wizard.                  |
| **Greed**     | The spell deals more damage the more gold the caster is carrying.                              | 3      | Makes a rich wizard a target worth killing.                        |
| **Patience**  | The spell deals more damage the longer it has been since the wizard last cast anything.        | 3      | Punishes spam. Rewards the single prepared strike.                 |
| **Spite**     | The spell resolves once more, free, if it kills the caster.                                    | 3      | The last word. Can take a rival down with you.                     |
| **Mute**      | The spell prevents the target from casting for a moment.                                       | 4      | The only answer to a wizard with a Sustained Beam.                 |
| **Drain**     | The spell returns a portion of damage dealt to the caster as mana.                             | 4      | Lets an expensive spell pay for its own next cast.                 |
| **Leech**     | The spell returns a portion of damage dealt to the caster as health.                           | 4      | The reason a wizard can survive a dungeon alone.                   |
| **Detonate**  | The spell consumes every lingering effect on the target for a burst of damage.                 | 4      | The payoff rune. Worthless without a setup.                        |
| **Fracture**  | The spell reduces the target's magic defence permanently for the rest of the fight.            | 4      | Makes a long fight winnable. Does nothing in a short one.          |
| **Reprise**   | The spell leaves a faint copy that repeats it once at reduced power.                           | 4      | Distinct from the Duration rune **Echoing**, and they stack.       |
| **Growth**    | The spell becomes stronger the longer it persists.                                             | 4      | Needs Sustained or Eternal to do anything at all.                  |
| **Toll**      | The spell deals more damage the more floors the target holds.                                  | 4      | Built to kill the leader. Useless against a newcomer.              |
| **Kindle**    | The spell's cooldown shortens each time it kills something.                                    | 4      | Turns a clear into a chain of clears.                              |
| **Unbinding** | The spell removes one of the target's own lingering effects before resolving.                  | 4      | The answer to a Ward, a Haste or a Growth.                         |
| **Siphon**    | The spell steals a lingering buff from the target and gives it to the caster.                  | 5      | The only rune that can take another wizard's Ward.                 |
| **Hunger**    | The spell grows stronger for every enemy it has already hit this cast.                         | 5      | Absurd on Chain or Swarm. Pointless on a Bolt.                     |

---

## Rune counts

| Attribute | Runes  |
| --------- | ------ |
| Shape     | 21     |
| Element   | 14     |
| Duration  | 7      |
| Effect    | 35     |
| **Total** | **77** |

## Combination space

Three mandatory slots, and two optional Effect slots that are ordered and may not repeat a rune.

| Spell shape                        | Arithmetic      | Distinct spells |
| ---------------------------------- | --------------- | --------------- |
| Three mandatory slots only         | 21 × 14 × 7     | 2 058           |
| Plus one Effect                    | 2 058 × 35      | 72 030          |
| Plus two ordered, distinct Effects | 2 058 × 35 × 34 | 2 449 020       |

A smaller space where every choice means something beats a larger one padded out with combinations nobody would ever build.
Two and a half million spells, times three rarities per rune, is far more than any player can survey.

## Notes for balancing

**The weight columns are a first pass.**
Expect to retune them once the weight bar is implemented and a single fight can be measured.

**Three runes are deliberately overpowered and should be watched first.**
`Hunger` on a Swarm, `Detonate` after any lingering element, and `Eternal` with `Growth` are the combinations most likely to break early testing.

**Three runes are deliberately almost useless alone.**
`Anchor`, `Growth` and `Detonate` do nothing without a partner, and that is intended: they are the runes that teach a player that Effect order matters.

**`Pool` and `Rain` need watching.**
Both are placed area shapes, and `Pool` at weight 3 is cheaper than `Rain` at 4.
They are separated by `Rain` striking from above in bursts while `Pool` holds the ground continuously, which is a real difference only if `Lingering` and `Instant` feel distinct in play.
