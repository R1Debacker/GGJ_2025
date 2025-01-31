extends Area2D
class_name Bubble

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const SPLIT_KEEP_PERCENT = 0.7

var bubble_scale : float = 1
var AIR_VOLUME_SCALE : float = 1
var air_volume : float
var air_factor = sqrt(AIR_VOLUME_SCALE / PI)
var player_owner : Player = null
var has_owner : bool :
	get:
		return self.player_owner != null

var moving_active : bool = false
var invicibility := false

func _ready() -> void:
	set_volume(AIR_VOLUME_SCALE)

func remove_owner():
	if has_owner:
		self.player_owner.bubble = null
		self.player_owner.bubble_parent.call_deferred("remove_child", self)
	else:
		self.get_parent().call_deferred("remove_child", self)
	self.player_owner = null

func switch_owner(new_owner):
	self.moving_active = false
	new_owner.bubble_parent.call_deferred("add_child", self)
	self.position = Vector2(0,0)
	self.player_owner = new_owner
	new_owner.bubble = self

func _on_body_entered(body: Node) -> void:
	if body.has_method("collect"):
		if self == body.bubble or invicibility:
			return
		body.collect(self)

func _burst_bubble():
	invicibility = true
	if self.air_volume > 18:
		Game.souffrir_ok.play()
	self.air_volume=0
	animated_sprite_2d.play('Burst')
	
func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func set_volume(new_vol : float):
	if new_vol < 1e-2:
		if animated_sprite_2d != null:
			_burst_bubble()
			return
	bubble_scale = sqrt(new_vol / PI)
	self.scale = Vector2(bubble_scale / air_factor , bubble_scale / air_factor)
	self.air_volume = new_vol

func add_volume(added_vol : float):
	self.bubble_scale = sqrt((max(added_vol + air_volume, 0))/PI)
	self.set_volume((self.bubble_scale**2)*PI)

func split():
	var new_air_vol = self.air_volume * SPLIT_KEEP_PERCENT
	var lost_air_vol = self.air_volume * (1-SPLIT_KEEP_PERCENT)
	self.set_volume(new_air_vol)
	Bubble.spawn_bubble(Game.current_scene, self.global_position, lost_air_vol)

static func spawn_bubble(parent: Node2D, position: Vector2, bubble_vol: float, moving_bubble=true):	
	var current_bubble = null
	if moving_bubble:
		current_bubble = Game.MOVING_BUBBLE.instantiate()
	else:
		current_bubble = Game.BUBBLE.instantiate()
	current_bubble.position = position
	current_bubble.set_volume(bubble_vol)
	parent.add_child(current_bubble)
	return current_bubble
