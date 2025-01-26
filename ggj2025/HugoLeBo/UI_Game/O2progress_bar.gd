extends TextureProgressBar
@export var Submarine : Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var condition : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	condition = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x=(Submarine.position.x)-34
	position.y=(Submarine.position.y)-4
	if (ratio>0.8 && condition==false):
		animation_player.play("clignotte")
		condition = true
	pass
