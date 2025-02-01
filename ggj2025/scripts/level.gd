extends Node2D

@onready var start_submarine_spawn: Marker2D = $StartSubmarineSpawn
@onready var end_submarine_spawn: Marker2D = $EndSubmarineSpawn
@onready var players_container: Node2D = $PlayersContainer
@onready var submarine_container: Node2D = $SubmarineContainer
@onready var label: Label = $Label
@onready var timer: Timer = $Label/Timer
@onready var win_submarine_respawn_start: Marker2D = $WinSubmarineRespawnStart
@onready var win_submarine_respawn_end: Marker2D = $WinSubmarineRespawnEnd

@export var wait_time: int = 5

func _ready() -> void:
	init_level()

func init_level():
	var rng = range(Game.nb_players)
	rng.shuffle()
	var sub_dir = (end_submarine_spawn.global_position - start_submarine_spawn.global_position).normalized()
	var sub_step = (end_submarine_spawn.global_position - start_submarine_spawn.global_position).length() / Game.nb_players
	var j := 0
	for i in rng:
		var player_color = Game.players_color[i]
		var player_idx = Game.players_idx[i]
		var t : float = 0.0
		if Game.nb_players >= 2:
			t = (float(j)/(Game.nb_players-1))
		
		var submarine_position = (1-t)*start_submarine_spawn.global_position + t*end_submarine_spawn.global_position
		
		## instanciate player
		var player = Game.PLAYER.instantiate()
		players_container.add_child(player)
		player.global_position = submarine_position
		player.player.device_idx = player_idx
		player.player.color = player_color
		player.player.active = false
		
		## instanciate submarine
		var submarine: Submarine  = Game.SUBMARINE.instantiate()
		submarine_container.add_child(submarine)
		submarine.animation_player.stop()
		submarine.disable = true
		submarine.global_position = submarine_position
		submarine.get_node("Localposition/VictoryPosition/Sprite2D").self_modulate = player.player.color
		Game.submarines.append(submarine)
		submarine.player_win.connect(_on_submarine_win)
		submarine.current_shrimp = player.player
		submarine.start_node = start_submarine_spawn
		submarine.end_node = end_submarine_spawn
		submarine.t = t
		
		j += 1
	
	self.timer.start()
	Game.beep.play()

func _on_timer_timeout() -> void:
	self.wait_time -= 1
	self.label.text = str(self.wait_time)
	if wait_time == 0:
		self.label.visible = false
		for submarine in submarine_container.get_children():
			submarine.disable = false
		for player in players_container.get_children():
			player.player.active = true
		self.timer.stop()
		Game.okaaaaay_letsgo.play()
	else:
		Game.beep.play()

func _on_submarine_win(old_submarine : Submarine):
	## instanciate submarine
	var submarine: Submarine  = Game.SUBMARINE.instantiate()
	submarine_container.add_child(submarine)
	submarine.animation_player.stop()
	submarine.position = win_submarine_respawn_start.global_position
	submarine.get_node("Localposition/VictoryPosition/Sprite2D").self_modulate = old_submarine.current_shrimp.color
	submarine.start_node = win_submarine_respawn_start
	submarine.end_node = win_submarine_respawn_end
	submarine.scale = submarine.scale * 4
	submarine.t = 0
	submarine.speed = 0.08
	submarine.current_oxygen_level = old_submarine.current_oxygen_level
	submarine.z_index = 9 #just before water shader
