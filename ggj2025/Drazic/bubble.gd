extends Node
class_name Bubble

const COLLECTABLE_BUBBLE = preload("res://scenes/collectable_bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func spawn_bubble(parent: Node2D, position: Vector2, bubble_size: float):	
	var collectable_bubble = COLLECTABLE_BUBBLE.instantiate()
	collectable_bubble.position = position
	collectable_bubble._set_scale(bubble_size)
	parent.add_child(collectable_bubble)
