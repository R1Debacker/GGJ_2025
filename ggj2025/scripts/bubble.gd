extends Node2D
class_name Bubble

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPLIT_KEEP_PERCENT = 0.8

var bubble_scale : float = 1
var AIR_VOLUME_SCALE : float = 1
var air_volume : float
var air_factor = sqrt(AIR_VOLUME_SCALE / PI)

func _ready() -> void:
	set_volume(AIR_VOLUME_SCALE)

func _on_body_entered(body: Node) -> void:
	if body.has_method("collect"):
		if self == body.bubble:
			return
		body.collect(self.air_volume)
		_burst_bubble()

func _burst_bubble():
	queue_free()

func set_volume(new_vol):
	bubble_scale = sqrt(new_vol / PI)
	self.scale = Vector2(bubble_scale / air_factor , bubble_scale / air_factor)
	self.air_volume = new_vol

func add_volume(added_vol):
	self.bubble_scale = sqrt((added_vol + air_volume)/PI)
	self.set_volume((self.bubble_scale**2)*PI)

func split():
	var new_air_vol = self.air_volume * SPLIT_KEEP_PERCENT
	var lost_air_vol = self.air_volume * (1-SPLIT_KEEP_PERCENT)
	self.set_volume(new_air_vol)
	Bubble.spawn_bubble(get_tree().current_scene, self.global_position, lost_air_vol)

static func spawn_bubble(parent: Node2D, position: Vector2, bubble_vol: float, moving_bubble=true):	
	var current_bubble = null
	if moving_bubble:
		current_bubble = Game.MOVING_BUBBLE.instantiate()
	else:
		current_bubble = Game.BUBBLE.instantiate()
	current_bubble.position = position
	current_bubble.set_volume(bubble_vol)
	parent.add_child(current_bubble)
	parent.move_child(current_bubble, 0)
	current_bubble = null
