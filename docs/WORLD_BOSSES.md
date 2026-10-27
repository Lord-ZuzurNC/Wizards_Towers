# World bosses — Wizards Towers

This document lists the world bosses available to a run.
A world boss is a PvE entity standing on the open world map, outside the Monolith.
It is never a floor boss and never a dungeon boss.
Its strength is tied to the season, and killing one is one of the best sources of gold, XP, reincarnation points and rare runes in the game.

- [World bosses — Wizards Towers](#world-bosses--wizards-towers)
  - [How to read this document](#how-to-read-this-document)
  - [PvP and the kill](#pvp-and-the-kill)
  - [Summary table](#summary-table)
  - [Crowd versus solo: quick index](#crowd-versus-solo-quick-index)
  - [Bosses](#bosses)
    - [The Harrow](#the-harrow)
    - [The Tallyman](#the-tallyman)
    - [The Rootbound Colossus](#the-rootbound-colossus)
    - [The Leaden Saint](#the-leaden-saint)
    - [The Breach-Warden](#the-breach-warden)
    - [The Collector](#the-collector)
    - [The Twin Omen](#the-twin-omen)
    - [The Riven Maw](#the-riven-maw)
    - [Stormcaller Roost](#stormcaller-roost)
    - [The Drowned King](#the-drowned-king)
    - [Fortune's Thief](#fortunes-thief)
    - [The Nightfall Reaper](#the-nightfall-reaper)
    - [The Hollow Choir](#the-hollow-choir)
  - [Season scaling](#season-scaling)
  - [Notes for balancing](#notes-for-balancing)

## How to read this document

Thirteen world bosses follow, each at least five times a champion's strength, per the designer's floor of health 4 500, power 300, magic defence 200.
Every boss carries the same six stats as every other combatant in the game: `health`, `power`, `mana_pool`, `magic_defence`, `speed`, `luck`.
`power` is one number regardless of attack type, so a separate **Attack type** field says whether that number lands as melee or magic.

The summary table gives every boss's baseline stat block, the season it belongs to and where it stands on the world map.
Each boss then gets its own subsection with a short mini stat block for quick reference, a description, its phases, what makes the fight distinct, its drops and how a group versus a lone wizard experiences it.

The numbers here are a first pass meant to be cut down and rebalanced, not a finished tuning.
That intention is restated in [Notes for balancing](#notes-for-balancing).

## PvP and the kill

The world allows up to 50 wizards and always-on PvP outside safe zones, so a world boss fight is also a PvP flashpoint.
Nothing in the existing design documents decides whether kill credit for loot and reincarnation points goes to whoever lands the last hit or to whoever contributed the most damage.

⬜ **Open question.**
That credit rule is not decided anywhere in `GLOSSARY.md` or `GUIDELINES.md`, and it changes how every boss below actually plays out in a contested pull.
Every boss is written so its mechanic makes sense under either rule, but the project needs to settle this before implementation.

What is designed below, per boss, is how the fight itself behaves when several wizards converge on it at once: whether it rewards coordination, punishes a crowd outright, or stays indifferent to how many wizards are swinging at it.

## Summary table

| Name                   | Attack type | health | power | mana pool | magic defence | speed | luck | Season                 | Where it stands                      |
| ---------------------- | ----------- | ------ | ----- | --------- | ------------- | ----- | ---- | ---------------------- | ------------------------------------ |
| The Harrow             | melee       | 5200   | 320   | 400       | 220           | 90    | 10   | Spring                 | Village outskirts, roaming           |
| The Tallyman           | magic       | 4800   | 310   | 900       | 230           | 115   | 20   | Spring, Summer         | Trade roads between villages         |
| The Rootbound Colossus | melee       | 6000   | 340   | 300       | 260           | 70    | 8    | Spring, persists after | The Deep Fen                         |
| The Leaden Saint       | magic       | 5400   | 330   | 1200      | 300           | 85    | 12   | Summer                 | Sunfall Mesa                         |
| The Breach-Warden      | magic       | 7000   | 360   | 1000      | 280           | 95    | 14   | All seasons            | The Outer Ring, at the Monolith base |
| The Collector          | magic       | 5600   | 320   | 1100      | 240           | 100   | 18   | Autumn                 | Ruins of the Fourth Spire            |
| The Twin Omen          | magic       | 5000   | 300   | 1300      | 220           | 100   | 15   | Summer                 | The Rift Glade                       |
| The Riven Maw          | melee       | 12000  | 620   | 2000      | 420           | 110   | 25   | Winter only            | The Deep Rift                        |
| Stormcaller Roost      | magic       | 6500   | 350   | 1400      | 230           | 130   | 16   | Autumn                 | The Shattered Crag                   |
| The Drowned King       | melee       | 5800   | 335   | 500       | 250           | 60    | 10   | Summer                 | The Sunken Mire                      |
| Fortune's Thief        | magic       | 4900   | 305   | 950       | 215           | 120   | 30   | All seasons            | Wherever a treasure just opened      |
| The Nightfall Reaper   | magic       | 5300   | 345   | 850       | 235           | 140   | 14   | Autumn, Winter         | The Umbral Wood                      |
| The Hollow Choir       | magic       | 5700   | 325   | 1600      | 245           | 100   | 20   | Winter                 | The Frozen Choir                     |

## Crowd versus solo: quick index

| Boss                   | What a crowd gets                                                               |
| ---------------------- | ------------------------------------------------------------------------------- |
| The Harrow             | Indifferent to numbers, but every minute it survives costs a village's crops.   |
| The Tallyman           | A race: whoever's damage triggers its flight condition first decides the fight. |
| The Rootbound Colossus | Rewards an early, decisive group kill before its growth compounds further.      |
| The Leaden Saint       | Rewards a coordinated swap from Stone to raw power once it cracks.              |
| The Breach-Warden      | Indifferent alone, but it actively drags nearby floor raiders into the fight.   |
| The Collector          | Punishes whichever wizard in the group is carrying the most Artifacts.          |
| The Twin Omen          | Punishes solo play directly, by forcing a split-attention fight on one wizard.  |
| The Riven Maw          | Requires a group; its late phases outscale almost any solo wizard's output.     |
| Stormcaller Roost      | Punishes a crowd outright, its pulses scale with how many stand in range.       |
| The Drowned King       | Punishes a crowd softly, by locking the fight to whoever last struck it.        |
| Fortune's Thief        | Rewards a wizard with high luck, punishes one who gambles and loses the roll.   |
| The Nightfall Reaper   | Punishes bystanders directly, hitting everyone who is not the lead attacker.    |
| The Hollow Choir       | Rewards a disciplined group, overwhelms an uncoordinated one with its adds.     |

## Bosses

### The Harrow

- **Attack type:** melee
- **health:** 5200
- **power:** 320
- **mana pool:** 400
- **magic defence:** 220
- **speed:** 90
- **luck:** 10
- **Season:** Spring
- **Where it stands:** village outskirts, roaming between unclaimed villages

The Harrow is a lumbering, briar-crowned enemy that tramples through newly planted fields, the first real threat a world produces once spring opens its villages for growth.
It carries no spellbook of note, hitting hard and slow, and its danger comes less from the fight itself than from what it does while nobody is fighting it.

**Phases.**
Above 50% health it grazes, trampling crops at a steady rate and occasionally rooting a wizard in place with a burst of living growth.
Below 50% it enrages: its attack speed rises sharply, and from this point on it begins actively devouring a nearby village's crops, draining that village's gold income for as long as the enrage persists.

**What makes this fight different.**
The Harrow is the clearest example of a boss that punishes being ignored rather than being engaged.
A wizard who leaves it alive past its enrage threshold is trading their own safety for a village's income, and the two outcomes are explicit, not implied.

**Drops.**
Gold at a common-world-boss rate, a meaningful XP and reincarnation point award, and a chance at a Verdure-attribute rune, since its own attacks are built from that element.
A small chance at a mana-stone, no higher than any other non-apex world boss.

**Group versus solo.**
A group kills it fast enough that the enrage phase barely matters, trading a clean kill for less time spent farming its crop-damage window.
A solo wizard can still win, but risks letting it reach enrage and cost a village real income while they finish the fight.

### The Tallyman

- **Attack type:** magic
- **health:** 4800
- **power:** 310
- **mana pool:** 900
- **magic defence:** 230
- **speed:** 115
- **luck:** 20
- **Season:** Spring, Summer
- **Where it stands:** the trade roads strung between villages

The Tallyman is a thin, ledger-carrying enemy that robs wizards and villages alike on the roads between settlements, converting every successful theft into a "purse" it carries on its own body.
Killing it while that purse is full returns every coin it has stolen this encounter, straight into the killer's pocket.

**Phases.**
It has no health-based phase transition.
Instead it runs a purse meter: each successful theft fills it, and once full the Tallyman stops fighting and sprints for the nearest Ground Floor gate to bank the gold permanently, at which point it can no longer be robbed back.

**What makes this fight different.**
Every other boss on this list is a straightforward damage race.
The Tallyman is a race against its own escape condition, and a wizard who deals damage without first stopping its theft and its flight simply loses the gold regardless of the kill.

**Drops.**
Whatever gold is in its purse when it dies, plus the baseline gold, XP and reincarnation point award.
A Greed-attribute rune is its signature drop, since its own damage output scales with carried gold, and a small chance at a mana-stone.

**Group versus solo.**
A crowd can split duties — some wizards block its flight path while others burn it down — and this is close to the only reliable way to catch its full purse.
A solo wizard has to choose between chasing and fighting, and usually only gets one of the two.

### The Rootbound Colossus

- **Attack type:** melee
- **health:** 6000 (base, before growth)
- **power:** 340 (base, before growth)
- **mana pool:** 300
- **magic defence:** 260 (base, before growth)
- **speed:** 70
- **luck:** 8
- **Season:** Spring, persists through every later season it survives
- **Where it stands:** the Deep Fen, rooted, does not roam

The Rootbound Colossus is an ancient, tree-limbed enemy that spawns at the start of a run and never despawns on its own, rooted to one spot in the Deep Fen until something kills it.
Every season it survives, it grows, so the easy kill of week one becomes the apex threat of week six if nobody bothers.

**Phases.**
Dormant: immobile, low aggression, and the easiest world boss on this list to pick off early, since it has not yet grown.
Awakened: triggered either by dropping below roughly 60% health in a single engagement, or automatically once it has survived into a second season, after which it uproots, becomes mobile, and gains an area root-snare attack.

**What makes this fight different.**
It is the only boss whose difficulty is not fixed by the designer's season-strength table, but by the players' own inattention.
Every other boss resets its threat at season start; this one carries its growth forward, compounding on top of the normal seasonal scalar described in [Season scaling](#season-scaling).

**Drops.**
Scales with how long it lived: gold, XP and reincarnation points all rise with its accumulated growth, rewarding the group that finally ends a long-ignored Colossus.
Its signature rune is Growth, matching its own mechanic, and its mana-stone and life-stone chance both rise the longer it survived before dying.

**Group versus solo.**
Early, a lone wizard can solo the dormant phase without much trouble.
Left for even one full season, it demands a coordinated group, which is the entire point: it rewards a server-wide decision to kill it early rather than let it compound.

### The Leaden Saint

- **Attack type:** magic
- **health:** 5400
- **power:** 330
- **mana pool:** 1200
- **magic defence:** 300
- **speed:** 85
- **luck:** 12
- **Season:** Summer
- **Where it stands:** atop Sunfall Mesa, an open highland plateau

The Leaden Saint is a statue-still enemy wrapped in grounded stone, meditating atop an exposed mesa where nothing shields a wizard from its retaliation.
It is immune to Spark damage outright, since lightning finds nothing to arc through in a body with no moisture and no nerve, and it takes bonus damage from Stone and from Null.

**Phases.**
Phase 1 is a pure defensive tank: high magic defence, slow attacks, almost no threat on its own.
At 50% health it cracks: magic defence is halved for the rest of the fight, but power rises and it unlocks a seeking Stone projectile that tracks whoever dealt the triggering hit.

**What makes this fight different.**
It is the list's clearest answer to "immune to one element."
A wizard who built around Spark, the element RUNES.md calls "the only element with built-in randomness," gets nothing from this fight and has to swap into Stone or Null to make any progress at all.

**Drops.**
A Stone-attribute rune at an elevated chance, reflecting what counters it, plus the baseline gold, XP and reincarnation points.
Its mana-stone chance is standard; it carries no particular life-stone bias.

**Group versus solo.**
A group that brought nothing but Spark builds still fails as badly as a solo wizard would, since the immunity does not care how many are hitting it.
Once the crack phase starts, a coordinated group can focus the exposed window far faster than a solo wizard can exploit it alone.

### The Breach-Warden

- **Attack type:** magic
- **health:** 7000
- **power:** 360
- **mana pool:** 1000
- **magic defence:** 280
- **speed:** 95
- **luck:** 14
- **Season:** all seasons
- **Where it stands:** the Outer Ring, the open ground encircling the Monolith's base, in sight of the Ground Floor gate

The Breach-Warden is a permanent fixture of the world map, a sentinel of cracked Monolith stone that patrols the ring of ground around the tower's base.
Unlike every other boss here, it does not need a season to exist: it spawns with the world and remains until killed, regardless of how many seasons pass.

**Phases.**
It has no health-based phase.
Instead it alternates between a patrol state, where it circles the Outer Ring and largely ignores anyone who keeps clear, and a lockdown state, triggered automatically whenever a floor raid begins nearby, during which it rushes toward the raiders and actively interferes with the attempt.

**What makes this fight different.**
It is the only boss whose trigger condition is another system entirely: a floor raid starting at the Ground Floor.
A group raiding a low floor can suddenly find themselves fighting a world boss as well, with no warning beyond its lockdown state kicking in.

**Drops.**
Gold, XP and reincarnation points at the high end for a non-apex boss, reflecting that its fight is rarely chosen voluntarily.
Its signature rune is Toll, since like that Effect rune it is built to punish the strong rather than the newcomer, and it carries a modestly elevated mana-stone chance given how often it is fought unwillingly.

**Group versus solo.**
A solo floor raider who triggers its lockdown is usually overwhelmed and has to abandon the raid.
A group raiding together can usually spare one or two wizards to hold it off while the rest continue the floor, which is the intended answer to this boss.

### The Collector

- **Attack type:** magic
- **health:** 5600
- **power:** 320
- **mana pool:** 1100
- **magic defence:** 240
- **speed:** 100
- **luck:** 18
- **Season:** Autumn
- **Where it stands:** the Ruins of the Fourth Spire, a collapsed early floor's rubble on the world map

The Collector is a hoarding enemy built from fused rubble and stolen rune-glass, haunting the ruins of a floor that fell before the current run began.
It reads every wizard that engages it for how many Artifacts they currently hold, and converts that count directly into its own strength for the fight.

**Phases.**
It has no phase transition by health.
Its modifier is live and continuous: for each Artifact the current primary target carries, it gains a stacking damage bonus and a small Ward-like shield, so the fight gets harder the richer in Artifacts the target is.

**What makes this fight different.**
Every other boss treats every wizard the same.
This one explicitly punishes success elsewhere in the run, turning a floor-holder's collection of Artifacts into a liability the moment they step up to fight it.

**Drops.**
A guaranteed rare rune on top of the baseline gold, XP and reincarnation points, biased toward whichever attribute slot the engaging Artifact-heavy wizard is weakest in.
Its mana-stone chance rises with how many Artifacts were held by whoever landed the killing blow, a small but deliberate reward for taking the risk.

**Group versus solo.**
In a group, only the member carrying the most Artifacts suffers the scaling penalty, so the smart play is to let a light-Artifact wizard tank it while the rest burn it down.
A solo wizard gets no such option: if they hold several Artifacts, they fight the full penalty alone.

### The Twin Omen

- **Attack type:** magic
- **health:** 5000
- **power:** 300
- **mana pool:** 1300
- **magic defence:** 220
- **speed:** 100
- **luck:** 15
- **Season:** Summer
- **Where it stands:** the Rift Glade

The Twin Omen is a mirror-faced enemy that, the instant it is engaged, reads the attacking wizard's bound capital village and conjures a raiding party against it elsewhere on the map.
The fight at the Rift Glade and the siege at the wizard's capital run simultaneously, and the wizard cannot be in both places.

**Phases.**
Phase 1 is a binding cast lasting roughly 20 seconds, during which the Twin Omen is nearly invulnerable while it locks onto the target's capital and spawns the mirrored raid.
Phase 2 begins once that binding resolves: the Twin Omen becomes fully engageable, and at the same moment the wizard's own echo is forcibly summoned to defend the capital for the duration, exactly as it already would while that wizard is offline.

**What makes this fight different.**
This is the one boss built entirely around the game's existing echo-defends-the-capital mechanic.
Fighting it means trusting an echo to hold a village alone while its owner is occupied elsewhere, with no way to intervene until the fight ends.

**Drops.**
The baseline gold, XP and reincarnation point award, plus an Anchor-attribute rune, fitting for a boss whose whole identity is tying two fixed points together.
Its mana-stone and life-stone chances are both standard, with no bias either way.

**Group versus solo.**
This is the sharpest solo punishment on the list: a lone wizard risks their own capital every time they engage it.
A group can designate one member to fight the Twin Omen while leaving their own capitals untouched, since only the engaging wizard's capital is targeted, making this fight far safer with company.

### The Riven Maw

- **Attack type:** melee
- **health:** 12000
- **power:** 620
- **mana pool:** 2000
- **magic defence:** 420
- **speed:** 110
- **luck:** 25
- **Season:** winter only
- **Where it stands:** the Deep Rift, a chasm that only opens in winter

The Riven Maw erupts from a chasm that does not exist until winter, a vast, ice-locked enemy built as the run's final-season threat for wizards not yet ready for the roof.
It is the strongest entry on this list by a wide margin and is never present outside winter at all.

**Phases.**
Three phases by health threshold.
Above 66% it fights conservatively, testing the engaging wizards with slow, heavy strikes.
Between 66% and 33% it adds a frost-based area attack that slows everyone caught in it.
Below 33% it unlocks a battlefield-narrowing frost effect that echoes the shrinking-arena tension of the Monolith's own sudden death, without touching that system's actual numbers, forcing a decisive fight rather than a drawn-out one.

**What makes this fight different.**
It is the only boss on this list explicitly designed to outscale a solo wizard at every phase, including the first.
Its appearance only in winter also means it is the run's clearest signal that time is running out before a bad ending.

**Drops.**
The best non-capital-floor loot in the game: a guaranteed rare rune, elevated reincarnation points, and the highest mana-stone and life-stone chance of any world boss on this list.
Its signature rune is Judgement, the heaviest Shape rune in the game, fitting for the heaviest boss.

**Group versus solo.**
A solo wizard should not expect to win this fight; its stats are set well above what any single build can sustain.
It is built for a group, and a disciplined group that manages its frost effects in the final phase is the intended way to clear it.

### Stormcaller Roost

- **Attack type:** magic
- **health:** 6500
- **power:** 350
- **mana pool:** 1400
- **magic defence:** 230
- **speed:** 130
- **luck:** 16
- **Season:** Autumn
- **Where it stands:** the Shattered Crag, a wind-scoured peak

Stormcaller Roost is a nesting enemy of living wind and lightning that perches atop an exposed peak, visible from a long distance and audible even further.
Its signature attack is a Nova-style pulse that cannot be aimed, striking everything in range at once, and its damage scales directly with how many wizards are standing inside that range.

**Phases.**
It has no health-gated phases.
Its structure is a repeating timer: a pulse fires on a fixed interval regardless of its own health, and the only thing that changes over the fight is how many wizards are present to be hit by it.

**What makes this fight different.**
It is the clearest "punishes a crowd" design on this list, deliberately rewarding exactly the opposite instinct most bosses teach.
Clustering to maximise damage output against it is the wrong read; its pulse scales faster than a crowd's extra damage compensates for.

**Drops.**
A Gale-attribute rune as its signature drop, plus the baseline gold, XP and reincarnation points.
Its mana-stone chance is standard, unmodified by how many wizards took part.

**Group versus solo.**
A crowd that spreads out and takes turns engaging does fine; a crowd that stacks on top of each other gets punished hard by every pulse.
A solo wizard never suffers the scaling at all, making this one of the few bosses where going alone is strictly safer, if slower.

### The Drowned King

- **Attack type:** melee
- **health:** 5800
- **power:** 335
- **mana pool:** 500
- **magic defence:** 250
- **speed:** 60
- **luck:** 10
- **Season:** Summer
- **Where it stands:** the Sunken Mire, a swamp basin

The Drowned King is a slow, crowned enemy submerged in a swamp basin, fighting from the water's surface and periodically vanishing beneath it entirely.
When it submerges, it becomes untargetable to everyone except the wizard who landed the most recent hit before it went under, a grudge-lock that follows that one wizard until it resurfaces.

**Phases.**
Surfaced: a normal, fully targetable melee fight.
Submerged: triggered on a timer, lasting several seconds, during which only the current grudge-holder can interact with it at all, before it resurfaces and the cycle repeats.

**What makes this fight different.**
It is the list's soft answer to crowd control, distinct from Stormcaller Roost's hard AoE punishment.
A crowd's damage does not accumulate evenly here, because during every submersion only one wizard's damage counts at all, effectively forcing the fight through a single duelist in rotation.

**Drops.**
A Brine-attribute rune as its signature drop, since its corrosive, water-born nature matches that element, plus the baseline gold, XP and reincarnation points.
Its mana-stone chance is standard.

**Group versus solo.**
A solo wizard experiences no functional difference from a normal fight, since they are always the grudge-holder.
A group has to accept that only one of them is actually progressing the kill at any given moment, which makes this fight far less efficient to zerg than its health total would suggest.

### Fortune's Thief

- **Attack type:** magic
- **health:** 4900
- **power:** 305
- **mana pool:** 950
- **magic defence:** 215
- **speed:** 120
- **luck:** 30
- **Season:** all seasons
- **Where it stands:** wherever a treasure has just been opened, teleporting between recent sites

Fortune's Thief is a roaming enemy that does not keep a fixed territory, instead appearing near whatever treasure container was most recently opened anywhere on the map.
It carries the highest luck of any boss on this list, and that stat is not flavour: every attack a wizard lands against it rolls against the wizard's own luck.

**Phases.**
It has no phase transition.
Instead it runs a luck duel: a failed lucky roll on the wizard's attack causes Fortune's Thief to riposte and steal a temporary stack of that wizard's luck advantage, lasting only for the current fight.

**What makes this fight different.**
It is the only boss whose difficulty is directly a function of the engaging wizard's own luck stat, rather than their health, power or gear.
A low-luck wizard can find this fight noticeably harder than its stat block alone would suggest, and a high-luck wizard noticeably easier.

**Drops.**
A Mark-attribute rune as its signature drop, plus the baseline gold, XP and reincarnation points.
Its drop table has the second-highest mana-stone chance on this list, after the Riven Maw, in keeping with its "fortune" theme.

**Group versus solo.**
A group of wizards with mixed luck stats dilutes the duel's bite, since only the luckiest member needs to carry the roll-heavy exchanges.
A solo wizard has no one else's luck to lean on and feels the mechanic in full.

### The Nightfall Reaper

- **Attack type:** magic
- **health:** 5300
- **power:** 345
- **mana pool:** 850
- **magic defence:** 235
- **speed:** 140
- **luck:** 14
- **Season:** Autumn, Winter
- **Where it stands:** the Umbral Wood, a forest that only turns umbral in the two cold seasons

The Nightfall Reaper is an ambush enemy built from shadow, invisible until it lands its first strike, haunting a forest that only exists in its "umbral" state once the year turns cold.
Its design answers kill-stealing directly: it teleports to whichever wizard is currently dealing the most cumulative damage and punishes everyone else nearby with a burst strike.

**Phases.**
Ambush: invisible, waiting, until a wizard triggers it by walking close or attacking blind.
Duel-lock: begins the moment it is struck, during which it repeatedly relocates beside the current top damage-dealer and lashes out at anyone else within range.

**What makes this fight different.**
It is the hardest direct punishment of opportunistic kill-stealing on this list.
Where the Drowned King softly restricts who can land a hit, the Nightfall Reaper actively hurts everyone who is not the wizard actually carrying the fight.

**Drops.**
A Gloom-attribute rune as its signature drop, matching the ambush theme RUNES.md already assigns to that element, plus the baseline gold, XP and reincarnation points.
Its mana-stone chance is standard.

**Group versus solo.**
A loosely organised group that tries to pile on gets repeatedly punished for not committing one clear lead attacker.
A solo wizard, by definition the only damage source, never triggers the bystander punishment and fights it as a straightforward duel.

### The Hollow Choir

- **Attack type:** magic
- **health:** 5700
- **power:** 325
- **mana pool:** 1600
- **magic defence:** 245
- **speed:** 100
- **luck:** 20
- **Season:** Winter
- **Where it stands:** the Frozen Choir, a ring of standing stones that only resonates in winter cold

The Hollow Choir is a chorus of linked enemies occupying a ring of standing stones, singing in a register that only carries once winter's cold has set into the stone.
Rather than fighting purely as a single body, it periodically calls additional champion-tier adds to the fight, and the rate of that summoning rises with the number of wizards currently engaged.

**Phases.**
Add-waves trigger at 75%, 50% and 25% health, each wave's size scaling with how many wizards are present when the threshold is crossed.
The Choir itself does not change its own attack pattern between waves; the escalation is entirely in what it brings with it.

**What makes this fight different.**
It is the sharpest test of coordination on this list rather than raw output.
A controlled group that kills adds on sight barely notices the waves; an uncoordinated crowd that ignores adds to focus the Choir gets quickly overwhelmed by the exact numbers that were supposed to help them.

**Drops.**
A Reprise-attribute rune as its signature drop, plus the baseline gold, XP and reincarnation points, with a bonus reincarnation point award for clearing a wave without losing a wizard.
Its mana-stone chance is elevated, in line with the other winter-only boss on this list.

**Group versus solo.**
A solo wizard faces smaller add-waves, since the scaling is tied to headcount, but still has to split attention between the Choir and its summons alone.
A disciplined group clears this efficiently; an undisciplined one of the same size can lose wizards faster than a smaller, better-organised group would.

## Season scaling

The contract states that season "drives... world boss strength" without specifying a formula, so the multipliers below are a concrete proposal, not a decided system.

**General rule, proposed.**
A world boss that is present across more than one season, or that persists indefinitely, has its `health`, `power` and `magic_defence` multiplied by a compounding seasonal scalar each time the run advances a season while it remains alive:

| Season transition crossed        | Compounding multiplier | Effective multiplier from spring |
| -------------------------------- | ---------------------- | -------------------------------- |
| None (still in its first season) | ×1.00                  | ×1.00                            |
| Into summer                      | ×1.25                  | ×1.25                            |
| Into autumn                      | ×1.25                  | ×1.56                            |
| Into winter                      | ×1.25                  | ×1.95                            |

**Season-locked bosses are exempt.**
The Harrow, the Leaden Saint, the Collector, the Twin Omen, the Riven Maw, Stormcaller Roost, the Drowned King, and the Hollow Choir only ever exist in a single season each, so they never cross a season boundary while alive, and their table stats are their final stats as given.

**Multi-season or persistent bosses use the scalar.**
The Tallyman, the Breach-Warden, Fortune's Thief and the Nightfall Reaper apply the compounding scalar above for every season boundary they survive.

**The Rootbound Colossus stacks an additional, boss-specific scalar.**
On top of the general `+25%` per season, it gains a further `+15%` compounding specifically for surviving a season unkilled, reflecting its unique growth identity, for an effective `+43.75%` compounding per season survived (`1.25 × 1.15`).

⬜ **Open question: does the scalar touch `mana_pool`, `speed` and `luck`?**
The proposal above only scales `health`, `power` and `magic_defence`, matching how the enemy tier table in the contract treats speed as "varies" and keeps luck mostly flat across world bosses.
Whether a boss's mana pool, speed or luck should also grow with the season is undecided, and left out of the proposal above rather than guessed at.

⬜ **Open question: does the scalar apply retroactively to a boss already engaged mid-transition?**
The season boundary falls every 48 hours regardless of whether a fight is in progress.
Whether an in-progress fight snapshots its stats at engagement or re-evaluates them live across a season boundary is not decided.

## Notes for balancing

**The Riven Maw is deliberately the strongest entry, and that is intentional, not a balancing miss.**
At roughly 2.7× a baseline world boss's health and 2× its power, it is meant to require a full group and to signal winter's approach, in the same spirit as the Monolith's own Floor 49 window.

**The Rootbound Colossus is the riskiest number on this list.**
Its compounding growth has no stated upper bound, and left completely unkilled across all four seasons it would reach roughly `1.4375^3 ≈ 2.97×` its base stats on top of its own baseline, which is already a full-weight world boss.
That combination could produce an un-killable enemy on a world where nobody bothers with it, and a hard cap on the number of seasons it can grow through is worth adding before this goes live.

**Luck values deviate further than the tier table's `±25%` guidance for ordinary enemy tiers.**
The contract gives world bosses a flat luck of 15 with no explicit `+` or "may go well above," unlike health, power and magic defence.
Fortune's Thief at luck 30 and the Rootbound Colossus at luck 8 both sit well outside a `±25%` band around that number; they were written for mechanical reasons tied to each boss's identity, but whether the `±25%` discipline is meant to bind world boss luck too is not stated anywhere, and is flagged here rather than assumed.

**The Leaden Saint's immunity is read as immune to one Element, a single rune within the Element attribute, not immune to the whole attribute category.**
Whole-attribute immunity, for example "immune to all Shape runes," does not translate into a coherent combat mechanic the way an elemental immunity does.
⬜ If whole-attribute immunity is the intended reading instead, the Leaden Saint's mechanic needs to be rewritten.

**Drop rates are stated only in relative terms, never as numbers.**
"Elevated," "standard" and "highest on this list" describe intent, not a tuned probability, because the contract gives no baseline mana-stone or life-stone drop rate for any source, world bosses included, only the run-wide target of 3-5 mana-stones and 2-3 life-stones across every source combined.
⬜ Actual percentages need a pass once the other mana-stone and life-stone sources, dungeons, quests, treasure, are all counted, so that a wizard's run-wide total lands in the stated range rather than a world boss alone blowing past it.

**The Twin Omen is likely the single most disruptive design here and should be playtested first.**
Forcibly summoning a wizard's echo mid-session, rather than only while offline, is a new use of an existing mechanic, and whether a decayed echo can actually hold a capital for the full binding-plus-fight duration against a real raiding party is untested.
If it cannot, the boss effectively has no real risk attached to its headline mechanic and becomes a weaker version of every other fight on this list.

**The Collector and Toll-style "punish the strong" bosses assume Artifact count is readable by an enemy AI at engagement.**
Nothing in `GLOSSARY.md` says whether a boss's AI can inspect a wizard's current Artifact holdings the way the Effect rune Toll inspects floor count.
⬜ If that information is not exposed to enemy logic, the Collector's core mechanic needs a different data source or a redesign.
