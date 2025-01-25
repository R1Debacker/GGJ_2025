extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		body.factor=1
		body.direction =Vector2(cos(rotation), sin(rotation))
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		body.factor=0.5
	pass # Replace with function body.
