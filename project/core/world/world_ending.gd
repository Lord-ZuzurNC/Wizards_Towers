class_name WorldEnding
extends RefCounted
## How a run terminated, once, for everybody (GLOSSARY.md, World endings).

enum Kind {
	ROOF_TAKEN,
	WORLD_COLLAPSE,
	DEVOURED,
}

const NAMES: Array[String] = ["The Roof Taken", "World Collapse", "Devoured by the Monolith"]


## [param kind] is a [enum Kind].
static func label(kind: int) -> String:
	return NAMES[kind]
