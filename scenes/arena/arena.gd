extends Node2D
class_name Arena

@export var player : Player

@export var normal_color : Color
@export var blocked_color : Color
@export var critical_color : Color
@export var hp_color : Color

@onready var wave_index_label: Label = %WaveIndexLabel
@onready var wave_time_label: Label = %WaveTimeLabel

@onready var spawner: Spawner = $Spawner
@onready var upgrade_panel: UpGradePanel = $GUI/UpgradePanel


func _ready() -> void:
	Global.player = player
	Global.on_create_block_text.connect(on_create_block_text)
	Global.on_create_damage_text.connect(on_create_damage_text)
	Global.on_upgrade_selected.connect(_on_upgrade_selected)
	Global.on_create_heal_text.connect(_on_create_heal_text)
	spawner.start_wave()

func _process(delta: float) -> void:
	if Global.game_pause:
		return
	wave_index_label.text = spawner.get_wave_text()
	wave_time_label.text = spawner.get_wave_time_text()

func create_floating_text(unit : Node2D) -> Floatingtext:
	##创建浮动文本实例，
	var instance : Floatingtext = Global.FLOATING_TEXT_SCENES.instantiate()
	get_tree().root.add_child(instance)
	
	#规定生成位置
	var random_pos : float = randf_range(0 , TAU)
	var spawn_pos : Vector2 = unit.global_position + Vector2.RIGHT.rotated(random_pos) + Vector2.UP * 40
	instance.global_position = spawn_pos
	return instance

func show_upgrade_panel() -> void:
	upgrade_panel.load_upgrades(spawner.wave_index)
	upgrade_panel.show()

func start_new_wave() -> void:
	Global.game_pause = false
	Global.player.update_player_new_wave()
	spawner.wave_index += 1
	spawner.start_wave()

func on_create_block_text(unit : Node2D) -> void:
	var text : Floatingtext = create_floating_text(unit)
	text.setup_valuelabel("Blocked!" , blocked_color)

func _on_create_heal_text(unit : Node2D , heal : float) -> void:
	var text : Floatingtext = create_floating_text(unit)
	text.setup_valuelabel(" + %s" % heal , hp_color)


func on_create_damage_text(unit : Node2D , hitbox : HitboxComponent) -> void:
	var text : Floatingtext = create_floating_text(unit)
	var color : Color = critical_color if hitbox.critical else normal_color
	
	text.setup_valuelabel(str(hitbox.damage) , color)

func _on_upgrade_selected() -> void:
	upgrade_panel.hide()
	start_new_wave()

func _on_spawner_on_wave_completed() -> void:
	if not is_instance_valid(Global.player):
		return
	await get_tree().create_timer(1.0).timeout
	show_upgrade_panel()
