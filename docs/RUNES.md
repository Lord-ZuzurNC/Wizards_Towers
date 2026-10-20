# Runes — Wizards Towers

A rune is the atomic ingredient of a spell.
Each rune belongs to exactly one **attribute**, and an attribute is a position inside a spell.

There are **five attributes** and **six spell slots**, because the Effect attribute occupies two of them.

| Slot | Attribute | Mandatory | Opens at |
| ---- | --------- | --------- | -------- |
| 1    | Shape     | yes       | level 1  |
| 2    | Range     | yes       | level 1  |
| 3    | Element   | yes       | level 1  |
| 4    | Duration  | yes       | level 1  |
| 5    | Effect1   | no        | level 2  |
| 6    | Effect2   | no        | level 2  |

A spell is castable once the four mandatory slots hold a rune.
The two Effect slots are optional and **ordered**: `Chain → Split` is not the same spell as `Split → Chain`.

## How to read this document

**Nothing here has a mana cost, and that is deliberate.**
A spell's cost is computed from what the assembled runes produce, never authored rune by rune.
What each rune carries instead is a **weight**, and the weights are what the cost computation reads.

Three rules govern every table below.

**Rarity scales, it never changes.**
A legendary Ember does exactly what a common Ember does, harder.
One rune, one behaviour, three magnitudes.

| Rarity        | Multiplier | Weight multiplier |
| ------------- | ---------- | ----------------- |
| **common**    | ×1.0       | ×1.0              |
| **rare**      | ×1.6       | ×1.4              |
| **legendary** | ×2.5       | ×2.0              |

A rune at legendary rarity is stronger than one at common, but it also weighs more, so it pushes the spell's cost bar further.
A wizard cannot simply fill six slots with legendaries and expect to cast the result.

⚠️ Note the phrasing above, because it matters.
Write **"a rune at legendary rarity"**, never "a legendary rune" — that exact phrase is banned by the glossary, because it was the old name for what is now an **Artifact**.

**Weight is the cost pressure, not the power.**
A rune with weight 3 and a rune with weight 3 cost the same to include even if one is far more useful in a given build.
That is the lever that makes a cheap spell worth building.

**Every value in the tables is the common-rarity value.**
Multiply by the table above for rare and legendary.

---

## Shape

Shape decides the geometry of the spell: what the magic *is* when it leaves the wizard.

It is the slot with the strongest influence on how a spell feels to use, and the one players will recognise first.

| Rune           | What it does                                                                                      | Weight | Notes                                                        |
| -------------- | ------------------------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------ |
| **Bolt**       | A single fast projectile that strikes the first thing it touches.                                 | 1      | The cheapest shape. The default of every new wizard.          |
| **Lance**      | A slower, heavier projectile that pierces the first target and continues.                         | 2      | Rewards lining enemies up.                                    |
| **Spray**      | A wide cone of short-lived fragments in front of the caster.                                      | 2      | Damage falls off sharply with distance.                       |
| **Beam**       | A continuous line that persists while held, striking everything along it.                         | 3      | Consumes mana per tick rather than per cast.                  |
| **Nova**       | A ring expanding outward from the caster, striking everything it passes.                           | 3      | Cannot be aimed. Hits allies' enemies and the caster's own.    |
| **Orb**        | A slow floating sphere that drifts forward and detonates on contact or expiry.                     | 3      | The only shape that can be outrun.                            |
| **Rain**       | A column of falling strikes over a target area.                                                    | 4      | Needs a flat target. Useless against a single moving enemy.    |
| **Wall**       | A standing barrier of the chosen element, blocking movement and damaging on contact.               | 4      | Defensive, and the best shape for holding a village gate.      |
| **Aura**       | A radius centred on the caster that persists and affects everything inside it.                     | 4      | Moves with the wizard. Pairs badly with long Range.            |
| **Tether**     | A line binding the caster to one target, applying the spell to both ends.                          | 4      | Breaks at a distance. The only shape that can damage its owner.|
| **Seed**       | A dormant mark on the ground that triggers when anything steps on it.                              | 3      | Survives logout. The village-defence shape.                    |
| **Swarm**      | Several small homing fragments that each seek a different target.                                   | 5      | Splits its power across however many targets exist.            |
| **Vortex**     | A pulling field that drags enemies toward its centre while it lasts.                               | 5      | Deals little damage alone. Devastating with a second Effect.   |
| **Judgement**  | A single immense stationary strike on one point, after a visible delay.                             | 6      | The heaviest shape in the game. Telegraphed and avoidable.     |

