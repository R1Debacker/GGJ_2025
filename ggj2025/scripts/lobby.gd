extends Node2D

@onready var spawn_position: Node2D = $SubViewport/Scene/SpawnPosition
@onready var level_1: Button = $"PanelContainer/MapSelection/VBoxContainer/Level 1"
@onready var game_view: TextureRect = $GameView
@onready var scene: Node2D = $SubViewport/Scene
@onready var map_selection: PanelContainer = $PanelContainer/MapSelection

var is_start_pressed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.current_scene = scene
	_spawn_players()
	pass # Replace with function body.

func _spawn_player(idx : int, position: Vector2, color: Color):
	var player = Game.PLAYER.instantiate()
	scene.add_child(player)
	player.global_position = position
	player.player.device_idx = idx
	player.player.color = color
	return player

func _spawn_players():
	for i in range(Game.nb_players):
		var player_color = Game.players_color[i]
		var player_idx = Game.players_idx[i]
		_spawn_player(player_idx, spawn_position.global_position, player_color)

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
		
	if Input.is_action_just_pressed("ui_map_select"):
		map_selection.visible = not map_selection.visible
		game_view.material.set_shader_parameter("blur_size", 8.0 * float(map_selection.visible))
		if map_selection.visible:
			level_1.grab_focus()

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")

func _on_back_pressed() -> void:
	map_selection.visible = not map_selection.visible
	game_view.material.set_shader_parameter("blur_size", 0)
