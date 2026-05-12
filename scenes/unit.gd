extends Node2D
class_name Unit

@export var stats : UnitStats

@onready var visuals: Node2D = %Visuals
@onready var sprite: Sprite2D = %Sprite
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var flash_timer: Timer = $FlashTimer

func _ready() -> void:
	health_component.setup_healthcomponent(stats)
	


func set_flash_material() -> void:
	sprite.material = Global.FLASH_MATERIAL
	flash_timer.start()


func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	if health_component.cur_health <= 0:
		return
	
	#阻挡判断
	var blocked : bool = Global.get_chance_access(stats.block_chance / 100)
	
	if blocked:
		Global.on_create_block_text.emit(self)
		print("Blocked!")
		return
	
	set_flash_material()
	health_component.take_damage(hitbox.damage)
	Global.on_create_damage_text.emit(self , hitbox)
	print("%s : %d" % [stats.name , health_component.cur_health])


func _on_flash_timer_timeout() -> void:
	sprite.material = null
