extends Node2D

@export var x_speed := 5.0
@export var y_speed := 20.0
var x_dir_factor = 1.0

func _ready() -> void:
	$LifeTimer.wait_time = randf_range(10.0, 15.0)

func _physics_process(delta: float) -> void:
	position += Vector2(x_speed*x_dir_factor, -y_speed) * delta


func _set_scale(scale_factor: float) -> void:
	scale *= scale_factor

func _burst_bubble():
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("collect"):
		body.collect(scale.x)
		_burst_bubble()


func _on_life_timer_timeout() -> void:
	_burst_bubble()


func _on_change_direction_timer_timeout() -> void:
	$ChangeDirectionTimer.wait_time = randf_range(1.0, 3.0)
	x_dir_factor *= -1
