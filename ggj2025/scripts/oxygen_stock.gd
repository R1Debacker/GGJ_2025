extends Node2D

@export var initial_stock := 0.0
var current_stock := 0.0
@onready var bubbles_spawn_position: Node2D = $SpawnPosition
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var stock_empty := false

func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	current_stock = initial_stock
	_spawn_bubble(bubbles_spawn_position.position)

func _on_spawn_timer_timeout() -> void:
	_spawn_bubble(bubbles_spawn_position.position + Vector2(randf_range(-60.0, 60.0), 0.0))
	$SpawnTimer.wait_time = randf_range(0.5, 2.0)

func _spawn_bubble(position):
	if current_stock > 0:
		var bubble_vol = randf_range(1.0, 5.0)
		Bubble.spawn_bubble(self, position, bubble_vol, true)
		audio_stream_player_2d.play()
		current_stock -= bubble_vol
		texture_progress_bar.value = (current_stock*1.0)/(initial_stock*1.0)
	elif !stock_empty:
		stock_empty = true
		var winner : Submarine = null
		for submarine in Game.submarines:
			if winner == null:
				winner = submarine
			elif submarine.current_oxygen_level > winner.current_oxygen_level:
				winner = submarine
		if winner != null: winner._victory()
