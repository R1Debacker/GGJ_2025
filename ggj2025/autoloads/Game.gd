extends Node

@onready var timer: Timer = $Timer
@onready var menu_button_sound: AudioStreamPlayer2D = $menu_button_sound
@onready var bubble_pop: AudioStreamPlayer2D = $BubblePop
@onready var back_sound: AudioStreamPlayer2D = $BackSound
@onready var ellie: AudioStreamPlayer2D = $Ellie
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic
@onready var bubble_pop_petites: AudioStreamPlayer2D = $"Bubble pop petites"
@onready var sylvain: AudioStreamPlayer2D = $Sylvain
@onready var beep: AudioStreamPlayer2D = $beep

const BUBBLE = preload("res://scenes/bubble.tscn")
const MOVING_BUBBLE = preload("res://scenes/moving_bubble.tscn")
const PLAYER = preload("res://scenes/player.tscn")
const SUBMARINE = preload("res://scenes/submarine.tscn")
var turn :int =0

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
var players_color : Array = []
var nb_players : int :
	get:
		return players.size()
const MAX_PLAYER := 10
var target_oxygen_level := 1000.0


func _on_timer_timeout() -> void:
	if turn ==0:
		ellie.play()
		turn =1
	elif turn ==1 :
		sylvain.play()
		turn = 0
	pass # Replace with function body.
