extends Node2D

@onready var spawn_position: Node2D = $SpawnPosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for device_idx in range(Game.MAX_PLAYER):
		if device_idx in Game.players_idx:
			continue
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_A):
			Game.players_idx.append(device_idx)
			var player = Game.PLAYER.instantiate()
			add_child(player)
			player.global_position = spawn_position.global_position
			player.player.device_idx = device_idx
			player.player.color = Game.avail_colors.pop_front()
			Game.players.append(player)
			Game.players_color.append(player.player.color)
	
	for device_idx in Game.players_idx:
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_START):
			start()
