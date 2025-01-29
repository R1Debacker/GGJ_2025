extends Area2D

@export var speed : float = 600.0
@onready var timer: Timer = $Timer
@onready var effect_offset_timer: Timer = $EffectOffsetTimer
@onready var courant_effect_timer: Timer = $CourantEffectTimer
@onready var courant_effect_1: Node2D = $CourantEffect1
@onready var courant_effect_2: Node2D = $CourantEffect2
const COURANT_EFFECT = preload("res://scenes/courant_effect.tscn")
var players = []

func _physics_process(delta: float) -> void:

	for player in players:
		player.env_velocity = Vector2(cos(rotation), sin(rotation)) * speed

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		if not players.has(body):
			players.append(body)


func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		if players.has(body):
			var idx = players.find(body)
			if idx != -1:
				players.remove_at(idx)


func _on_timer_timeout() -> void:
	rotation=rotation-PI


func _on_courant_effect_timer_timeout() -> void:
	var courant_effect = COURANT_EFFECT.instantiate()
	courant_effect_1.add_child(courant_effect)
	courant_effect.position = Vector2.ZERO
	effect_offset_timer.start()


func _on_effect_offset_timer_timeout() -> void:
	var courant_effect = COURANT_EFFECT.instantiate()
	courant_effect_2.add_child(courant_effect)
	courant_effect.position = Vector2.ZERO
	courant_effect_timer.start()
