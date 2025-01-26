extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in range(25):
		print(randi() % 4+2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
