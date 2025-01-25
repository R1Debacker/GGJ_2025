extends Node2D

@export var initial_stock := 0.0
const COLLECTABLE_BUBBLE = preload("res://scenes/collectable_bubble.tscn")

func _ready() -> void:
	initial_stock = 1000.0
	_spawn_bubble()
	


func _on_spawn_timer_timeout() -> void:
	_spawn_bubble()
	$SpawnTimer.wait_time = randf_range(3.0, 5.0)

func _spawn_bubble():
	if initial_stock > 0:
		var collectable_bubble = COLLECTABLE_BUBBLE.instantiate()
		collectable_bubble.position = $BubblesSpawnPosition.position
		var bubble_size = randf_range(1.0, 3.0)
		collectable_bubble._set_scale(bubble_size)
		initial_stock -= bubble_size * 10.0
		add_child(collectable_bubble)
