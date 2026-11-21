class_name TrainingDummy
extends RefCounted
## A stationary combatant to practise on: it pays XP to whoever destroys it, and stands up
## again after a while.
##
## While standing, it also strikes a wizard right next to it (see
## [member PlaceholderValues.dummy_strike_raw_damage]). That is a provisional testing aid
## standing in for a real attacker, so the peace shield's effect can be seen; it is not a
## claim that dummies are hostile in the finished game.

var position := Vector2.ZERO
var health := 0
var max_health := 0
var magic_defence := 0
## The tick it stands up again; meaningful only while destroyed.
var respawn_tick := 0


func is_destroyed() -> bool:
	return health <= 0


## Takes a hit. Returns true when this hit destroyed it.
func take_hit(raw_damage: int, now_tick: int, respawn_ticks: int) -> bool:
	if is_destroyed():
		return false
	health -= Damage.dealt(raw_damage, magic_defence)
	if health > 0:
		return false
	health = 0
	respawn_tick = now_tick + respawn_ticks
	return true


## Stands up again, at full health, once its time has come.
func update(now_tick: int) -> void:
	if is_destroyed() and now_tick >= respawn_tick:
		health = max_health
