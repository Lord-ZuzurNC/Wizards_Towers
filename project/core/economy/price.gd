class_name Price
extends RefCounted
## What a purchase costs, from FORMULAS.md, section Economy.


## The escalating price: [param base] for the first purchase of a type, then multiplied by
## [param multiplier] for each purchase of that type already made this run, kept or not.
static func escalating(base: int, multiplier: float, purchases_made: int) -> int:
	return floori(base * pow(multiplier, purchases_made))
