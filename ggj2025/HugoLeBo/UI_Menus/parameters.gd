extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	Game.menu_button_sound.play()
	get_tree().change_scene_to_file("res://HugoLeBo/UI_Menus/main_menu.tscn")
	pass # Replace with function body.
