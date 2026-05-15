extends Node2D
class_name ChargerBehavior

@export var enemy : Enemy 
@export var anim_effect : AnimationPlayer
@export var prep_time : float = 1.0
@export var cooldown : float = 3.0

var current_cooldown : float = 0.0
var charge_attack_pos : Vector2 = Vector2.ZERO
var is_charging : bool = false

func _ready() -> void:
	current_cooldown = cooldown

func _process(delta: float) -> void:
	if enemy == null:
		return
	if is_charging:
		enemy.global_position = enemy.global_position.move_toward(charge_attack_pos , (enemy.stats.speed * 5) * delta)
		
		if enemy.global_position.distance_to(charge_attack_pos) < 50:
			end_charge()
	else:
		if current_cooldown > 0:
			current_cooldown -= delta
		else:
			if is_instance_valid(Global.player):
				charge_attack_pos = Global.player.position
				start_charge()




func start_charge() -> void:
	enemy.can_move = false
	anim_effect.play("charge")
	await anim_effect.animation_finished
	is_charging = true


func end_charge() -> void:
	is_charging = false
	current_cooldown = cooldown
	enemy.can_move = true