## Range

Range decides how far the Shape may be placed or thrown.

It is the cheapest attribute to get wrong, because a wizard who pairs an Aura with Horizon has paid for distance the Shape cannot use.

| Rune           | What it does                                                                        | Weight | Notes                                                       |
| -------------- | ----------------------------------------------------------------------------------- | ------ | ----------------------------------------------------------- |
| **Touch**      | The spell resolves where the wizard stands, or on what they are touching.           | 0      | Free. The only zero-weight rune in the game.                 |
| **Near**       | A short radius around the wizard, roughly a village square.                         | 1      | The honest default.                                          |
| **Reach**      | Medium distance, roughly a bowshot.                                                 | 2      | Where most offensive spells live.                            |
| **Far**        | Long distance, to the edge of what the wizard can see clearly.                       | 3      | Wins duels, loses to walls.                                  |
| **Horizon**    | To the limit of the visible screen, wherever that is.                                | 5      | Expensive and often wasted.                                  |
| **Anywhere**   | Any point the wizard has personally visited this run.                                | 6      | Enables remote village defence. Cannot target a moving enemy.|
| **Self**       | The wizard's own body, and nothing else.                                             | 0      | Required by most restorative Effects.                        |
| **Inverted**   | The spell resolves behind the wizard rather than in front.                           | 2      | Strange, cheap, and excellent for an escape.                 |

## Element

Element gives the spell its nature.
It decides what the damage *is*, and therefore what resists it.

| Rune            | What it does                                                                                       | Weight | Notes                                                          |
| --------------- | -------------------------------------------------------------------------------------------------- | ------ | -------------------------------------------------------------- |
| **Ember**       | Fire damage, and a short burn afterwards.                                                           | 2      | The reliable one. Burns through village crops.                  |
| **Rime**        | Cold damage, and a brief slow.                                                                      | 2      | The best element for escaping a stronger wizard.                |
| **Spark**       | Lightning damage, instant, with a chance to strike twice.                                            | 2      | The only element with built-in randomness, scaled by luck.      |
| **Stone**       | Blunt damage, slow to land, ignoring a portion of magic defence.                                     | 3      | The answer to a high-defence echo.                              |
| **Gale**        | Wind damage, light, pushing what it hits.                                                            | 2      | Low damage, high control. Can shove an enemy off a floor.       |
| **Verdure**     | Living damage that spreads to what stands nearby.                                                    | 3      | Spreads through crops and through packed enemies.               |
| **Brine**       | Corrosive damage that reduces the target's magic defence while it lasts.                             | 3      | Opens a target for a second, heavier spell.                     |
| **Gloom**       | Shadow damage that is stronger against a target that cannot see the caster.                          | 3      | Rewards ambush. Weak in the open.                               |
| **Radiance**    | Light damage, stronger against the undead and against echoes.                                        | 4      | The anti-echo element. A floor raider's choice.                 |
| **Ichor**       | Blood damage that costs the caster health and returns it on a hit.                                   | 4      | The only element that can kill its own caster.                   |
| **Null**        | Pure force with no elemental nature, which nothing resists and nothing is weak to.                   | 5      | Expensive, predictable, and never the wrong answer.             |
| **Unmaking**    | Void damage that also removes a buff or a lingering effect from the target.                           | 5      | The only element that interacts with other wizards' spells.      |

## Duration

Duration decides how the spell exists in time.

It is the attribute players understand last and exploit hardest, because it changes cooldown as well as persistence.

