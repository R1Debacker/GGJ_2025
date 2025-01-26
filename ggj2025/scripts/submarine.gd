extends Node2D
class_name Submarine
@onready var texture_progress_bar: TextureProgressBar = $Localposition/VictoryPosition/TextureProgressBar
@export var filling_speed := 50.0
@export var target_oxygen_level := 1000.0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_oxygen_level := 0.0
var current_shrimp : CharacterBody2D = null
var victory := false

var start_position : Vector2
var end_position : Vector2
var t : float = 0
var use_lerp : bool :
	get:
		return start_position != null and end_position != null
var direction = 1
@export var speed : float = 0.04
var disable := false
var r : float = randf_range(0.9,1.1)
@export var distance_to_fill : float = 60.0

func _ready() -> void:
	if use_lerp:
		animation_player.play("vertical_animation")
	else:
		animation_player.stop()
	
func _process(delta: float) -> void:
	if self.disable:
		return
	if use_lerp:
		# Update the interpolation factor
		t += direction * speed * delta * r

		# Reverse direction if limits are reached
		if t >= 1.0:
			t = 1.0
			direction = -1.0
		elif t <= 0.0:
			t = 0.0
			direction = 1.0

		# Interpolate between the positions
		position = lerp(start_position, end_position,  t * t * (3.0 - 2.0 * t))
	
	var dist_to_shrimp : float = (self.global_position - self.current_shrimp.global_position).length()
	if current_shrimp != null && dist_to_shrimp <= distance_to_fill && current_shrimp.has_bubble && current_shrimp.bubble.air_volume > 0.0:
		if audio_stream_player_2d.is_playing() == false:
				audio_stream_player_2d.play()
		var oxygen_value := filling_speed * delta
		if oxygen_value < current_shrimp.bubble.air_volume:
			current_oxygen_level += oxygen_value
			current_shrimp.bubble.add_volume(-oxygen_value)
		else:
			current_shrimp.bubble.set_volume(0.0)
			current_oxygen_level += current_shrimp.bubble.air_volume
		if current_oxygen_level > target_oxygen_level:
			if !victory:
				_victory()
	else :
		audio_stream_player_2d.stop()
	texture_progress_bar.value= (current_oxygen_level*1.0)/(target_oxygen_level*1.0)

func _victory():
	victory = true
	animation_player.play("victory")
	Game.back_sound.stop()
	Game.we_did_it.play()
