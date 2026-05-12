extends Control
class_name HealthBar

@export var back_color : Color
@export var fill_color : Color


@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_label: Label = $Label


func _ready() -> void:
	
	##血条主题更改
	var back_style = progress_bar.get_theme_stylebox("background").duplicate()
	back_style.bg_color = back_color
	
	var fill_style = progress_bar.get_theme_stylebox("fill").duplicate()
	fill_style.bg_color = fill_color
	progress_bar.add_theme_stylebox_override("background" , back_style)
	progress_bar.add_theme_stylebox_override("fill" , fill_style)

func update_healthbar(value : float , health : float) ->void:
	progress_bar.value = value
	health_label.text = str(health)


func _on_health_component_on_health_change(cur: float, max: float) -> void:
	var value = cur / max
	update_healthbar(value , cur)
