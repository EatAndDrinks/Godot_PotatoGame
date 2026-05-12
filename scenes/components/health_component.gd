extends Node
class_name HealthComponent

signal on_unit_hit
signal on_unit_death
signal on_health_change(cur: float , max: float)

var max_health : float = 1.0
var cur_health : float = 1.0

func setup_healthcomponent(stats : UnitStats) -> void:
	max_health = stats.health
	cur_health = max_health
	on_health_change.emit(cur_health , max_health)

func take_damage(value : float) -> void:
	##伤害
	if cur_health <= 0:
		return
	
	cur_health -= value
	cur_health = max(cur_health , 0)
	on_unit_hit.emit()
	on_health_change.emit(cur_health , max_health)
	
	if cur_health <= 0:
		on_unit_death.emit()
		die()


func heal(value : float) -> void:
	##回血
	if cur_health <= 0:
		return
	
	cur_health += value
	cur_health = min(cur_health , max_health)
	on_health_change.emit(cur_health , max_health)

func die() -> void:
	##死亡触发函数
	owner.queue_free()
