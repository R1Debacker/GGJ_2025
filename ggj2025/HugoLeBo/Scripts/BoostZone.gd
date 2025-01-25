extends Area2D

@export var speed : float = 10

var players = []

func _physics_process(delta: float) -> void:
	for player in players:
		player.env_velocity = Vector2(cos(rotation), sin(rotation)) * speed

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		if not players.has(body):
			players.append(body)
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		if players.has(body):
			var idx = players.find(body)
			if idx != -1:
				players.remove_at(idx)
	print(players)
	pass # Replace with function body.
