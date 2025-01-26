extends Area2D

@export var speed := 100.0
@export var damage_amount := 100.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var dir := Vector2(1, 0)

func _ready() -> void:
	animated_sprite_2d.play("Idle")
	
func _physics_process(delta: float) -> void:
	position += dir * delta * speed
	for area in get_overlapping_areas():
		if area is Bubble:
			#area.add_volume(-damage_amount * scale.x * delta)
			area._burst_bubble()

func _on_scale_up_timer_timeout() -> void:
	animation_player.play("ScaleUp")
	animated_sprite_2d.play("Globe")

func _on_change_direction_timer_timeout() -> void:
	dir = Vector2(dir.x * -1.0, 0)
	animated_sprite_2d.flip_h = dir.x == -1


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animated_sprite_2d.play("Idle")
