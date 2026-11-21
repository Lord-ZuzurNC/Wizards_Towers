class_name WizardEnding
extends RefCounted
## How one wizard's own run finished (GLOSSARY.md, Wizard endings).
##
## Only [constant DEVOURED_WILDS] is reached so far, by hazard damage (see
## [code]server_world.gd[/code], [code]_hurt[/code]). The other six wait on what they
## name: wizard-vs-wizard combat for [constant MURDERED], the final battle and the ROOF for
## [constant CROWNED] and [constant CAST_FROM_ROOF], dungeons and mazes for
## [constant LOST_BELOW], world bosses for [constant CLAIMED_BY], and a run surviving to
## its end for [constant OUTLIVED].

enum Kind {
	CROWNED,
	CAST_FROM_ROOF,
	MURDERED,
	DEVOURED_WILDS,
	LOST_BELOW,
	CLAIMED_BY,
	OUTLIVED,
}

const NAMES: Array[String] = [
	"Crowned",
	"Cast from the Roof",
	"Murdered by its Own Kin",
	"Devoured by the Wilds",
	"Lost Below",
	"Claimed by …",
	"Outlived the World",
]


## [param kind] is a [enum Kind].
static func label(kind: int) -> String:
	return NAMES[kind]
