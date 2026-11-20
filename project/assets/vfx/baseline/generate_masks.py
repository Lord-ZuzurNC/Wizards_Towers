"""
VFX mask + character baseline generator — Wizards Towers.

Pure PIL (no numpy in the sandbox). Produces grayscale+alpha ("LA") prototype masks under
assets/vfx/baseline/, per the conventions in assets/vfx/baseline/README.md:

- One folder per Shape rune (RUNES.md) under runes/<shape>/.
- Simple shapes: flat numbering <shape>_<frame>.png.
- Multi-phase shapes (build-up / hold / release, or telegraph / strike): prefix the phase,
  <shape>_<phase>_<frame>.png, each phase its own Godot SpriteFrames animation.
- Canvas sizes are multiples of the 16px tile (ART_DIRECTION.md); animation is 10 FPS,
  4-6 frames for "a spell or attack", more only when a shape genuinely has several beats.
- Characters: assets/vfx/baseline/characters/wizard/<action>_<frame>.png, 32x32
  (ART_DIRECTION.md pins the character canvas at 32x32), and characters/wand/wand_1.png.

Every run deletes the PNGs it owns first, then any Godot .import sidecar left without its
PNG (a frame that was renamed or dropped), so the folders always match this script.

Run with: python3 generate_masks.py
"""
import os, math, random
from PIL import Image, ImageChops, ImageDraw, ImageFilter

ROOT = os.path.dirname(os.path.abspath(__file__))
RUNES_DIR = os.path.join(ROOT, "runes")
CHAR_DIR = os.path.join(ROOT, "characters")
SS = 4  # supersample factor; downsampled with LANCZOS at the end for smooth prototype edges


# ---------------------------------------------------------------------------
# Low-level LA (luminance + alpha) primitives.
# L = shading value (dark=shadow, bright=highlight) for the Godot gradient-map shader.
# A = silhouette opacity.
# ---------------------------------------------------------------------------

def new_canvas(size_ss):
    return Image.new("LA", (size_ss, size_ss), (0, 0))

def blob(size_ss, cx, cy, r, value=235, blur_frac=0.45):
    im = new_canvas(size_ss)
    ImageDraw.Draw(im).ellipse([cx - r, cy - r, cx + r, cy + r], fill=(int(value), 255))
    return im.filter(ImageFilter.GaussianBlur(max(1.0, r * blur_frac)))

def ring(size_ss, cx, cy, r, thickness, value=225, blur=1.5, squash=1.0):
    """squash < 1 flattens the ring vertically: a ground ring seen in three-quarter view."""
    im = new_canvas(size_ss)
    ry = r * squash
    ImageDraw.Draw(im).ellipse(
        [cx - r, cy - ry, cx + r, cy + ry], outline=(int(value), 255), width=max(1, int(thickness))
    )
    return im.filter(ImageFilter.GaussianBlur(blur))

def wedge(size_ss, cx, cy, r, angle_center, angle_width, value=235, blur_frac=0.06):
    im = new_canvas(size_ss)
    start, end = angle_center - angle_width / 2, angle_center + angle_width / 2
    ImageDraw.Draw(im).pieslice([cx - r, cy - r, cx + r, cy + r], start, end, fill=(int(value), 255))
    return im.filter(ImageFilter.GaussianBlur(max(1.0, r * blur_frac)))

def segment(size_ss, x0, y0, x1, y1, width, value=235, blur_frac=0.4):
    im = new_canvas(size_ss)
    d = ImageDraw.Draw(im)
    v, w = int(value), max(1, int(width))
    d.line([x0, y0, x1, y1], fill=(v, 255), width=w)
    d.ellipse([x0 - w / 2, y0 - w / 2, x0 + w / 2, y0 + w / 2], fill=(v, 255))
    d.ellipse([x1 - w / 2, y1 - w / 2, x1 + w / 2, y1 + w / 2], fill=(v, 255))
    return im.filter(ImageFilter.GaussianBlur(max(1.0, w * blur_frac)))

def stroke(size_ss, path, w0, w1=None, v0=235, v1=None, blur_frac=0.3):
    """A tapered stroke along a polyline: discs stamped along the path, width and grey
    interpolated from the first point (w0, v0) to the last (w1, v1). Used for comet tails,
    curved trails and spiral arms, which segment() draws only at a constant width."""
    w1 = w0 if w1 is None else w1
    v1 = v0 if v1 is None else v1
    lens = [0.0]
    for (xa, ya), (xb, yb) in zip(path, path[1:]):
        lens.append(lens[-1] + math.hypot(xb - xa, yb - ya))
    total = lens[-1]
    steps = max(1, int(total / max(1.0, min(w0, w1) / 3)))
    im = new_canvas(size_ss)
    d = ImageDraw.Draw(im)
    k = 0
    for j in range(steps + 1):
        s = total * j / steps
        while k < len(path) - 2 and lens[k + 1] < s:
            k += 1
        f = (s - lens[k]) / ((lens[k + 1] - lens[k]) or 1.0)
        x = path[k][0] + (path[k + 1][0] - path[k][0]) * f
        y = path[k][1] + (path[k + 1][1] - path[k][1]) * f
        u = j / steps
        w = max(1.0, w0 + (w1 - w0) * u)
        d.ellipse([x - w / 2, y - w / 2, x + w / 2, y + w / 2], fill=(int(v0 + (v1 - v0) * u), 255))
    return im.filter(ImageFilter.GaussianBlur(max(1.0, (w0 + w1) / 2 * blur_frac)))

def spiral_path(cx, cy, r0, r1, a0, a1, samples=48):
    """Points from radius r0 at angle a0 to radius r1 at angle a1 (degrees, PIL's clockwise
    convention). r0 == r1 gives a plain arc."""
    pts = []
    for k in range(samples + 1):
        t = k / samples
        a = math.radians(a0 + (a1 - a0) * t)
        r = r0 + (r1 - r0) * t
        pts.append((cx + r * math.cos(a), cy + r * math.sin(a)))
    return pts

def curved_blade_polygon(cx, cy, radius, angle_from, angle_to, width_peak, samples=24):
    pts_outer, pts_inner = [], []
    for k in range(samples + 1):
        t = k / samples
        ang = math.radians(angle_from + (angle_to - angle_from) * t)
        w = width_peak * math.sin(math.pi * t)
        bx, by = cx + radius * math.cos(ang), cy + radius * math.sin(ang)
        tx, ty = -math.sin(ang), math.cos(ang)
        pts_outer.append((bx + tx * w / 2, by + ty * w / 2))
        pts_inner.append((bx - tx * w / 2, by - ty * w / 2))
    return pts_outer + pts_inner[::-1]

