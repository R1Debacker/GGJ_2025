extends Node2D

@export var initial_stock := 0.0
const COLLECTABLE_BUBBLE = preload("res://scenes/collectable_bubble.tscn")
@onready var bubbles_spawn_position: Node2D = $SpawnPosition
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	initial_stock = 1000.0
	_spawn_bubble(bubbles_spawn_position.position)


func _on_spawn_timer_timeout() -> void:
	_spawn_bubble(bubbles_spawn_position.position)
	$SpawnTimer.wait_time = randf_range(3.0, 5.0)

func _spawn_bubble(position):
	if initial_stock > 0:
		var bubble_size = randf_range(1.0, 3.0)
		var collectable_bubble = Bubble.spawn_bubble(self, position, bubble_size)
		initial_stock-=bubble_size*10
		texture_progress_bar.value=initial_stock
