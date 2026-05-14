extends Node2D
class_name Weapon

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_behavior: WeaponBehavior = $WeaponBehavior

var data : ItemWeapon
var is_attacking : bool
var atk_start_pos : Vector2
var targets : Array[Enemy]
var closest_traget : Enemy
var weapon_spread : float

func _ready() -> void:
	atk_start_pos = sprite.position

func _physics_process(delta: float) -> void:
	if not is_attacking:
		if targets.size() > 0:
			update_closest_target()
		else:
			closest_traget = null
	
	rotate_to_target()
	
	if can_use_weapon():
		use_weapon()
	

func setup_weapon(data : ItemWeapon) -> void:
	self.data = data
	collision.shape.radius = data.stats.max_shoot_distance

func can_use_weapon() -> bool:
	return cooldown_timer.is_stopped() and closest_traget

func use_weapon() -> void:
	calculate_spread()
	weapon_behavior.execute_attack()
	cooldown_timer.wait_time = data.stats.cooldown
	cooldown_timer.start()

func update_closest_target() -> void:
	##更新最近的目标角色
	closest_traget = get_closest_target()

func get_idle_rotation() -> float:
	##获取默认旋转值
	if Global.player.is_facing_right():
		return 0
	else:
		return PI

func calculate_spread() -> void:
	##计算武器旋转幅度
	weapon_spread += randf_range(-1 + data.stats.accuracy , 1 - data.stats.accuracy)
	rotation += weapon_spread 

func get_closest_target() -> Node2D:
	##获取最近的目标角色
	if targets.size() == 0:
		return 
	
	var closest_enemy : Enemy = targets[0]
	var closest_distance := global_position.distance_to(closest_enemy.global_position)
	
	for i in range(1, targets.size()):
		var target : Enemy = targets[i]
		var distance := global_position.distance_to(target.global_position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = target
			
	return closest_enemy


func rotate_to_target() -> void:
	if is_attacking:
		rotation = get_custom_rotataion_to_target()
	else:
		rotation = get_rotation_to_target()

func get_custom_rotataion_to_target() -> float:
	##获取定制的面向目标武器角度（精确度）
	if not closest_traget or not is_instance_valid(closest_traget):
		return rotation
		
	var rot := global_position.direction_to(closest_traget.global_position).angle()
	return rot + weapon_spread


func get_rotation_to_target() -> float:
	##获取面向目标的武器角度
	if targets.size() == 0:
		return get_idle_rotation()
	
	var rot := global_position.direction_to(closest_traget.global_position).angle()
	return rot 



func _on_range_area_area_entered(area: Area2D) -> void:
	targets.push_back(area)


func _on_range_area_area_exited(area: Area2D) -> void:
	targets.erase(area)
	if targets.size() == 0:
		closest_traget = null
