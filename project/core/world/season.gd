class_name Season
extends RefCounted
## The four quarters of a run, in order (GLOSSARY.md, season). The run ends when winter
## runs out.

enum Kind {
	SPRING,
	SUMMER,
	AUTUMN,
	WINTER,
}

const NAMES: Array[String] = ["Spring", "Summer", "Autumn", "Winter"]
const COUNT := 4


## [param kind] is a [enum Kind].
static func label(kind: int) -> String:
	return NAMES[kind]


## The season [param elapsed] ticks into a run of seasons [param season_ticks] long; -1 once
## winter has run out.
static func at(elapsed: int, season_ticks: int) -> int:
	var index := floori(float(elapsed) / season_ticks)
	return index if index < COUNT else -1


## Ticks left in the season [param elapsed] ticks into the run.
static func ticks_left(elapsed: int, season_ticks: int) -> int:
	return season_ticks - posmod(elapsed, season_ticks)
