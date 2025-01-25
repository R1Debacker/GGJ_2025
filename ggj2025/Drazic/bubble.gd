extends RigidBody2D
class_name Bubble

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var bubble_scale : float
var AIR_VOLUME_SCALE : float = 1
var initial_air_volume: float = AIR_VOLUME_SCALE
var air_volume : float
var air_factor = sqrt(AIR_VOLUME_SCALE / PI)

func _ready() -> void:
	set_volume(initial_air_volume)

func _on_body_entered(body: Node) -> void:
	if body.has_method("collect"):
		body.collect(scale.x)
		_burst_bubble()

func _burst_bubble():
	#queue_free()
	pass

func set_volume(new_vol):
	bubble_scale = sqrt(new_vol / PI)
	self.scale = Vector2(bubble_scale / air_factor , bubble_scale / air_factor)
	self.air_volume = new_vol

func add_volume(added_vol):
	self.bubble_scale = sqrt((air_volume + self.bubble_air_volume)/PI)
	self.bubble_air_volume = (self.bubble_scale**2)*PI

static func spawn_bubble(parent: Node2D, position: Vector2, bubble_vol: float, moving_bubble=true):	
	var current_bubble = null
	if moving_bubble:
		current_bubble = Game.MOVING_BUBBLE.instantiate()
	else:
		current_bubble = Game.BUBBLE.instantiate()
	current_bubble.position = position
	current_bubble.initial_air_volume = bubble_vol
	parent.add_child(current_bubble)
	parent.move_child(current_bubble, 0)
	current_bubble = null
