extends CharacterBody2D

const SPEED = 1.0
const DRAG_FORCE = 0.98
var dir : Vector2 = Vector2(0, 0)
var env_velocity : Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	var _velocity = Vector2(0,0)
	_velocity += SPEED * Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_velocity += env_velocity
	velocity += _velocity
	velocity *= DRAG_FORCE
	
	env_velocity = Vector2(0,0)
	move_and_slide()