def curved_blade(size_ss, cx, cy, radius, angle_from, angle_to, width_peak, value=235, blur_frac=0.05):
    im = new_canvas(size_ss)
    ImageDraw.Draw(im).polygon(
        curved_blade_polygon(cx, cy, radius, angle_from, angle_to, width_peak), fill=(int(value), 255)
    )
    return im.filter(ImageFilter.GaussianBlur(max(1.0, width_peak * blur_frac)))

def poly_la(size_ss, pts, value=220):
    im = new_canvas(size_ss)
    ImageDraw.Draw(im).polygon(pts, fill=(int(value), 255))
    return im

def ellipse_la(size_ss, box, value=220):
    im = new_canvas(size_ss)
    ImageDraw.Draw(im).ellipse(box, fill=(int(value), 255))
    return im

def fade_alpha(im, factor):
    l, a = im.split()
    return Image.merge("LA", (l, a.point(lambda v: int(v * factor))))

def clip_to(im, mask):
    """Keep im only where mask is opaque: surface detail (cracks, highlights) that must not
    spill past a body's silhouette."""
    l, a = im.split()
    return Image.merge("LA", (l, ImageChops.multiply(a, mask.split()[1])))

def composite(layers):
    """'Lighten'-style glow stacking: good for VFX (additive feel)."""
    out = layers[0]
    for layer in layers[1:]:
        lo = out.convert("L"); ao = out.split()[1]
        li = layer.convert("L"); ai = layer.split()[1]
        out_rgba = Image.alpha_composite(Image.merge("RGBA", (lo, lo, lo, ao)),
                                          Image.merge("RGBA", (li, li, li, ai)))
        l, _, _, a = out_rgba.split()
        out = Image.merge("LA", (l, a))
    return out

def stack(layers):
    """Painter's algorithm: later layers drawn fully on top (opaque where they cover)."""
    return composite(layers)

def finalize(im_ss, size):
    return im_ss.resize((size, size), Image.LANCZOS)

def finalize_rect(im_ss, w, h):
    return im_ss.resize((w, h), Image.LANCZOS)

def polar(cx, cy, r, deg):
    a = math.radians(deg)
    return cx + r * math.cos(a), cy + r * math.sin(a)


# ---------------------------------------------------------------------------
# Shape registry. Each entry: canvas (px), a list of phases (name, frame_count), and a
# generator gen(ss, frame_index, frame_count, phase_name) -> LA image at supersampled size.
# A single-phase shape uses phases=[("", n)] and its files have no phase in the name.
#
# When a phase split is used: a Shape gets phases only when the game holds part of it for
# a length it decides (Duration, travel, a delay), so that part must loop or stop early on
# its own. A one-shot whose beats always play back to back stays a single phase.
# Directional shapes are drawn travelling right (+x); the game rotates them to the aim.
# ---------------------------------------------------------------------------

SHAPES = {}

def add(shape_id, canvas, phases, note, gen):
    SHAPES[shape_id] = dict(canvas=canvas, phases=phases, note=note, gen=gen)


# --- first pass, unchanged ---

def g_slash(ss, i, n, phase):
    cx, cy = ss * 0.15, ss * 0.5
    radius = ss * 0.65
    sweep_from, sweep_to = -55, 55
    now = sweep_from + (sweep_to - sweep_from) * (i / (n - 1))
    layers = []
    for s in range(3, -1, -1):
        a = now - s * 10
        if a < sweep_from - 2:
            continue
        fade = 1.0 - s / 4.0
        layers.append(fade_alpha(curved_blade(ss, cx, cy, radius, a - 18, a + 18, ss * 0.16), fade))
    return composite(layers)
add("slash", 32, [("", 5)], "a curved blade sweeping through an arc, with a fading trail", g_slash)

def g_beam(ss, i, n, phase):
    y = ss / 2
    if phase == "start":
        beats = [dict(width=0.10, value=245), dict(width=0.10, value=120), dict(width=0.55, value=250)]
        b = beats[min(i, len(beats) - 1)]
        return segment(ss, 0, y, ss, y, width=ss * b["width"], value=b["value"], blur_frac=0.3)
    if phase == "loop":
        t = i / n
        width = ss * 0.75 + ss * 0.08 * math.sin(2 * math.pi * t)
        return segment(ss, 0, y, ss, y, width=width, value=250, blur_frac=0.22)
    if phase == "end":
        t = i / max(1, n - 1)
        width = ss * 0.75 * (1 - t)
        beam = fade_alpha(segment(ss, 0, y, ss, y, width=max(1, width), value=230, blur_frac=0.3), max(0.0, 1 - t * 1.1))
        layers = [beam]
        random.seed(100 + i)
        for _ in range(max(0, int(5 * (1 - t)))):
            sx, sy = random.uniform(0, ss), y + random.uniform(-ss * 0.15, ss * 0.15)
            layers.append(fade_alpha(blob(ss, sx, sy, ss * 0.025, value=245, blur_frac=0.9), max(0.0, 1 - t)))
        return composite(layers)
add("beam", 16, [("start", 3), ("loop", 3), ("end", 3)],
    "thin bright ray -> dims (windup) -> wide laser, looping -> fades leaving quick sparks", g_beam)

def g_judgement(ss, i, n, phase):
    cx, cy = ss / 2, ss / 2
    if phase == "telegraph":
        t = i / max(1, n - 1)
        pulse = 160 + 50 * math.sin(2 * math.pi * t * 2)
        return composite([segment(ss, cx, 0, cx, ss, width=ss * 0.05, value=pulse, blur_frac=0.5),
                           ring(ss, cx, cy, ss * 0.12, ss * 0.02, value=pulse)])
    if phase == "strike":
        beats = [dict(vw=0.05, bar=0.0, value=250), dict(vw=0.5, bar=0.65, value=255),
                 dict(vw=0.5, bar=0.65, value=200), dict(vw=0.3, bar=0.35, value=110)]
        b = beats[min(i, len(beats) - 1)]
        vertical = segment(ss, cx, 0, cx, ss, width=ss * b["vw"], value=b["value"], blur_frac=0.18)
        if b["bar"] <= 0:
            return vertical
        bw = ss * b["bar"]
        horizontal = segment(ss, cx - bw / 2, cy, cx + bw / 2, cy, width=ss * 0.16, value=b["value"], blur_frac=0.2)
        return composite([vertical, horizontal])
