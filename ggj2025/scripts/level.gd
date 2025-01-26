extends Node2D

@onready var start_submarine_spawn: Marker2D = $StartSubmarineSpawn
@onready var end_submarine_spawn: Marker2D = $EndSubmarineSpawn
@onready var players_container: Node2D = $PlayersContainer
@onready var submarine_container: Node2D = $SubmarineContainer
@onready var label: Label = $Label
@onready var timer: Timer = $Label/Timer

@export var wait_time: int = 5

func _ready() -> void:
	init_level()

func init_level():
	var rng = range(Game.nb_players)
	rng.shuffle()
	var sub_dir = (end_submarine_spawn.global_position - start_submarine_spawn.global_position).normalized()
	var sub_step = (end_submarine_spawn.global_position - start_submarine_spawn.global_position).length() / Game.nb_players
	var submarine_position = start_submarine_spawn.global_position
	for i in rng:
		var player_color = Game.players_color[i]
		var player_idx = Game.players_idx[i]
		
		## instanciate player
		var player = Game.PLAYER.instantiate()
		players_container.add_child(player)
		player.global_position = submarine_position
		player.player.device_idx = player_idx
		player.player.color = player_color
		player.player.active = false
		
		var submarine: Submarine  = Game.SUBMARINE.instantiate()
		submarine_container.add_child(submarine)
		submarine.animation_player.pause()
		submarine.global_position = submarine_position
		submarine.get_node("Localposition/VictoryPosition/Sprite2D").self_modulate = player.player.color
		submarine.player_index = player_idx
		submarine_position += sub_dir * sub_step
	
	self.timer.start()
	Game.beep.play()

func _on_timer_timeout() -> void:
	self.wait_time -= 1
	self.label.text = str(self.wait_time)
	if wait_time == 0:
		self.label.visible = false
		for submarine in submarine_container.get_children():
			submarine.animation_player.play()
		for player in players_container.get_children():
			player.player.active = true
		self.timer.stop()
	else:
		Game.beep.play()
