extends Unit
class_name Player

@export_group("冲刺数据")
@export var dash_duration : float = 0.5
@export var dash_speed_mulit : float = 2.5
@export var dash_cooldown : float = 0.5



@onready var dash_cooldown_timer: Timer = $DashCoolDownTimer
@onready var dash_timer: Timer = $DashTimer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var trail: Trail = %Trail
@onready var weapon_container: WeaponContainer = $WeaponContainer

var current_weapon : Array[Weapon] = []

var move_dir : Vector2
var is_dash : bool = false
var dash_available : bool = true


#--------------
#	初始函数
#--------------
func _ready() -> void:
	super._ready()
	dash_timer.wait_time = dash_duration
	dash_cooldown_timer.wait_time = dash_cooldown
	add_weapon(preload("uid://cx1q83vpf2e7j"))




#--------------
#	运行函数
#--------------
func _process(delta: float) -> void:
	
	##移动
	move_dir = Input.get_vector("move_left" , "move_right" , "move_up" , "move_down")

	var current_velocity := move_dir * stats.speed
	
	if is_dash:
		current_velocity *= dash_speed_mulit
	
	position += current_velocity * delta
	#移动限制
	position.x = clamp(position.x , -1000 , 1000)
	position.y = clamp(position.y , -500 , 500)
	
	if can_dash():
		start_dash()

	update_animation()
	reverse()

func update_animation() -> void:

	if move_dir.length() > 0:
		anim_player.play("move")
	else:
		anim_player.play("idle")


func reverse() -> void:
	#转向
	if move_dir == Vector2.ZERO:
		return
	
	if move_dir.x > 0.1:
		visuals.scale = Vector2(-0.5,0.5)
	else:
		visuals.scale = Vector2(0.5,0.5)


func start_dash() -> void:
	is_dash = true
	dash_timer.start()
	visuals.modulate.a = 0.5
	collision.set_deferred("disabled" , true)
	
	#播放尾迹效果
	trail.start_trail()

func can_dash() -> bool:
	return not is_dash and dash_cooldown_timer.is_stopped() and Input.is_action_just_pressed("dash") and move_dir != Vector2.ZERO


func add_weapon(data : ItemWeapon) -> void:
	var weapon : Weapon = data.scene.instantiate()
	add_child(weapon)
	weapon.setup_weapon(data)
	current_weapon.append(weapon)
	weapon_container.update_weapon_position(current_weapon)


func is_facing_right() -> bool:
	return visuals.scale.x == -0.5


func _on_dash_timer_timeout() -> void:
	is_dash = false
	visuals.modulate.a = 1.0
	collision.set_deferred("disabled" , false)
	dash_cooldown_timer.start()