add("judgement", 64, [("telegraph", 3), ("strike", 4)],
    "a thin ray from the sky, telegraphed, then a sudden cross-shaped strike", g_judgement)


# --- projectiles ---

def g_bolt(ss, i, n, phase):
    cy, hx = ss / 2, ss * 0.64
    t = i / n
    tail_x = ss * (0.06 + 0.06 * (i % 2))
    tail = stroke(ss, [(tail_x, cy), (hx, cy)], ss * 0.05, ss * 0.30, 130, 220, blur_frac=0.25)
    rng = random.Random(10 + i)
    spark = blob(ss, ss * rng.uniform(0.12, 0.42), cy + ss * rng.uniform(-0.14, 0.14), ss * 0.04, 240, 0.8)
    core = blob(ss, hx, cy, ss * (0.15 + 0.02 * math.sin(2 * math.pi * t)), 248, 0.4)
    return composite([tail, fade_alpha(spark, 0.8), core])
add("bolt", 16, [("", 4)], "teardrop core with a tapering tail that flickers in length, one spark", g_bolt)

def g_lance(ss, i, n, phase):
    cy, tip, base = ss / 2, ss * 0.92, ss * 0.66
    t = i / n
    shaft = stroke(ss, [(ss * 0.04, cy), (base + ss * 0.02, cy)], ss * 0.03, ss * 0.10, 120, 215)
    layers = [shaft]
    for side in (-1, 1):
        wake_end = base - ss * (0.30 + 0.04 * (i % 2))
        wake = stroke(ss, [(wake_end, cy + side * ss * 0.16), (base, cy + side * ss * 0.05)],
                      ss * 0.01, ss * 0.03, 100, 180)
        layers.append(fade_alpha(wake, 0.65))
    pulse_x = base - ss * 0.56 * t
    layers.append(fade_alpha(blob(ss, pulse_x, cy, ss * 0.05, 240, 0.6), 0.8))
    layers.append(blob(ss, base, cy, ss * (0.08 + 0.015 * math.sin(2 * math.pi * t)), 245, 0.6))
    layers.append(wedge(ss, tip, cy, tip - base, 180, 34, value=248, blur_frac=0.03))
    return composite(layers)
add("lance", 32, [("", 4)],
    "a spearhead on a long tapering shaft, a bow-wave either side, a pulse running back along it", g_lance)

def g_orb(ss, i, n, phase):
    c = ss / 2
    if phase == "loop":
        t = i / n
        r = ss * (0.22 + 0.015 * math.sin(2 * math.pi * t))
        layers = [blob(ss, c, c, r, 195, 0.4),
                  blob(ss, c - ss * 0.05, c - ss * 0.05 + ss * 0.01 * math.sin(2 * math.pi * t), ss * 0.09, 245, 0.5)]
        for k in range(2):
            mx, my = polar(c, c, ss * 0.30, 360 * t + 180 * k)
            layers.append(fade_alpha(blob(ss, mx, my, ss * 0.03, 230, 0.6), 0.7))
        return composite(layers)
    if phase == "end":
        beats = [dict(core=0.28, cv=250, ring=0.0, frag=0.0, a=1.0),
                 dict(core=0.16, cv=250, ring=0.30, frag=0.30, a=1.0),
                 dict(core=0.08, cv=220, ring=0.40, frag=0.40, a=0.75),
                 dict(core=0.0, cv=0, ring=0.46, frag=0.47, a=0.35)]
        b = beats[min(i, len(beats) - 1)]
        layers = []
        if b["core"]:
            layers.append(blob(ss, c, c, ss * b["core"], b["cv"], 0.35))
        if b["ring"]:
            layers.append(fade_alpha(ring(ss, c, c, ss * b["ring"], ss * 0.04 * b["a"] + 2, 235, blur=ss * 0.01), b["a"]))
        if b["frag"]:
            for k in range(6):
                fx, fy = polar(c, c, ss * b["frag"], k * 60 + 25)
                layers.append(fade_alpha(blob(ss, fx, fy, ss * 0.035, 240, 0.6), b["a"]))
        return composite(layers)
add("orb", 32, [("loop", 4), ("end", 4)],
    "a soft sphere with a wobbling highlight and two motes, looping -> swells and bursts into a ring of fragments", g_orb)

def boulder_body(ss, cx, cy, r, rot):
    body = ellipse_la(ss, [cx - r, cy - r, cx + r, cy + r], 160).filter(ImageFilter.GaussianBlur(ss * 0.006))
    detail = [fade_alpha(blob(ss, cx - r * 0.35, cy - r * 0.35, r * 0.45, 215, 0.6), 0.8),
              fade_alpha(blob(ss, cx + r * 0.45, cy + r * 0.45, r * 0.5, 110, 0.6), 0.6)]
    for da, reach in ((0, 0.85), (115, 0.65), (235, 0.75)):
        x0, y0 = polar(cx, cy, r * 0.15, rot + da)
        x1, y1 = polar(cx, cy, r * reach, rot + da + 25)
        detail.append(segment(ss, x0, y0, x1, y1, max(2, r * 0.08), 90, 0.2))
    return composite([body, clip_to(composite(detail), body)])

