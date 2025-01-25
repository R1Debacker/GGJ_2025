extends Node2D

@export var damage_amount := 50.0
@export var speed_factor := 0.6
@export var distance_to_touch := 25.0
var enemy_speed := 300.0
var current_target : Node2D = null
var origin_position := Vector2.ZERO
@onready var following_time: Timer = $FollowingTime
@onready var enemy_sprite: AnimatedSprite2D = $AnimatedSprite2D


enum STATE{
	IDLE,
	FOLLOW
}

var state :=STATE.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_sprite.play('Idle')
	origin_position=global_position
	pass # Replace with function body.

func _on_body_entered(body: Node) -> void:
	
	if body is Player and state==STATE.FOLLOW :
		state=STATE.IDLE
		current_target = null

func _on_radar_area_body_entered(body: Node2D) -> void:

	if body is Player and state==STATE.IDLE :

		state=STATE.FOLLOW
		current_target=body
		enemy_speed=speed_factor*current_target.player_speed*0.7
		following_time.start()

		
func _follow(delta: float):
	
	look_at(current_target.global_position)
	enemy_sprite.flip_v = current_target.global_position.x<global_position.x
	global_position=global_position.move_toward(current_target.global_position,delta*enemy_speed)
	if $Beak.global_position.distance_to(current_target.global_position)<3.0:
		_on_body_entered(current_target)
	
func _idle_movement(delta: float):
	
	look_at(origin_position)
	enemy_sprite.flip_v = origin_position.x<global_position.x
	global_position=global_position.move_toward(origin_position,delta*enemy_speed)
	
	
func _physics_process(delta: float) -> void:

	match(state):
		STATE.FOLLOW:
			_follow(delta)
		STATE.IDLE:
			_idle_movement(delta)
			#se balader
			
			

func _on_following_time_timeout() -> void:
	
	if state==STATE.FOLLOW:
		state=STATE.IDLE
		current_target = null
