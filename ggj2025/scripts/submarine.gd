extends Node2D
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@export var filling_speed := 50.0
@export var target_oxygen_level := 1000.0

var current_oxygen_level := 500.0
var current_shrimp : CharacterBody2D = null

func _ready() -> void:
	$AnimationPlayer.play("vertical_animation")

func _process(delta: float) -> void:
	if current_shrimp != null:
		current_oxygen_level += filling_speed * delta
		if current_oxygen_level > target_oxygen_level:
			_victory()
	texture_progress_bar.value=current_oxygen_level

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D && current_shrimp == null:
		current_shrimp = body



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body == current_shrimp: 
		current_shrimp = null
		_find_shrimp_in_area()

func _victory():
	print("victory")
	pass

func _find_shrimp_in_area():
	if $Sprite2D/Area2D.has_overlapping_bodies():
		for body in $Sprite2D/Area2D.get_overlapping_bodies():
			if body is CharacterBody2D:
				current_shrimp = body
				return