def g_boulder(ss, i, n, phase):
    c = ss / 2
    if phase == "roll":
        t = i / (n - 1)
        r = ss * 0.40 * (1 - 0.5 * t)
        layers = []
        for k in range(3):
            dx = c - r - ss * (0.06 + 0.09 * k)
            layers.append(fade_alpha(blob(ss, dx, c + r * 0.8, ss * (0.05 - 0.01 * k), 130, 0.7), 0.5 - 0.12 * k))
        if t > 0.3:
            rng = random.Random(40 + i)
            for _ in range(2):
                layers.append(blob(ss, c - r - ss * rng.uniform(0.03, 0.12), c + r * rng.uniform(-0.2, 0.7),
                                   ss * 0.025, 150, 0.3))
        layers.append(boulder_body(ss, c, c, r, 70 * i))
        return composite(layers)
    if phase == "break":
        r = ss * 0.30
        if i == 0:
            body = boulder_body(ss, c, c, r, 0)
            cracks = composite([segment(ss, *polar(c, c, r * 0.9, a), *polar(c, c, r * 0.9, a + 180), ss * 0.025, 70, 0.2)
                                for a in (20, 110)])
            return composite([body, clip_to(cracks, body)])
        beats = [None, dict(off=0.40, size=0.80, a=1.0, dust=0.30), dict(off=0.95, size=0.45, a=0.5, dust=0.42)]
        b = beats[min(i, len(beats) - 1)]
        layers = [fade_alpha(blob(ss, c, c + r * 0.4, ss * b["dust"], 120, 0.6), 0.45 * b["a"])]
        for k in range(4):
            mid = 65 + 90 * k
            px, py = polar(c, c, r * b["off"], mid)
            layers.append(fade_alpha(wedge(ss, px, py, r * b["size"], mid, 80, 160, 0.04), b["a"]))
        return composite(layers)
add("boulder", 32, [("roll", 5), ("break", 3)],
    "a cracked sphere rolling and shrinking, shedding chips and dust -> splits into four chunks that scatter", g_boulder)

def g_trident(ss, i, n, phase):
    ox, oy = ss * 0.08, ss / 2
    beats = [dict(ext=0.20, tail=0.00, v=250, a=1.0, flash=0.11),
             dict(ext=0.55, tail=0.00, v=245, a=1.0, flash=0.06),
             dict(ext=1.00, tail=0.00, v=240, a=1.0, flash=0.0),
             dict(ext=1.00, tail=0.50, v=215, a=0.85, flash=0.0),
             dict(ext=1.00, tail=0.85, v=170, a=0.45, flash=0.0)]
    b = beats[min(i, len(beats) - 1)]
    head = ss * 0.11
    layers = []
    for ang, reach in ((0, 0.86), (-45, 0.62), (45, 0.62)):
        L = ss * reach * b["ext"]
        tip = polar(ox, oy, L, ang)
        start = polar(ox, oy, L * b["tail"], ang)
        neck = polar(ox, oy, max(L * b["tail"], L - head * 0.8), ang)
        prong = [stroke(ss, [start, neck], ss * 0.03, ss * 0.05, b["v"] - 70, b["v"] - 20),
                 wedge(ss, tip[0], tip[1], min(head, L), ang + 180, 40, b["v"], 0.03)]
        layers.append(fade_alpha(composite(prong), b["a"]))
    if b["flash"]:
        layers.append(blob(ss, ox, oy, ss * b["flash"], 250, 0.5))
    return composite(layers)
add("trident", 48, [("", 5)],
    "three barbed prongs thrust out at 0 and +/-45 degrees, hold, then fade from base to tip", g_trident)

def g_spray(ss, i, n, phase):
    ox, oy = ss * 0.06, ss / 2
    t = i / (n - 1)
    reach = ss * (0.15 + 0.78 * t)
    layers = []
    if 0 < t < 1:
        layers.append(fade_alpha(wedge(ss, ox, oy, reach, 0, 70, value=120, blur_frac=0.06), 0.3 * (1 - t)))
    if i <= 1:
        layers.append(wedge(ss, ox, oy, ss * (0.16 + 0.10 * i), 0, 60, value=245 - 30 * i, blur_frac=0.08))
    rng = random.Random(7)
    for _ in range(16):
        a, sp, sz = math.radians(rng.uniform(-33, 33)), rng.uniform(0.6, 1.0), rng.uniform(0.025, 0.045)
        d = reach * sp
        x, y = ox + d * math.cos(a), oy + d * math.sin(a)
        L = ss * 0.08 * (1 - 0.5 * t)
        v = 240 - 90 * t
        frag = stroke(ss, [(x - L * math.cos(a), y - L * math.sin(a)), (x, y)], ss * sz * 0.4, ss * sz, v * 0.7, v, 0.4)
        layers.append(fade_alpha(frag, max(0.0, 1 - 0.9 * t ** 1.3)))
    return composite(layers)
add("spray", 48, [("", 5)],
    "a bright burst at the caster's hand, then fragments fanning out, dimming and thinning with distance", g_spray)

def g_swarm(ss, i, n, phase):
    cy, hx = ss / 2, ss * 0.68
    t = i / n
    path = []
    for k in range(13):
        u = k / 12
        x = ss * 0.10 + (hx - ss * 0.10) * u
        path.append((x, cy + ss * 0.10 * math.sin(2 * math.pi * (u + t)) * (1 - u)))
    return composite([stroke(ss, path, ss * 0.03, ss * 0.16, 110, 215, 0.3),
                      blob(ss, hx, cy, ss * 0.12, 240, 0.4),
                      blob(ss, hx + ss * 0.06, cy, ss * 0.05, 250, 0.5)])
add("swarm", 16, [("", 4)], "one small dart with a wriggling homing tail — the game instances several of it", g_swarm)


# --- self / orbiting ---

def g_nova(ss, i, n, phase):
    c = ss / 2
    beats = [dict(r=0.06, th=0.05, v=250, trail=0.0, core=0.11, ca=1.0, a=1.0),
             dict(r=0.15, th=0.07, v=250, trail=0.5, core=0.08, ca=0.8, a=1.0),
             dict(r=0.25, th=0.06, v=240, trail=0.5, core=0.05, ca=0.5, a=1.0),
             dict(r=0.34, th=0.045, v=225, trail=0.4, core=0.0, ca=0.0, a=1.0),
             dict(r=0.42, th=0.03, v=205, trail=0.3, core=0.0, ca=0.0, a=0.85),
             dict(r=0.47, th=0.015, v=170, trail=0.0, core=0.0, ca=0.0, a=0.35)]
    b = beats[min(i, len(beats) - 1)]
    layers = [fade_alpha(ring(ss, c, c, ss * b["r"], ss * b["th"], b["v"], blur=ss * 0.008), b["a"])]
    if b["trail"]:
        layers.append(fade_alpha(ring(ss, c, c, ss * b["r"] * 0.72, ss * b["th"] * 0.4, b["v"] - 50, blur=ss * 0.01), b["trail"]))
    if b["core"]:
        layers.append(fade_alpha(blob(ss, c, c, ss * b["core"], 250, 0.5), b["ca"]))
    if i == len(beats) - 1:
        for k in range(10):
            layers.append(fade_alpha(blob(ss, *polar(c, c, ss * 0.48, k * 36 + 10), ss * 0.012, 220, 0.8), 0.6))
    return composite(layers)
