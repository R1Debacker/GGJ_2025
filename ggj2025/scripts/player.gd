extends CharacterBody2D
class_name Player


@onready var bubble: Bubble = null
@onready var damped_spring_joint_2d: DampedSpringJoint2D = $"../DampedSpringJoint2D"
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var bubble_parent: RigidBody2D = $"../Bubble"

@export var player_speed = 500.0
@export var dash_speed = 30000.0
@export var drag_resistance = 0.98
@export var dash_delay_ms : float = 1000.0
@export var device_idx : int = 0
var timestamp_last_use_dash : float = 0

var default_length : float = 0
var dir : Vector2 = Vector2(0, 0)
var env_velocity : Vector2 = Vector2(0, 0)
var is_dash_pressed = true

var has_bubble : bool :
	get:
		return bubble != null

func _ready() -> void:
	if has_bubble:
		default_length = (self.global_position - bubble.global_position).length() / bubble.bubble_scale

func _process(delta: float) -> void:
	if has_bubble:
		damped_spring_joint_2d.length = default_length * bubble.bubble_scale * 0.8
		damped_spring_joint_2d.rest_length = default_length * bubble.bubble_scale * 0.8
	
	var target = self.global_position - self.velocity.normalized()
	self.look_at(target)
	
	if self.velocity.length() > 600 and self.player_sprite.animation != "dash":
		self.player_sprite.play("dash")
	if self.player_sprite.animation == "dash" and self.velocity.length() > 450:
		pass
	elif self.velocity.length() > 300:
		self.player_sprite.play("fast")
	elif self.velocity.length() > 50:
		self.player_sprite.play("swimming")
	else:
		self.player_sprite.play("idle")
	
	player_sprite.scale.y = -abs(player_sprite.scale.y) if self.velocity.normalized().x > 0 else abs(player_sprite.scale.y)
	collision.scale.y = -abs(collision.scale.y) if self.velocity.normalized().x > 0 else abs(collision.scale.y)

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
		bubble.split()
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

func collect(hit_bubble: Bubble):
	if has_bubble:
		self.bubble.add_volume(hit_bubble.air_volume)
		hit_bubble._burst_bubble()
	else:
		hit_bubble.moving_active = false
		hit_bubble.get_parent().remove_child(hit_bubble)
		bubble_parent.add_child(hit_bubble)
		hit_bubble.position = Vector2(0,0)
		self.bubble = hit_bubble
