extends RigidBody2D

@export var speed := 100.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var dir := Vector2(1, 0)

func _ready() -> void:
	animated_sprite_2d.play("Idle")
	
func _physics_process(delta: float) -> void:
	position += dir * delta * speed



func _on_scale_up_timer_timeout() -> void:
	animation_player.play("ScaleUp")


func _on_change_direction_timer_timeout() -> void:
	dir = Vector2(dir.x * -1.0, 0)
	animated_sprite_2d.flip_h = dir.x == -1
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		#Damage Player
		pass
