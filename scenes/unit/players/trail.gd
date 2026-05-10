extends Line2D
class_name Trail

@export var player : Player
@export var trail_length : float = 25
@export var trail_duration : float = 1.0

@onready var trail_timer: Timer = %TrailTimer

var point_array : Array[Vector2] = []
var is_action : bool = false

func _process(delta: float) -> void:
	if not is_action:
		return
	
	point_array.append(player.global_position)
	if point_array.size() > trail_length:
		point_array.pop_front()
	
	points = point_array

func start_trail() -> void:
	is_action = true
	clear_points()
	point_array.clear()
	trail_timer.start(trail_duration)


func _on_trail_timer_timeout() -> void:
	is_action = false
	clear_points()
	point_array.clear()
