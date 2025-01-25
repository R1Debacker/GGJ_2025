extends Node

@onready var menu_button_sound: AudioStreamPlayer2D = $menu_button_sound
@onready var bubble_pop: AudioStreamPlayer2D = $BubblePop

const BUBBLE = preload("res://scenes/bubble.tscn")
const MOVING_BUBBLE = preload("res://scenes/moving_bubble.tscn")

var nb_players := 0
var target_oxygen_level := 1000.0
