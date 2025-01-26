extends Node
@onready var timer: Timer = $Timer
@onready var menu_button_sound: AudioStreamPlayer2D = $menu_button_sound
@onready var bubble_pop: AudioStreamPlayer2D = $BubblePop
@onready var back_sound: AudioStreamPlayer2D = $BackSound
@onready var ellie: AudioStreamPlayer2D = $Ellie
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic
@onready var bubble_pop_petites: AudioStreamPlayer2D = $"Bubble pop petites"


const BUBBLE = preload("res://scenes/bubble.tscn")
const MOVING_BUBBLE = preload("res://scenes/moving_bubble.tscn")

var nb_players := 0
var target_oxygen_level := 1000.0


func _on_timer_timeout() -> void:
	ellie.play()
	pass # Replace with function body.
