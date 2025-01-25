extends CharacterBody2D

@onready var bubble: RigidBody2D = $"../Bubble"
@onready var damped_spring_joint_2d: DampedSpringJoint2D = $"../DampedSpringJoint2D"
@onready var bubble_sprite: AnimatedSprite2D = $"../Bubble/BubbleSprite"
@onready var player_sprite: Sprite2D = $PlayerSprite

@export var SPEED = 5.0
@export var DRAG_FORCE = 0.98
@export var bubble_air_volume : float = 1.0
@export var bubble_scale : float
var default_length : float = 0

var dir : Vector2 = Vector2(0, 0)
var env_velocity : Vector2 = Vector2(0, 0)
var INITIAL_AIR_VOLUME : float = bubble_air_volume
var air_factor = sqrt(INITIAL_AIR_VOLUME / PI)

func _ready() -> void:
	bubble_scale = sqrt(bubble_air_volume / PI)
	bubble.scale = Vector2(bubble_scale / air_factor , bubble_scale / air_factor)
	default_length = (self.position - bubble.position).length()

func _process(delta: float) -> void:
	if Input.is_action_just_released("debug"):
		collect(1)
	bubble.scale = Vector2(bubble_scale / air_factor, bubble_scale / air_factor)
	
	damped_spring_joint_2d.length = default_length * bubble_scale * 0.85
	damped_spring_joint_2d.rest_length = default_length * bubble_scale * 0.85
	
	var target = self.global_position - self.velocity.normalized()
	player_sprite.look_at(target)
	
	player_sprite.flip_v = self.velocity.normalized().x > 0

func _physics_process(delta: float) -> void:
	var _velocity = Vector2(0,0)
	_velocity += SPEED * Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_velocity += env_velocity
	velocity += _velocity
	velocity *= DRAG_FORCE
	
	env_velocity = Vector2(0,0)
	move_and_slide()

func collect(air_volume: float):
	self.bubble_scale = sqrt((air_volume + self.bubble_air_volume)/PI)
	self.bubble_air_volume = (self.bubble_scale**2)*PI