add("nova", 64, [("", 6)],
    "a compressed flash at the caster, a ring expanding with a fainter ring behind it, breaking into specks at the edge", g_nova)

def aura_frame(ss, r, mote_rot, mote_r, a=1.0, ring_v=215):
    c = ss / 2
    layers = [fade_alpha(blob(ss, c, c, r * 0.55, 130, 0.8), 0.7 * a),
              fade_alpha(ring(ss, c, c, r * 0.75, ss * 0.012, 165, blur=ss * 0.01), 0.5 * a),
              fade_alpha(ring(ss, c, c, r, ss * 0.04, ring_v, blur=ss * 0.01), a)]
    for k in range(4):
        layers.append(fade_alpha(blob(ss, *polar(c, c, mote_r, mote_rot + 90 * k), ss * 0.035, 240, 0.6), a))
    return composite(layers)

def g_aura(ss, i, n, phase):
    if phase == "start":
        r = ss * (0.12, 0.27, 0.40)[min(i, 2)]
        return aura_frame(ss, r, 30 * i, r, ring_v=(250, 235, 215)[min(i, 2)])
    if phase == "loop":
        t = i / n
        r = ss * (0.40 + 0.015 * math.sin(2 * math.pi * t))
        return aura_frame(ss, r, 90 * t, r)
    r = ss * (0.34, 0.24, 0.13)[min(i, 2)]
    return aura_frame(ss, r, -20 * i, r * 0.8, a=(0.8, 0.5, 0.25)[min(i, 2)])
add("aura", 48, [("start", 3), ("loop", 4), ("end", 3)],
    "a ring flashes out from the caster -> holds, pulsing, four motes circling on it -> contracts and fades", g_aura)

def g_satellite(ss, i, n, phase):
    t = i / n
    oc, orad = (ss * 0.5, ss * 1.4), ss * 0.9
    tail_from = -90 - (28 + 4 * (i % 2))
    tail = stroke(ss, spiral_path(oc[0], oc[1], orad, orad, tail_from, -92, 16), ss * 0.03, ss * 0.22, 110, 205)
    r = ss * (0.19 + 0.02 * math.sin(2 * math.pi * t))
    return composite([tail, blob(ss, ss / 2, ss / 2, r, 225, 0.4),
                      blob(ss, ss * 0.45, ss * 0.45, r * 0.45, 250, 0.5)])
add("satellite", 16, [("", 4)],
    "one orbiting body with a short curved tail along its orbit — the game places and rotates three of it", g_satellite)


# --- placed / ground ---

def g_seed(ss, i, n, phase):
    c = ss / 2
    t = i / n
    b = 0.75 + 0.25 * math.sin(2 * math.pi * t)
    layers = [fade_alpha(ring(ss, c, c, ss * 0.22, ss * 0.06, 170, blur=ss * 0.015), 0.6 + 0.4 * b),
              blob(ss, c, c, ss * (0.07 + 0.02 * b), 150 + 80 * b, 0.5)]
    for k in range(4):
        layers.append(fade_alpha(segment(ss, *polar(c, c, ss * 0.33, 90 * k), *polar(c, c, ss * 0.43, 90 * k),
                                         ss * 0.05, 160, 0.3), 0.5 + 0.4 * b))
    return composite(layers)
add("seed", 16, [("", 3)], "a small ringed mark with a dot and four ticks, breathing slowly while it waits", g_seed)

def g_footprints(ss, i, n, phase):
    beats = [dict(v=235, a=1.0, s=1.00), dict(v=205, a=0.75, s=0.97),
             dict(v=180, a=0.45, s=0.93), dict(v=160, a=0.18, s=0.88)]
    b = beats[min(i, len(beats) - 1)]
    c, s = ss / 2, b["s"]
    def box(x0, y0, x1, y1):
        return [c + (x0 - 0.5) * ss * s, c + (y0 - 0.5) * ss * s, c + (x1 - 0.5) * ss * s, c + (y1 - 0.5) * ss * s]
    sole = ellipse_la(ss, box(0.31, 0.12, 0.69, 0.58), b["v"])
    heel = ellipse_la(ss, box(0.35, 0.63, 0.65, 0.90), b["v"])
    layers = [sole.filter(ImageFilter.GaussianBlur(ss * 0.02)), heel.filter(ImageFilter.GaussianBlur(ss * 0.02))]
    if i == 0:
        layers.insert(0, fade_alpha(blob(ss, c, c, ss * 0.36, 160, 0.6), 0.5))
    return fade_alpha(composite(layers), b["a"])
add("footprints", 16, [("", 4)],
    "one shoe print (sole and heel), glowing when fresh, then fading and shrinking — pointing up", g_footprints)

def pool_frame(ss, r, ripple, a=1.0, patch_v=160, bubble_seed=None):
    c = ss / 2
    layers = [fade_alpha(blob(ss, c, c, r, patch_v, 0.3), a),
              fade_alpha(ring(ss, c, c, r * 0.92, ss * 0.025, 205, blur=ss * 0.01), a)]
    for u in ripple:
        layers.append(fade_alpha(ring(ss, c, c, r * (0.15 + 0.65 * u), ss * 0.03, 235, blur=ss * 0.01), a * (1 - 0.7 * u)))
    if bubble_seed is not None:
        rng = random.Random(bubble_seed)
        bx, by = polar(c, c, r * rng.uniform(0.2, 0.6), rng.uniform(0, 360))
        layers.append(fade_alpha(blob(ss, bx, by, ss * 0.03, 245, 0.5), a))
    return composite(layers)

def g_pool(ss, i, n, phase):
    if phase == "start":
        return pool_frame(ss, ss * (0.14, 0.26, 0.36)[min(i, 2)], [0.9], patch_v=(220, 190, 165)[min(i, 2)])
    if phase == "loop":
        t = i / n
        return pool_frame(ss, ss * 0.36, [t, (t + 0.5) % 1], bubble_seed=60 + i)
    beats = [(0.30, 0.8), (0.22, 0.55), (0.13, 0.3)]
    r, a = beats[min(i, 2)]
    return pool_frame(ss, ss * r, [], a=a, patch_v=150 - 20 * i)