| Rune            | What it does                                                                                   | Weight | Notes                                                        |
| --------------- | ---------------------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------ |
| **Instant**     | The spell resolves once, immediately, and is gone.                                              | 1      | The default. Shortest cooldown.                               |
| **Brief**       | The spell persists for about two seconds.                                                       | 2      | Enough for a Beam or an Aura to matter.                       |
| **Sustained**   | The spell persists while the wizard holds the cast and pays mana per tick.                       | 3      | Converts a spell from a cost into a drain.                    |
| **Lingering**   | The spell leaves its effect behind for several seconds after resolving.                         | 3      | What makes a Wall or a Seed worth building.                   |
| **Delayed**     | The spell resolves after a visible pause, then fires.                                            | 2      | Cheap, telegraphed, and brutal when it connects.              |
| **Echoing**     | The spell resolves a second time, weaker, a moment later.                                       | 4      | Two hits from one cast and one cooldown.                      |
| **Patient**     | The spell waits, armed, until a condition is met or it expires.                                  | 4      | The trap Duration. Pairs with Seed for offline defence.        |
| **Eternal**     | The spell persists until destroyed or until the wizard casts it again.                           | 6      | Only one Eternal spell can be active at a time.                |

## Effect

Effect is where a spell stops being a shaped element and becomes an idea.

Two Effect slots exist, they are optional, and **their order changes the result**.
As a rule of thumb: the first Effect modifies the spell, and the second Effect modifies the first.

| Rune              | What it does                                                                                         | Weight | Notes                                                           |
| ----------------- | ---------------------------------------------------------------------------------------------------- | ------ | --------------------------------------------------------------- |
| **Chain**         | The spell jumps from its target to a nearby one, weaker each jump.                                    | 3      | The classic. Scales with how packed the enemies are.             |
| **Split**         | The spell divides into two smaller copies on resolving.                                               | 3      | After Chain it jumps then splits. Before it, it splits then jumps.|
| **Pierce**        | The spell passes through its first target and continues.                                              | 2      | Redundant on a Lance. Transformative on a Bolt.                  |
| **Bounce**        | The spell reflects off walls and floor edges instead of expiring.                                     | 3      | Lethal in a Monolith corridor, useless in the open field.         |
| **Seek**          | The spell curves toward the nearest valid target.                                                     | 3      | Removes the need to aim. Removes the reward for aiming.          |
| **Knockback**     | The spell shoves what it hits away from the caster.                                                   | 2      | Can push an enemy off a floor or out of a village.               |
| **Pull**          | The spell drags what it hits toward the caster.                                                       | 2      | Sets up a melee weapon or a second Nova.                         |
| **Root**          | The spell holds what it hits in place briefly.                                                        | 3      | The strongest control effect in the game and priced accordingly. |
| **Slow**          | The spell reduces the target's speed while it lasts.                                                   | 2      | Stacks with Rime rather than replacing it.                       |
| **Blind**         | The spell removes the target's ability to see the caster.                                              | 3      | Turns Gloom from situational into a build.                       |
| **Mute**          | The spell prevents the target from casting for a moment.                                               | 4      | The only answer to a wizard with a Sustained Beam.               |
| **Drain**         | The spell returns a portion of damage dealt to the caster as mana.                                     | 4      | Lets an expensive spell pay for its own next cast.               |
| **Leech**         | The spell returns a portion of damage dealt to the caster as health.                                   | 4      | The reason a wizard can survive a dungeon alone.                 |
| **Mend**          | The spell restores health instead of removing it.                                                      | 3      | Inverts the whole spell. Requires Self or Touch to be useful.     |
| **Ward**          | The spell grants a shield absorbing a fixed amount of damage.                                          | 3      | The only Effect that works while the caster is doing nothing.     |
| **Haste**         | The spell increases the target's speed while it lasts.                                                 | 3      | On Self with Aura, the best escape in the game.                   |
| **Mark**          | The spell tags the target, and the wizard's next spell against them is stronger.                       | 3      | Rewards planning two casts ahead.                                 |
| **Detonate**      | The spell consumes every lingering effect on the target for a burst of damage.                         | 4      | The payoff rune. Worthless without a setup.                       |
| **Fracture**      | The spell reduces the target's magic defence permanently for the rest of the fight.                     | 4      | Makes a long fight winnable. Does nothing in a short one.         |
| **Siphon**        | The spell steals a lingering buff from the target and gives it to the caster.                           | 5      | The only rune that can take another wizard's Ward.                 |
| **Reprise**       | The spell leaves a faint copy that repeats it once at reduced power.                                    | 4      | Distinct from the Duration rune **Echoing**, and they stack.      |
| **Anchor**        | The spell's position is fixed in the world and does not move with its target.                           | 2      | Converts an Aura into a zone. Converts a Tether into a trap.      |
| **Growth**        | The spell becomes stronger the longer it persists.                                                      | 4      | Needs Sustained or Eternal to do anything at all.                 |
| **Waning**        | The spell becomes weaker the longer it persists, but starts far stronger.                               | 3      | The front-loaded option. Good with Instant, absurd with Brief.     |
| **Sacrifice**     | The spell costs health in addition to mana, and hits far harder for it.                                  | 3      | Cheap on the cost bar, expensive on the wizard.                   |
| **Greed**         | The spell deals more damage the more gold the caster is carrying.                                        | 3      | Makes a rich wizard a target worth killing.                        |
| **Humility**      | The spell deals more damage the fewer villages the caster owns.                                           | 2      | The comeback rune. Strongest in the hands of someone losing.       |
| **Toll**          | The spell deals more damage the more floors the target holds.                                              | 4      | Built to kill the leader. Useless against a newcomer.              |
| **Kindle**        | The spell's cooldown shortens each time it kills something.                                                | 4      | Turns a clear into a chain of clears.                              |
| **Patience**      | The spell deals more damage the longer it has been since the wizard last cast anything.                     | 3      | Punishes spam. Rewards the single prepared strike.                  |
| **Spite**         | The spell resolves once more, free, if it kills the caster.                                                 | 3      | The last word. Can take a rival down with you.                      |
| **Covet**         | The spell damages structures far more than it damages wizards.                                              | 2      | The village-razing rune. Nearly harmless in a duel.                 |
| **Reverence**     | The spell cannot harm a village, a tower or a crop, and hits wizards harder for the restraint.               | 2      | The duellist's rune, and a declaration of intent.                   |
| **Unbinding**     | The spell removes one of the target's own lingering effects before resolving.                                | 4      | The answer to a Ward, a Haste or a Growth.                          |
| **Hunger**        | The spell grows stronger for every enemy it has already hit this cast.                                        | 5      | Absurd on Chain or Swarm. Pointless on a Bolt.                      |

