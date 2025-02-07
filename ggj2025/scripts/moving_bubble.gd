extends Bubble

@export var x_speed := 5.0
@export var y_speed := 20.0
var x_dir_factor = 1.0
@onready var life_timer: Timer = $"LifeTimer"
@onready var change_direction_timer: Timer = $"ChangeDirectionTimer"

func _ready() -> void:
	life_timer.wait_time = randf_range(10.0, 15.0)

func _physics_process(delta: float) -> void:
	position += Vector2(x_speed*x_dir_factor, -y_speed) * delta

func _on_life_timer_timeout() -> void:
	_burst_bubble()

func _on_change_direction_timer_timeout() -> void:
	change_direction_timer.wait_time = randf_range(1.0, 3.0)
	x_dir_factor *= -1