add("pool", 32, [("start", 3), ("loop", 4), ("end", 3)],
    "a splash spreading into a round patch -> two ripples and a bubble, looping -> shrinks and fades", g_pool)

def g_rain(ss, i, n, phase):
    cx, ground = ss / 2, ss * 0.86
    if i <= 2:
        head = ss * (0.30, 0.62, 0.84)[i]
        tail = ss * (0.0, 0.28, 0.55)[i]
        layers = [stroke(ss, [(cx, tail), (cx, head)], ss * 0.03, ss * 0.12, 140, 235)]
        if i == 2:
            layers.append(blob(ss, cx, ground, ss * 0.10, 245, 0.5))
        return composite(layers)
    spread, a = (0.22, 1.0) if i == 3 else (0.32, 0.5)
    layers = [fade_alpha(ring(ss, cx, ground, ss * (spread + 0.06), ss * 0.04, 215, blur=ss * 0.02, squash=0.3), a)]
    if i == 3:
        layers.append(ellipse_la(ss, [cx - ss * 0.16, ground - ss * 0.05, cx + ss * 0.16, ground + ss * 0.05], 225)
                      .filter(ImageFilter.GaussianBlur(ss * 0.02)))
    for side in (-1, 1):
        layers.append(fade_alpha(blob(ss, cx + side * ss * spread, ground - ss * (0.20 if i == 3 else 0.12),
                                      ss * 0.05, 235, 0.5), a))
    return composite(layers)
add("rain", 16, [("", 5)],
    "one falling streak, a flash where it lands, then a flat splash ring and two droplets — stamp it at several points", g_rain)

def wall_frame(ss, top, i, a=1.0, base_v=150):
    cx = ss / 2
    layers = [fade_alpha(segment(ss, -ss * 0.2, ss * 0.94, ss * 1.2, ss * 0.94, ss * 0.14, base_v, 0.4), a)]
    if top < ss * 0.9:
        layers.append(fade_alpha(stroke(ss, [(cx, ss * 0.98), (cx, top)], ss * 0.55, ss * 0.30, 185, 235, 0.25), a))
        for k in range(2):
            y = ss * 0.98 - (ss * 0.98 - top) * (((i / 4) + k / 2) % 1)
            layers.append(fade_alpha(blob(ss, cx + ss * 0.08 * (-1) ** k, y, ss * 0.06, 250, 0.5), a))
    return composite(layers)

def g_wall(ss, i, n, phase):
    if phase == "start":
        return wall_frame(ss, ss * (0.86, 0.50, 0.08)[min(i, 2)], i)
    if phase == "loop":
        return wall_frame(ss, ss * (0.08 + 0.03 * math.sin(2 * math.pi * i / n)), i)
    beats = [(0.35, 0.85), (0.65, 0.55), (0.95, 0.30)]
    top, a = beats[min(i, 2)]
    return wall_frame(ss, ss * top, i, a=a)
add("wall", 16, [("start", 3), ("loop", 4), ("end", 3)],
    "a column rising from a ground glow -> holds, bright flecks climbing it -> sinks back into the glow", g_wall)

def vortex_frame(ss, rot, r_out, a=1.0, bodies=()):
    c = ss / 2
    inner = ss * 0.04
    layers = [fade_alpha(ring(ss, c, c, r_out, ss * 0.02, 150, blur=ss * 0.01), 0.6 * a)]
    for k in range(3):
        a0 = rot + 120 * k
        arm = stroke(ss, spiral_path(c, c, r_out, inner, a0, a0 + 270), ss * 0.02, ss * 0.06, 130, 235)
        layers.append(fade_alpha(arm, a))
    for k, u in bodies:
        a0 = rot + 120 * k
        layers.append(fade_alpha(blob(ss, *polar(c, c, r_out + (inner - r_out) * u, a0 + 270 * u), ss * 0.035, 245, 0.5),
                                 a * (1 - 0.3 * u)))
    layers.append(fade_alpha(blob(ss, c, c, ss * 0.07, 240, 0.5), a))
    return composite(layers)

def g_vortex(ss, i, n, phase):
    if phase == "start":
        return vortex_frame(ss, 40 * i, ss * (0.14, 0.28, 0.40)[min(i, 2)], a=(0.5, 0.8, 1.0)[min(i, 2)])
    if phase == "loop":
        t = i / n
        return vortex_frame(ss, 120 * t, ss * 0.42, bodies=[(k, (t + k / 3) % 1) for k in range(3)])
    if i < 2:
        return vortex_frame(ss, 40 * i, ss * (0.28, 0.14)[i], a=(0.9, 0.7)[i])
    c = ss / 2
    return composite([blob(ss, c, c, ss * 0.12, 250, 0.5), fade_alpha(ring(ss, c, c, ss * 0.06, ss * 0.02, 230), 0.7)])
add("vortex", 48, [("start", 3), ("loop", 6), ("end", 3)],
    "three spiral arms unfurl -> turn, carrying bodies inward to a bright eye, looping -> wind into the centre and flash", g_vortex)

def g_tether(ss, i, n, phase):
    cy = ss / 2
    t = i / n
    layers = []
    for k in range(2):
        path = [(x, cy + ss * 0.14 * math.sin(2 * math.pi * (x / ss + t) + math.pi * k))
                for x in [ss * (-0.1 + 1.2 * j / 32) for j in range(33)]]
        layers.append(stroke(ss, path, ss * 0.08, ss * 0.08, 195, 195, 0.35))
    layers.append(segment(ss, -ss * 0.1, cy, ss * 1.1, cy, ss * 0.10, 225 + 20 * math.sin(2 * math.pi * t), 0.4))
    return composite(layers)
add("tether", 16, [("", 4)],
    "two strands twisting around a bright core line, the twist travelling along it — tile it along the line", g_tether)