---

## Rune counts

| Attribute | Runes |
| --------- | ----- |
| Shape     | 14    |
| Range     | 8     |
| Element   | 12    |
| Duration  | 8     |
| Effect    | 35    |
| **Total** | **77**|

## Combination space

With four mandatory slots and two optional ordered Effect slots, the raw count of distinct spells is large enough that nobody will exhaust it.

| Spell shape                        | Arithmetic              | Distinct spells |
| ---------------------------------- | ----------------------- | --------------- |
| Four mandatory slots only          | 14 × 8 × 12 × 8         | 10 752          |
| Plus one Effect                    | 10 752 × 35             | 376 320         |
| Plus two ordered, distinct Effects | 10 752 × 35 × 34        | 12 794 880      |

Multiplied by three rarities per rune, the space is far beyond anything a player can survey, which is the point: a wizard does not pick the best spell, they find a good one.

⬜ The figure above assumes the two Effect slots must hold **different** runes.
If the same rune may be placed in both, the last line becomes 10 752 × 35 × 35, or 13 171 200.
Worth deciding, because "Chain → Chain" is either a legitimate build or a bug.

## Notes for balancing

**The weights are a first pass and they are the knob to turn.**
Every number in the weight columns is a guess made for internal consistency, not from play.
Expect to change them all once a cost bar exists and a single fight can be measured.

**Three runes are deliberately overpowered and should be watched first.**
`Hunger` on a Swarm, `Detonate` after any lingering element, and `Eternal` with `Growth` are the combinations most likely to break early testing.

**Three runes are deliberately almost useless alone.**
`Anchor`, `Growth` and `Detonate` do nothing without a partner, and that is intended: they are the runes that teach a player that Effect order matters.

**Four names collided with the glossary and were already changed.**
I caught these while writing, and they are worth recording because they show the glossary working as intended.

| Rejected name | Collided with                        | Now           |
| ------------- | ------------------------------------ | ------------- |
| Monolith      | **the Monolith**, the central tower   | **Judgement** |
| Echo          | **echo**, the floor defender          | **Reprise**   |
| Decay         | **decay**, the per-season weakening   | **Waning**    |
| Silence       | the Effect rune **Mute**              | **Null**      |

The first three were outright bans. The fourth was merely confusing, which is reason enough.
