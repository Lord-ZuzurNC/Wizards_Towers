class_name VillageState
extends RefCounted
## A village as the server holds it: where it stands and who holds it.

var site: VillageSite
var position := Vector2.ZERO
## 0 while no one holds it. A holder who leaves keeps it: villages are held while their
## wizard is away (UPGRADES_VILLAGE.md). Wizards have no lasting identity yet, so a holder
## who comes back is a new wizard and does not get it back.
var owner_peer_id := 0
