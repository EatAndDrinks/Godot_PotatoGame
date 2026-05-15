extends Node2D
class_name ShootingBehavior

@export var enemy : Enemy
@export var fire_pos : Marker2D
@export var cooldown : float = 3.0
@export var projectile_count : int = 3
@export var arc_angle : float = 45.0
@export var projectile_scene : PackedScene
@export var projectile_speed : float = 1800.0

var current_cooldown : float

func _ready() -> void:
	current_cooldown = cooldown


func _process(delta: float) -> void:
	if enemy == null:
		return
	
	if current_cooldown > 0:
		current_cooldown -=delta
	else:
		shoot()
		current_cooldown = cooldown

func shoot():
	if not is_instance_valid(Global.player):
		return
	
	enemy.can_move = false
	
	#计算设计角度
	var dir : Vector2 = enemy.global_position.direction_to(Global.player.global_position)
	var start_angle := -arc_angle / 2.0
	#角度区域
	var angle_step := arc_angle / float(projectile_count - 1 if projectile_count > 1 else 0.0)
	
	for i in range(projectile_count):
		var projectile : Projectile = projectile_scene.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_position = fire_pos.global_position
		
		var rotation_dir := dir.rotated(deg_to_rad(start_angle + angle_step * i))
		var velocity := rotation_dir * projectile_speed
		projectile.set_projectile(velocity , enemy.stats.damage , false , 0 , enemy)
	
	
	await get_tree().create_timer(1).timeout
	enemy.can_move = true
