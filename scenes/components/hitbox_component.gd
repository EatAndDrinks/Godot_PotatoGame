extends Area2D
class_name HitboxComponent


signal on_hit_hurtbox(hurtbox: HurtboxComponent)

var damage : float = 1.0
#暴击
var critical : bool = false
#击退
var knockback_power : float = 0.0

var source : Node2D

func enable() -> void:
	set_deferred("monitoring" , true)
	set_deferred("monitorable" , true)

func disable() -> void:
	set_deferred("monitoring" , false)
	set_deferred("monitorable" , false)

func setup_hitboxcomponent(damage : float , critical : bool , knockback : float , source : Node2D) -> void:
	self.damage = damage
	self.critical = critical
	knockback_power = knockback
	self.source = source
	


func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		on_hit_hurtbox.emit(area)
