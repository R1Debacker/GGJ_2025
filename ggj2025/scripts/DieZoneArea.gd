extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area is Bubble:
		area.set_volume(0)
		Game.bubble_pop.play()
