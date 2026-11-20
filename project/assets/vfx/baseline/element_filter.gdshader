shader_type canvas_item;
// The template + element filter technique (see ../README.md).
//
// A Shape's frames are drawn once, in grayscale with alpha (format "LA"): the grey value
// encodes shading (dark = shadow, bright = highlight), the alpha channel encodes the
// silhouette. This shader remaps that grey value through a 1-pixel-tall "ramp" texture —
// one ramp per Element, built from BLK NX64 — so the same 21 Shape animations serve all 14
// Elements without redrawing a single frame.

/// A horizontal gradient, dark to bright, built from BLK NX64 colours for one Element.
/// Swap this per spell: one AnimatedSprite2D, any ramp.
uniform sampler2D ramp : source_color, filter_linear, repeat_disable;

void fragment() {
	vec4 mask = texture(TEXTURE, UV);
	vec3 tinted = texture(ramp, vec2(mask.r, 0.5)).rgb;
	COLOR = vec4(tinted, mask.a * COLOR.a);
}