def g_bombardment(ss, i, n, phase):
    ix, iy = ss * 0.58, ss * 0.80
    sx, sy = ss * 0.30, -ss * 0.10
    dx, dy = ix - sx, iy - sy
    dl = math.hypot(dx, dy)
    if i <= 1:
        p = (0.30, 0.72)[i]
        mx, my = sx + dx * p, sy + dy * p
        tail = (mx - dx / dl * ss * 0.35, my - dy / dl * ss * 0.35)
        return composite([stroke(ss, [tail, (mx, my)], ss * 0.03, ss * 0.18, 120, 215),
                          blob(ss, mx, my, ss * 0.11, 215, 0.3),
                          blob(ss, mx - ss * 0.03, my - ss * 0.03, ss * 0.04, 245, 0.5)])
    if i == 2:
        return composite([ring(ss, ix, iy, ss * 0.20, ss * 0.04, 230, blur=ss * 0.015, squash=0.4),
                          blob(ss, ix, iy, ss * 0.22, 252, 0.4)])
    beats = {3: dict(ring=0.32, th=0.05, rv=230, ra=1.0, fire=0.16, smoke=0.0, deb=0.18, da=1.0, scorch=0.0),
             4: dict(ring=0.44, th=0.03, rv=190, ra=0.6, fire=0.0, smoke=0.7, deb=0.30, da=0.7, scorch=0.0),
             5: dict(ring=0.0, th=0.0, rv=0, ra=0.0, fire=0.0, smoke=0.35, deb=0.0, da=0.0, scorch=0.5)}
    b = beats[min(i, 5)]
    layers = []
    if b["scorch"]:
        layers.append(fade_alpha(ellipse_la(ss, [ix - ss * 0.22, iy - ss * 0.08, ix + ss * 0.22, iy + ss * 0.08], 80)
                                 .filter(ImageFilter.GaussianBlur(ss * 0.03)), b["scorch"]))
    if b["ring"]:
        layers.append(fade_alpha(ring(ss, ix, iy, ss * b["ring"], ss * b["th"], b["rv"], blur=ss * 0.015, squash=0.4), b["ra"]))
    if b["smoke"]:
        rise = 0.12 if i == 4 else 0.20
        layers.append(fade_alpha(blob(ss, ix, iy - ss * rise, ss * (0.16 if i == 4 else 0.19), 110, 0.6), b["smoke"]))
    if b["fire"]:
        layers.append(blob(ss, ix, iy - ss * 0.05, ss * b["fire"], 225, 0.4))
    if b["deb"]:
        rng = random.Random(90)
        for _ in range(5):
            ang = rng.uniform(-160, -20)
            px, py = polar(ix, iy, ss * b["deb"], ang)
            py += ss * 0.08 * (i - 3)
            layers.append(fade_alpha(blob(ss, px, py, ss * 0.025, 170, 0.3), b["da"]))
    return composite(layers)
add("bombardment", 32, [("", 6)],
    "one mass falling with a trail, an impact flash, a flat blast ring with debris, then smoke over a scorch — stamp it", g_bombardment)


def drop_orphan_imports(d):
    """Godot writes <name>.png.import next to every PNG; remove the ones whose PNG is gone."""
    for f in os.listdir(d):
        if f.endswith(".png.import") and not os.path.exists(os.path.join(d, f[:-len(".import")])):
            os.remove(os.path.join(d, f))

def clear_pngs(d):
    os.makedirs(d, exist_ok=True)
    for f in os.listdir(d):
        if f.endswith(".png"):
            os.remove(os.path.join(d, f))


def generate_runes():
    for shape, meta in SHAPES.items():
        d = os.path.join(RUNES_DIR, shape)
        clear_pngs(d)
        size = meta["canvas"]
        ss = size * SS
        for phase, n in meta["phases"]:
            for i in range(1, n + 1):
                im = finalize(meta["gen"](ss, i - 1, n, phase), size)
                name = f"{shape}_{i}.png" if phase == "" else f"{shape}_{phase}_{i}.png"
                im.save(os.path.join(d, name))
        drop_orphan_imports(d)
    total = sum(sum(n for _, n in m["phases"]) for m in SHAPES.values())
    print(f"runes: {total} frames across {len(SHAPES)} shapes")


# ---------------------------------------------------------------------------
# Characters: wizard (standing/walk/cast/grimoire) and the wand.
# ---------------------------------------------------------------------------

def wizard_pose(ss, bob=0.0, lean=0.0, arm_raise=0.0, leg_shift=0.0, glow=0.0, book=0.0,
                hat_lag=0.0, hat_bob=0.0, hem_lag=0.0):
    """bob: body dip (0..1). lean: body sway (-1..1). The hat tip and the robe hem take their
    own hat_lag / hem_lag (same scale as lean) and hat_bob (same scale as bob), passed as a
    delayed copy of the body's motion, so they trail it by a frame or so."""
    k = ss * 0.04  # horizontal reach of lean / lag
    cx = ss * 0.5 + lean * k
    dip = ss * bob * 0.015
    robe_top_w, robe_bot_w = ss * 0.26, ss * 0.48
    robe_top_y, robe_bot_y = ss * 0.50 + dip, ss * 0.95
    hem_cx = ss * 0.5 + hem_lag * k
    foot_shift = ss * leg_shift * 0.06
    robe = poly_la(ss, [(cx - robe_top_w / 2, robe_top_y), (cx + robe_top_w / 2, robe_top_y),
                        (hem_cx + robe_bot_w / 2 + foot_shift, robe_bot_y),
                        (hem_cx - robe_bot_w / 2 - foot_shift, robe_bot_y)], value=150)
    robe = robe.filter(ImageFilter.GaussianBlur(ss * 0.01))
    head_r = ss * 0.12
    head_cy = ss * 0.42 + dip
    head = ellipse_la(ss, [cx - head_r, head_cy - head_r, cx + head_r, head_cy + head_r], value=195)
    head = head.filter(ImageFilter.GaussianBlur(ss * 0.008))
    # Hat: a flat brim over the top of the head, and a tall cone bent slightly to one side.
    # The cone's tip follows hat_lag / hat_bob rather than the body, so it trails the motion.
    brim_y = ss * 0.33 + dip
    brim = ellipse_la(ss, [cx - ss * 0.22, brim_y - ss * 0.05, cx + ss * 0.22, brim_y + ss * 0.05], value=180)
    tip = (ss * 0.5 + ss * 0.07 + hat_lag * k * 1.5, ss * 0.02 + ss * hat_bob * 0.025)
    bend_x = (cx + tip[0]) / 2 - ss * 0.01
    cone = poly_la(ss, [(cx - ss * 0.14, brim_y), (cx + ss * 0.14, brim_y),
                        (bend_x + ss * 0.07, ss * 0.17 + dip), tip, (bend_x - ss * 0.01, ss * 0.15 + dip)], value=165)
    hat = stack([brim.filter(ImageFilter.GaussianBlur(ss * 0.006)), cone.filter(ImageFilter.GaussianBlur(ss * 0.004))])
    shoulder = (cx + robe_top_w * 0.33, robe_top_y + ss * 0.03)
    hand = (shoulder[0] + ss * (0.10 + 0.08 * arm_raise), shoulder[1] - ss * (0.02 + 0.16 * arm_raise))
    arm = new_canvas(ss)
    ImageDraw.Draw(arm).line([shoulder, hand], fill=(160, 255), width=max(1, int(ss * 0.05)))
    arm = arm.filter(ImageFilter.GaussianBlur(ss * 0.008))
    wand_tip = (hand[0] + ss * 0.08, hand[1] - ss * (0.06 + 0.06 * arm_raise))
    wand = new_canvas(ss)
    ImageDraw.Draw(wand).line([hand, wand_tip], fill=(210, 255), width=max(1, int(ss * 0.025)))
    wand = wand.filter(ImageFilter.GaussianBlur(ss * 0.004))
    layers = [robe, head, hat, arm, wand]
    if glow > 0:
        gr = ss * 0.07 * glow
        g = ellipse_la(ss, [wand_tip[0] - gr, wand_tip[1] - gr, wand_tip[0] + gr, wand_tip[1] + gr], value=245)
        layers.append(g.filter(ImageFilter.GaussianBlur(ss * 0.03)))
    if book > 0:
        bx, by = cx, robe_top_y + ss * 0.05
        w = ss * 0.22 * book
        left = poly_la(ss, [(bx - w, by - ss * 0.02), (bx, by - ss * 0.06), (bx, by + ss * 0.1), (bx - w, by + ss * 0.08)], value=200)
        right = poly_la(ss, [(bx, by - ss * 0.06), (bx + w, by - ss * 0.02), (bx + w, by + ss * 0.08), (bx, by + ss * 0.1)], value=215)
        layers += [left.filter(ImageFilter.GaussianBlur(ss * 0.006)), right.filter(ImageFilter.GaussianBlur(ss * 0.006))]
    return stack(layers)


