extends Node

@onready var menu_button_sound: AudioStreamPlayer2D = $menu_button_sound

const BUBBLE = preload("res://scenes/bubble.tscn")
const MOVING_BUBBLE = preload("res://scenes/moving_bubble.tscn")
const PLAYER = preload("res://scenes/player.tscn")
const SUBMARINE = preload("res://scenes/submarine.tscn")

var avail_colors := [
	Color.LIGHT_CORAL,
	Color.CORNFLOWER_BLUE,
	Color.GREEN,
	Color.CORAL,
	Color.BLACK,
	Color.ALICE_BLUE,
	Color.YELLOW,
	Color.DARK_MAGENTA,
	Color.DARK_ORANGE,
	Color.AQUA,
]

var players : Array = []
var players_idx : Array = []
var nb_players : int :
	get:
		return players.size()
const MAX_PLAYER := 10
var target_oxygen_level := 1000.0
