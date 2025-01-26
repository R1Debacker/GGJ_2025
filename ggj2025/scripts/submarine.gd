extends Node2D
class_name Submarine
@onready var texture_progress_bar: TextureProgressBar = $Localposition/VictoryPosition/TextureProgressBar
@export var filling_speed := 50.0
@export var target_oxygen_level := 1000.0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player_index := 0
var current_oxygen_level := 0.0
var current_shrimp : CharacterBody2D = null
var victory := false

func _ready() -> void:
	$AnimationPlayer.play("vertical_animation")
	
func _process(delta: float) -> void:
	if current_shrimp != null && current_shrimp.device_idx == player_index && current_shrimp.has_bubble && current_shrimp.bubble.air_volume > 0.0:
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player && current_shrimp == null:
		current_shrimp = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body == current_shrimp: 
		current_shrimp = null
		_find_shrimp_in_area()

func _victory():
	victory = true
	animation_player.play("victory")
	Game.back_sound.stop()
	Game.we_did_it.play()

func _find_shrimp_in_area():
	if $Localposition/VictoryPosition/Sprite2D/Area2D.has_overlapping_bodies():
		for body in $Localposition/VictoryPosition/Sprite2D/Area2D.get_overlapping_bodies():
			if body is CharacterBody2D:
				current_shrimp = body
				return
