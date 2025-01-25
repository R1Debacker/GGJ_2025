extends RigidBody2D

@export var damage_amount := 50.0
@export var enemy_speed := 300.0
var current_target : Node2D = null
var target_position := Vector2.ZERO
var direction_patrol_movement := Vector2(0,1)

@onready var patrol_timer: Timer = $PatrolTimer
@onready var time_before_charge: Timer = $TimeBeforeCharge
@onready var dart_fish_sprite: AnimatedSprite2D = $AnimatedSprite2D


enum STATE{
	PREPARE,
	CHARGE,
	PATROL
}

var state :=STATE.PATROL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	dart_fish_sprite.play('Idle')
	patrol_timer.wait_time= 200.0/enemy_speed
	patrol_timer.start()

func _on_radar_area_2d_body_entered(body: Node2D) -> void:

	if body.get_child(0) is Bubble and state==STATE.PATROL :

		state=STATE.PREPARE
		current_target=body.get_child(0)
		time_before_charge.start()
	
func _prepare(delta: float):

	look_at(current_target.global_position)
	dart_fish_sprite.flip_v = current_target.global_position.x<global_position.x
	
func _charge(delta: float):
	
	look_at(target_position)
	dart_fish_sprite.flip_v = target_position.x<global_position.x
	global_position=global_position.move_toward(target_position,delta*enemy_speed)
	
	if global_position==target_position:
		print('arreté')
		state=STATE.PATROL
	
func _on_nose_area_2d_body_entered(body: Node2D) -> void:

	if body.get_child(0) is Bubble and state==STATE.CHARGE :
		
		if body.get_child(0).air_volume>damage_amount:
			body.get_child(0).add_volume(-damage_amount)
		else:
			body.get_child(0).set_volume(0)
		
		state=STATE.PATROL
		current_target = null
	
func _patrol_movement(delta: float):

	look_at(position+50.0*direction_patrol_movement)
	#dart_fish_sprite.flip_v = direction_patrol_movement.y>0
	global_position+=direction_patrol_movement*delta*100.0
	
func _physics_process(delta: float) -> void:

	match(state):
		STATE.PREPARE:
			_prepare(delta)
		STATE.PATROL:
			_patrol_movement(delta)
		STATE.CHARGE:
			_charge(delta)
			

func _on_time_before_charge_timeout() -> void:
	
	target_position=current_target.global_position
	state=STATE.CHARGE


func _on_patrol_timer_timeout() -> void:
	
	direction_patrol_movement=Vector2(0,direction_patrol_movement.y*-1.0)
	if state==STATE.PATROL:
		rotate(PI)
