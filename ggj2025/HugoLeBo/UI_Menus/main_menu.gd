extends Control

func _on_start_button_pressed() -> void:
	Game.menu_button_sound.play()
	get_tree().change_scene_to_file("res://Erwann le carry/test_erwann.tscn")
	
func _on_parameters_button_pressed() -> void:
	Game.menu_button_sound.play()
	get_tree().change_scene_to_file("res://HugoLeBo/UI_Menus/parameters.tscn")

func _on_exit_button_pressed() -> void:
	Game.menu_button_sound.play()
	await Game.menu_button_sound.finished
	get_tree().quit()
