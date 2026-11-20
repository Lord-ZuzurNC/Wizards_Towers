# Spell VFX — prototype masks

Prototype frame masks for the 21 Shape runes (`RUNES.md`), for Lord to repaint as real pixel
art. Covers Shape only: Shape is the one attribute with geometry (RUNES.md: "it decides what
the magic *is*"); Element only recolours it (see below), and Duration/Effect do not draw
anything of their own yet.

## Folder layout

```
baseline/
  runes/
    bolt/        bolt_1.png   bolt_2.png   bolt_3.png   bolt_4.png
    lance/       lance_1.png  ...
    ...          one folder per Shape, 21 in total
  elements/
    ember_ramp.png   toxin_ramp.png   rime_ramp.png   null_ramp.png
  element_filter.gdshader
```

Every PNG in `runes/` is in **"LA" format**: a grey value (L) plus an alpha channel (A), no
hue. That is deliberate — see *The template + filter technique* below before painting over
them in colour.

## The 21 Shapes

`ART_DIRECTION.md` sets the animation rate: **10 frames a second**, independent of the
game's own frame rate, with 4 to 6 frames for "a spell or attack". These masks follow that:

| Shape | Canvas | Frames | Plays as | What it shows |
| --- | ---: | ---: | --- | --- |
| `bolt` | 16×16 | 4 | loop | a teardrop core with a tapering tail that flickers in length, one spark beside it |
| `lance` | 32×32 | 4 | loop | a spearhead on a long tapering shaft, a bow-wave line either side, a pulse running back along the shaft |
| `spray` | 48×48 | 5 | one-shot | a bright burst at the hand, then fragments fanning out in a cone, dimming and thinning with distance |
| `slash` | 32×32 | 5 | one-shot | a curved blade sweeping through an arc in front of the caster, with a fading trail |
| `beam` | 16×16 | 3 + 3 + 3 | start / loop / end | see below — tile it along the beam's length |
| `nova` | 64×64 | 6 | one-shot | a compressed flash at the caster, a ring expanding with a fainter ring behind it, breaking into specks at the edge |
| `orb` | 32×32 | 4 + 4 | loop / end | see below |
| `seed` | 16×16 | 3 | loop | a small ringed mark with a centre dot and four ticks, breathing slowly while it waits to trigger |
| `footprints` | 16×16 | 4 | one-shot | one shoe print (sole and heel, pointing up), glowing when fresh, then fading and shrinking |
| `boulder` | 32×32 | 5 + 3 | roll / break | see below |
| `trident` | 48×48 | 5 | one-shot | three barbed prongs thrust out at 0° and ±45°, hold, then fade from base to tip |
| `pool` | 32×32 | 3 + 4 + 3 | start / loop / end | see below |
| `rain` | 16×16 | 5 | one-shot | one falling streak, a flash where it lands, then a flat splash ring and two droplets — stamp it at several points |
| `wall` | 16×16 | 3 + 4 + 3 | start / loop / end | see below — tile it along the wall's width |
| `aura` | 48×48 | 3 + 4 + 3 | start / loop / end | see below |
| `tether` | 16×16 | 4 | loop | two strands twisting around a bright core line, the twist travelling along it — tile it along the line to the target |
| `satellite` | 16×16 | 4 | loop | one orbiting body with a short curved tail along its orbit — the game places and rotates three of it |
| `swarm` | 16×16 | 4 | loop | one small dart with a wriggling homing tail — the game instances several of it |
| `vortex` | 48×48 | 3 + 6 + 3 | start / loop / end | see below |
| `judgement` | 64×64 | 3 + 4 | telegraph / strike | see below |
| `bombardment` | 32×32 | 6 | one-shot | one mass falling with a trail, an impact flash, a flat blast ring with debris, then smoke over a scorch mark — the game stamps several across the area |

Canvas sizes are multiples of the 16×16 tile (`ART_DIRECTION.md`) so a Shape lines up with
the grid it is cast on. **"loop"** plays its frames on repeat for as long as the spell is
active (Instant spells still show it once before vanishing); **"one-shot"** plays once and
the spell is gone. Directional Shapes (`bolt`, `lance`, `spray`, `slash`, `trident`, `swarm`,
`satellite`'s tail) are drawn travelling right; the game rotates them to the aim.

**Five Shapes are drawn once but appear many times on screen**, because the *game* instances
or stamps the one clip rather than the art containing every copy:

- `footprints` — one print, fading; the wizard's path leaves a trail of them.
- `satellite` — one orbiting body; the game places and rotates three of it.
- `swarm` — one homing fragment; the game instances and aims several.
- `rain`, `bombardment` — one falling strike and its impact; the game stamps several
  across the target area at slightly offset times.

Judge each of those by what a *single* copy should look like, not the full effect.

**`beam`, `wall` and `tether` are tileable segments**, not a fixed-length sprite: Beam's
length depends on range, a Wall's on where it's cast, a Tether's on the distance to its
target. Repeat the segment along a `Line2D` or a stretched `Sprite2D` rather than scaling
one image.

## The template + filter technique

**Don't paint the Shape pink. Paint it in grey.**

The instinct behind "draw in an unused colour, then filter it" is right, but a straight
colour filter (multiplying by red, or green) muddies whatever hue you drew in — magenta
multiplied by orange loses most of its green and blue data and comes out dull, not fiery.

The classic pixel-art fix is a **gradient map**: draw the Shape's *shading* only — how dark
or bright each pixel is, nothing about colour — then let a shader turn that brightness into
colour using a small reference strip, one per Element. Painting in grey is the natural way
to think in pure shading: black is shadow, white is a highlight, nothing in between carries
a colour.

**In practice:**

1. **Paint each frame in greyscale**, alpha for the silhouette, exactly like the prototype
   masks here: darkest where the effect is dim or in shadow, brightest at its hottest,
   sharpest point.
2. **Export as PNG with an alpha channel** — Godot reads grey + alpha as a normal texture
   (R, G and B all equal the grey value), so no special import step is needed.
3. **One ramp texture per Element**: a strip a few pixels wide, one pixel tall, going from
   the Element's darkest BLK NX64 colour to its brightest. `elements/` has four examples
   built this way — Ember (fire), Toxin (poison), Rime (ice) and Null (the neutral,
   "nothing resists it" element) — as a pattern to copy for the other ten.
4. **`element_filter.gdshader`** samples the ramp at the mask's grey value, and keeps the
   mask's own alpha. Put it on the `AnimatedSprite2D`'s material and swap only the `ramp`
   uniform to reskin the same 21 Shape animations across all 14 Elements — 21 drawn once,
   not 21 × 14 drawn by hand.

**One tuning note from the four example ramps:** keep a ramp's brightest stop within the
range your mask actually reaches. These masks peak around grey 235 of 255, not white; a
ramp whose top stop sits at pure white (as Null's does) reads a little dim next to one
whose brightest stop is closer to that 235 ceiling (as Ember's is). Match the two, or the
same spell will look duller in one Element than another for no in-fiction reason.

## In Godot

- One `SpriteFrames` resource per Shape, named after it (`bolt`, `lance`, ...), built from
  its numbered PNGs in order, at **10 FPS**, looping or not per the table above.
- One `AnimatedSprite2D` per cast spell, its `SpriteFrames` chosen by the spell's Shape rune,
  a `ShaderMaterial` using `element_filter.gdshader` chosen by its Element rune.
- Durations and Effects do not have their own art yet; TECH_STACK.md and RUNES.md don't
  describe one, so none is assumed here (⬜ for a later pass, once Shape and Element read
  clearly on their own).


## Revised since the first pass

Three Shapes needed more than one simple pulse to read right, and the character canvas
decision (32 × 32, `ART_DIRECTION.md`) came after this folder was first laid out:

- **`slash`** now sweeps a real curved blade — not a flat wedge — through its arc, with a
  short fading trail behind it, 5 frames, one-shot.
- **`beam`** and **`judgement`** needed more than one loop to tell their story, so they
  introduce a **multi-phase naming convention**: `<shape>_<phase>_<frame>.png`.
  - `beam`: `beam_start_1..3` (a thin bright ray, a dip as it winds up, then widening),
    `beam_loop_1..3` (the full laser, looping while held), `beam_end_1..3` (it collapses,
    leaving a couple of quick bright sparks that die out fast). 9 frames, canvas still 16.
  - `judgement`: `judgement_telegraph_1..3` (a thin ray down from the sky, pulsing — the
    warning) and `judgement_strike_1..4` (the ray holds, then all at once widens into a
    cross: a tall vertical beam crossed by a short horizontal bar, peak brightness, then
    fades). 7 frames, canvas 64.
  - In Godot, build one `SpriteFrames` **animation per phase** (`beam_start`, `beam_loop`,
    `beam_end`...), not one animation spanning all of them — play `start`, loop `loop` for
    as long as the spell is held, then play `end` once it releases.
  - A single-phase Shape (`bolt`, `nova`, ...) keeps the plain `<shape>_<frame>.png` naming
    from before: no phase prefix needed when there is only one phase.

### Second pass: the other 18 Shapes

Every remaining Shape was redrawn with more than one pulse. A Shape is split into phases
only where the game holds part of it for a length the game decides — the spell's Duration,
the distance travelled, the moment something touches it — so that part has to loop, or be
cut short, on its own. Shapes whose beats always play back to back in full (`nova`,
`trident`, `spray`, `rain`, `bombardment`, `footprints`) stay a single one-shot with the
beginning, middle and end inside it.

Held for a Duration — `start` once, `loop` while the spell lasts, `end` once:

- `aura`: `aura_start_1..3` (a ring flashes out from the caster to its full radius),
  `aura_loop_1..4` (the ring pulses gently, four motes circle on it, a soft glow inside),
  `aura_end_1..3` (the ring contracts and fades, the motes drawn in). 10 frames.
- `pool`: `pool_start_1..3` (a bright splash spreads into a round patch),
  `pool_loop_1..4` (two ripples expanding from the centre, half a cycle apart, and a
  bubble), `pool_end_1..3` (the patch shrinks, darkens and fades). 10 frames.
- `wall`: `wall_start_1..3` (a column rises out of a glow along the ground),
  `wall_loop_1..4` (the column at full height, bright flecks climbing it),
  `wall_end_1..3` (it sinks back into the ground glow). 10 frames. The ground glow runs
  edge to edge so tiles join along the base.
- `vortex`: `vortex_start_1..3` (three spiral arms unfurl from the centre),
  `vortex_loop_1..6` (the arms turn, each carrying one body inward to a bright eye),
  `vortex_end_1..3` (the arms wind into the centre and end in a single flash). 12 frames.

Ended by contact or travel — the first phase plays until the game cuts to the second:

- `orb`: `orb_loop_1..4` (a soft sphere with a wobbling highlight and two motes circling
  it, looping while it drifts), `orb_end_1..4` (it swells, bursts into a ring, six
  fragments fly outward and fade). Play `end` on contact or expiry. 8 frames.
- `boulder`: `boulder_roll_1..5` (a cracked sphere rolling and shrinking, the cracks
  turning with it, shedding dust and chips behind), `boulder_break_1..3` (cracks open
  across it, it splits into four chunks, the chunks scatter and fade). Play `break` when
  the roll ends or it stops against a building. 8 frames.

Single phase, redrawn: `bolt`, `lance`, `spray`, `nova`, `trident` (now 5 frames and
one-shot, not a loop: the three strikes are instant), `bombardment` (now 6 frames: fall,
fall, impact, blast ring, smoke, scorch), and the small stamps `seed`, `footprints`,
`rain`, `satellite`, `swarm`, `tether`, which keep their old frame counts and only gained
silhouette detail — see the table above for each.

`<shape>_start` / `<shape>_loop` / `<shape>_end` are named the same across every held
Shape, so one piece of game code can drive all of them.

## Characters

`baseline/characters/wizard/` — a schematic silhouette of the default wizard, **32 × 32**,
top-down three-quarter (`ART_DIRECTION.md`): a round head, a pointed hat (a flat brim and a
tall cone bent slightly to one side), a tapering robe, one casting arm. It is a
pose-and-timing reference only — proportions are a placeholder. The hat tip and the robe's
hem trail the body's own motion by about a frame: when the body dips, sways or leans, they
follow a beat later.

| Action | Frames | Plays as | What it shows |
| --- | ---: | --- | --- |
| `standing` | 3 | loop | an idle breathing bob, the hat tip dipping a frame after the body |
| `walk` | 6 | loop | a side-to-side sway, like a glide; the hem swings a quarter-step behind the body, the hat tip a little less |
| `cast` | 5 | one-shot | a small crouch, the arm raises with the body leaning into it, a glow builds at the wand's tip, then eases back; the hat tip and hem catch up on the way down |
| `grimoire` | 4 | one-shot | a book appears in front of the chest and opens, the wizard bowing slightly over it |

`baseline/characters/wand/wand_1.png` — a single static reference, no animation: a plain,
straight wooden rod with a gentle taper, a rounded tip and butt, and one faint grain line, the wizard's default weapon (`WEAPONS.md`).
Scale it to the hand in whichever pose it's held; it does not need to be redrawn per pose.
