extends TextureProgressBar
@export var blink := false
@export var gradient : Gradient = null
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_blinking : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_blinking = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self_modulate = gradient.sample(ratio)
	if (ratio>0.8 && is_blinking==false && blink):
		animation_player.play("clignotte")
		is_blinking = true
