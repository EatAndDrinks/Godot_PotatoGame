extends Unit
class_name Enemy

@export var flock_push : float = 20.0

@onready var vision_area: Area2D = $VisionArea
@onready var knockback_timer: Timer = $KnockbackTimer

var can_move : bool = true

var knockback_dir : Vector2
var knockback_power : float


func _process(delta: float) -> void:
	if not can_move:
		return
	
	if not can_move_toward_player():
		return
	
	position += (get_move_direction() + knockback_dir * knockback_power) * stats.speed * delta
	#update_rotation()


func can_move_toward_player() -> bool:
	return is_instance_valid(Global.player) and global_position.distance_to(Global.player.global_position) > 50

func get_move_direction() -> Vector2:
	## 获取 移动到player位置 并且 排斥其他敌人位置 的移动方向向量
	if not is_instance_valid(Global.player):
		return Vector2.ZERO
	
	var dir : Vector2 = global_position.direction_to(Global.player.global_position)
	
	for area : Node2D in vision_area.get_overlapping_areas():
		#获取检测区域内所有敌人排斥向量总和
		if area != self and area.is_inside_tree():
			#判断不是自己 并且 敌人在场景中
			var exclusion_dir : Vector2 = global_position - area.global_position
			dir += flock_push * exclusion_dir.normalized() / exclusion_dir.length()
		
	return dir

func reset_knockback() -> void:
	knockback_dir = Vector2.ZERO
	knockback_power = 0.0

func apply_knockback(knock_dir : Vector2 , knock_power : float) -> void:
	knockback_dir = knock_dir
	knockback_power = knock_power
	if knockback_timer.time_left > 0:
		knockback_timer.stop()
		reset_knockback()
	
	knockback_timer.start()

func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	super._on_hurtbox_component_on_damaged(hitbox)
	if hitbox.knockback_power > 0:
		var dir : Vector2 = hitbox.source.global_position.direction_to(global_position)
		apply_knockback(dir , hitbox.knockback_power)





func _on_knockback_timer_timeout() -> void:
	reset_knockback()
