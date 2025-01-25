extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	pass # Replace with function body.
	Game.menu_button_sound.play()
	#get_tree().change_scene_to_file()
	
func _on_parameters_button_pressed() -> void:
	Game.menu_button_sound.play()
	get_tree().change_scene_to_file("res://HugoLeBo/UI_Menus/parameters.tscn")
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	Game.menu_button_sound.play()
	await Game.menu_button_sound.finished
	get_tree().quit()
	pass # Replace with function body.
