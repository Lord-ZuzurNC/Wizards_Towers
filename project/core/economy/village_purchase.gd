class_name VillagePurchase
extends RefCounted
## Whether a wizard may buy a village, decided the same way by the server, which enforces
## it, and by the client, which only uses it to say what pressing the key would do.

enum Verdict {
	ALLOWED,
	TOO_FAR,
	OWNED,
	LEVEL_TOO_LOW,
	NOT_ENOUGH_GOLD,
}

## The level a wizard needs to hold more than one village (UPGRADES_VILLAGE.md).
const SECOND_VILLAGE_LEVEL := 2


## [param distance] and [param reach] are in pixels; [param owner_peer_id] is 0 for a
## village no one holds. Checked in this order, so the verdict names the first obstacle.
static func judge(
	distance: float,
	reach: float,
	owner_peer_id: int,
	wizard_level: int,
	villages_held: int,
	gold: int,
	price: int,
) -> Verdict:
	if distance > reach:
		return Verdict.TOO_FAR
	if owner_peer_id != 0:
		return Verdict.OWNED
	if villages_held >= 1 and wizard_level < SECOND_VILLAGE_LEVEL:
		return Verdict.LEVEL_TOO_LOW
	if gold < price:
		return Verdict.NOT_ENOUGH_GOLD
	return Verdict.ALLOWED
