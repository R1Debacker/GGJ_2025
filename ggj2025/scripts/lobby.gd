extends Node2D

@onready var spawn_position: Node2D = $SpawnPosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_players()
	pass # Replace with function body.

func _spawn_player(idx : int, position: Vector2, color: Color):
	var player = Game.PLAYER.instantiate()
	add_child(player)
	player.global_position = position
	player.player.device_idx = idx
	player.player.color = color
	return player

func _spawn_players():
	for i in range(Game.nb_players):
		var player_color = Game.players_color[i]
		var player_idx = Game.players_idx[i]
		_spawn_player(player_idx, spawn_position.global_position, player_color)
	
func start():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for device_idx in range(Game.MAX_PLAYER):
		if device_idx in Game.players_idx:
			continue
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_A):
			Game.players_idx.append(device_idx)
			var player_color = Game.avail_colors.pop_front()
			var player = _spawn_player(
				device_idx,
				spawn_position.global_position,
				player_color
			)
			Game.players.append(player)
			Game.players_color.append(player_color)
	
	for device_idx in Game.players_idx:
		if Input.is_joy_button_pressed(device_idx, JOY_BUTTON_START):
			start()
