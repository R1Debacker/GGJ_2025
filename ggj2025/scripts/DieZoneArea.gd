extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.get_child(0) is Bubble:
		body.get_child(0).set_volume(0)
		Game.bubble_pop.play()