def generate_wizard():
    """Schematic pose reference for Lord to repaint, not final art. The hat is a brim plus a
    tall bent cone; the hat tip and the robe hem trail the body's motion by about a frame
    (hat_lag / hat_bob / hem_lag are the body's own curves, phase-shifted)."""
    size, ss = 32, 32 * SS
    d = os.path.join(CHAR_DIR, "wizard")
    clear_pngs(d)

    def save(name, idx, **kw):
        finalize(wizard_pose(ss, **kw), size).save(os.path.join(d, f"{name}_{idx}.png"))

    bobs = [0.0, 1.0, 0.0]
    for i, bob in enumerate(bobs, start=1):
        save("standing", i, bob=bob, hat_bob=bobs[i - 2])  # i - 2: the previous frame, wrapping
    for i in range(1, 7):
        p = 2 * math.pi * (i - 1) / 6
        save("walk", i, bob=abs(math.sin(p)), lean=math.sin(p), leg_shift=math.sin(p + math.pi / 2),
             hat_lag=math.sin(p - math.pi / 3), hat_bob=abs(math.sin(p - math.pi / 3)),
             hem_lag=math.sin(p - math.pi / 2))
    cast_frames = [dict(arm_raise=0.1, glow=0.0, bob=0.0, lean=0.0, hat_lag=0.0, hat_bob=0.0, hem_lag=0.0),
                   dict(arm_raise=0.5, glow=0.2, bob=0.6, lean=0.2, hat_lag=0.0, hat_bob=0.0, hem_lag=0.0),
                   dict(arm_raise=1.0, glow=1.0, bob=0.0, lean=0.5, hat_lag=0.1, hat_bob=0.6, hem_lag=0.2),
                   dict(arm_raise=0.9, glow=0.5, bob=0.2, lean=0.4, hat_lag=0.5, hat_bob=0.0, hem_lag=0.5),
                   dict(arm_raise=0.3, glow=0.0, bob=0.0, lean=0.1, hat_lag=0.3, hat_bob=0.2, hem_lag=0.2)]
    for i, kw in enumerate(cast_frames, start=1):
        save("cast", i, **kw)
    grimoire_frames = [(0.15, 0.0, 0.0), (0.5, 0.3, 0.0), (0.85, 0.5, 0.3), (1.0, 0.5, 0.5)]
    for i, (b, bob, hat_bob) in enumerate(grimoire_frames, start=1):
        save("grimoire", i, book=b, bob=bob, hat_bob=hat_bob)
    drop_orphan_imports(d)
    print("wizard:", sum(f.endswith(".png") for f in os.listdir(d)), "frames")


def generate_wand():
    """A single static reference: a plain, straight wooden wand (WEAPONS.md, the default
    weapon). Lord was specific that it stays simple: a gentle taper, a rounded tip, a
    rounded butt, and one faint grain line down its length. Nothing more."""
    d = os.path.join(CHAR_DIR, "wand")
    clear_pngs(d)
    w, h = 6, 32
    ss_w, ss_h = w * SS, h * SS
    im = Image.new("LA", (ss_w, ss_h), (0, 0))
    draw = ImageDraw.Draw(im)
    cx = ss_w / 2
    top_hw, bot_hw = ss_w * 0.11, ss_w * 0.19
    draw.polygon([(cx - top_hw, ss_h * 0.03), (cx + top_hw, ss_h * 0.03),
                  (cx + bot_hw, ss_h * 0.96), (cx - bot_hw, ss_h * 0.96)], fill=(170, 255))
    draw.ellipse([cx - bot_hw, ss_h * 0.94, cx + bot_hw, ss_h * 0.99], fill=(160, 255))
    draw.line([(cx + ss_w * 0.03, ss_h * 0.10), (cx + ss_w * 0.06, ss_h * 0.90)], fill=(145, 255), width=max(1, int(ss_w * 0.06)))
    draw.ellipse([cx - ss_w * 0.14, 0, cx + ss_w * 0.14, ss_h * 0.05], fill=(210, 255))
    im = im.filter(ImageFilter.GaussianBlur(ss_w * 0.03))
    finalize_rect(im, w, h).save(os.path.join(d, "wand_1.png"))
    drop_orphan_imports(d)
    print("wand: 1 frame")


if __name__ == "__main__":
    generate_runes()
    generate_wizard()
    generate_wand()
