extends Node
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var nb_players := 0
var target_oxygen_level := 1000.0

func _ready() -> void:
	print(audio_stream_player_2d)
