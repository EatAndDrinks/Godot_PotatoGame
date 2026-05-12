extends Unit
class_name Enemy

@export var flock_push : float = 20.0

@onready var vision_area: Area2D = $VisionArea

var can_move : bool = true

func _process(delta: float) -> void:
	if not can_move:
		return
	
	if not can_move_toward_player():
		return
	
	position += get_move_direction() * stats.speed * delta
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
