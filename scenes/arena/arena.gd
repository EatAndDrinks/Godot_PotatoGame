extends Node2D
class_name Arena

@export var player : Player

@export var normal_color : Color
@export var blocked_color : Color
@export var critical_color : Color
@export var hp_color : Color


func _ready() -> void:
	Global.player = player
	Global.on_create_block_text.connect(on_create_block_text)
	Global.on_create_damage_text.connect(on_create_damage_text)

func create_floating_text(unit : Node2D) -> Floatingtext:
	##创建浮动文本实例，
	var instance : Floatingtext = Global.FLOATING_TEXT_SCENES.instantiate()
	get_tree().root.add_child(instance)
	
	#规定生成位置
	var random_pos : float = randf_range(0 , TAU)
	var spawn_pos : Vector2 = unit.global_position + Vector2.RIGHT.rotated(random_pos) + Vector2.UP * 40
	instance.global_position = spawn_pos
	return instance
	

func on_create_block_text(unit : Node2D) -> void:
	var text : Floatingtext = create_floating_text(unit)
	text.setup_valuelabel("Blocked!" , blocked_color)

func on_create_damage_text(unit : Node2D , hitbox : HitboxComponent) -> void:
	var text : Floatingtext = create_floating_text(unit)
	var color : Color = critical_color if hitbox.critical else normal_color
	
	text.setup_valuelabel(str(hitbox.damage) , color)
