extends CharacterBody2D
class_name Player

@onready var bubble: RigidBody2D = $"../Bubble"
@onready var damped_spring_joint_2d: DampedSpringJoint2D = $"../DampedSpringJoint2D"
@onready var bubble_sprite: AnimatedSprite2D = $"../Bubble/BubbleSprite"
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var player_speed = 500.0
@export var dash_speed = 30000.0
@export var drag_resistance = 0.98
@export var bubble_air_volume : float = 1.0
@export var bubble_scale : float
@export var dash_delay_ms : float = 1000.0
var timestamp_last_use_dash : float = 0

var default_length : float = 0
var dir : Vector2 = Vector2(0, 0)
var env_velocity : Vector2 = Vector2(0, 0)
var INITIAL_AIR_VOLUME : float = bubble_air_volume
var air_factor = sqrt(INITIAL_AIR_VOLUME / PI)
var has_bubble : bool = true
var device_idx : int = 0
var is_dash_pressed = true

func _ready() -> void:
	bubble_scale = sqrt(bubble_air_volume / PI)
	bubble.scale = Vector2(bubble_scale / air_factor , bubble_scale / air_factor)
	default_length = (self.global_position - bubble.global_position).length() / bubble_scale
	print(default_length)

func _process(delta: float) -> void:
	bubble.scale = Vector2(bubble_scale / air_factor, bubble_scale / air_factor)
	
	damped_spring_joint_2d.length = default_length * bubble_scale
	damped_spring_joint_2d.rest_length = default_length * bubble_scale
	
	var target = self.global_position - self.velocity.normalized()
	self.look_at(target)
	
	if self.velocity.length() > 50:
		self.player_sprite.play("swimming")
	else:
		self.player_sprite.play("idle")
	
	player_sprite.flip_v = self.velocity.normalized().x > 0

func is_dash_ready() -> bool:
	return (Time.get_ticks_msec() - self.timestamp_last_use_dash) > self.dash_delay_ms

func is_dash_just_precced() -> bool:
	if Input.is_joy_button_pressed(self.device_idx, JOY_BUTTON_X):
		if not self.is_dash_pressed:
			self.is_dash_pressed = true
			return true
		return false
	else:
		self.is_dash_pressed = false
		return false

func dash_logic():
	var _velocity = Vector2(0,0)
	if is_dash_just_precced() and has_bubble and is_dash_ready():
		self.timestamp_last_use_dash = Time.get_ticks_msec()
		var dash_dir = (self.global_position - bubble.global_position).normalized()
		_velocity += dash_dir * dash_speed
		Bubble.spawn_bubble(get_tree().current_scene, bubble.global_position, 1)
	return _velocity

func _physics_process(delta: float) -> void:
	var _velocity = Vector2(0,0)
	
	_velocity += dash_logic()
	
	_velocity += player_speed * Vector2(Input.get_joy_axis(self.device_idx, JOY_AXIS_LEFT_X), Input.get_joy_axis(self.device_idx, JOY_AXIS_LEFT_Y))
	_velocity += env_velocity
	velocity += _velocity * delta
	velocity *= drag_resistance
	
	env_velocity = Vector2(0,0)
	move_and_slide()

func collect(air_volume: float):
	self.bubble_scale = sqrt((air_volume + self.bubble_air_volume)/PI)
	self.bubble_air_volume = (self.bubble_scale**2)*PI
