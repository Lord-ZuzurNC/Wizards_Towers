class_name RuneAttribute
extends RefCounted
## The four categories a rune belongs to (GLOSSARY.md, attribute).
##
## Effect fills two ordered spell slots, so four attributes make five slots; see [Spell].

enum {
	SHAPE,
	ELEMENT,
	DURATION,
	EFFECT,
}

const NAMES: Array[String] = ["Shape", "Element", "Duration", "Effect"]


## [param attribute] is a [RuneAttribute] value.
static func label(attribute: int) -> String:
	return NAMES[attribute]
