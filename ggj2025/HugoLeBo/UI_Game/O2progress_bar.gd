extends TextureProgressBar
@export var Submarine : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x=(Submarine.position.x)-34
	position.y=(Submarine.position.y)-4
	pass
