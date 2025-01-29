extends RigidBody2D

@export var damage_amount := 100.0
@export var enemy_speed := 300.0
@export var distance_patrol := 600.0

var current_target : Node2D = null
var origin_position := Vector2.ZERO
var target_position := Vector2.ZERO
var direction_idle_movement := Vector2(1,0)
var is_time_to_check_distance := false

@onready var following_time: Timer = $FollowingTime
@onready var enemy_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var idle_movement: Timer = $IdleMovement
@onready var going_back_timer: Timer = $GoingBackTimer
@onready var radar_area: Area2D = $RadarArea
@onready var check_distance_when_follow: Timer = $CheckDistanceWhenFollow



enum STATE{
	GOINGBACK,
	FOLLOW,
	PATROL
}

var state :=STATE.PATROL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_sprite.play('Idle')
	origin_position=global_position
	idle_movement.wait_time=distance_patrol/enemy_speed
	idle_movement.start()

func _on_radar_area_area_entered(area: Area2D) -> void:
	if area is Bubble and area.air_volume>0 and !area.moving_active and state!=STATE.FOLLOW :
		state=STATE.FOLLOW
		current_target = area
		following_time.start()
		check_distance_when_follow.start()
		print('timer in')

func _follow(delta: float):
	
	look_at(current_target.global_position)
	enemy_sprite.flip_v = current_target.global_position.x<global_position.x
	global_position=global_position.move_toward(current_target.global_position,delta*enemy_speed)
	if global_position.distance_to(current_target.global_position)>450 and is_time_to_check_distance:
		current_target=null
		state=STATE.GOINGBACK
		print('ça lache l affaire')

func _on_body_area_area_entered(area: Area2D) -> void:
	
	if area is Bubble:
		if area.air_volume>damage_amount:
			area.add_volume(-damage_amount)
		else:
			area.set_volume(0)
		state=STATE.GOINGBACK
		going_back_timer.start()
		current_target = null
	
func _patrol_movement(delta: float):
	
	look_at(position+50.0*direction_idle_movement)
	enemy_sprite.flip_v = direction_idle_movement.x<0
	global_position+=direction_idle_movement*delta*enemy_speed
	
func _going_back(delta: float):
	
	look_at(origin_position)
	enemy_sprite.flip_v = origin_position.x<global_position.x
	global_position=global_position.move_toward(origin_position,delta*enemy_speed)
	if global_position-global_position.move_toward(origin_position,delta*enemy_speed)==Vector2.ZERO:
	
		state=STATE.PATROL
	
func _physics_process(delta: float) -> void:
	
	match(state):
		STATE.FOLLOW:
			if current_target != null:
				_follow(delta)
			else:
				state = STATE.GOINGBACK
		STATE.GOINGBACK:
			is_time_to_check_distance=false
			_going_back(delta)
		STATE.PATROL:
			_patrol_movement(delta)
			

func _on_following_time_timeout() -> void:
	
	if state==STATE.FOLLOW:
		state=STATE.GOINGBACK
		going_back_timer.start()
		current_target = null
		
		
func _on_idle_movement_timeout() -> void:
	
	direction_idle_movement=Vector2(direction_idle_movement.x*-1.0,0)


func _on_going_back_timer_timeout() -> void:
	
	origin_position=global_position
	state=STATE.PATROL
	for area in radar_area.get_overlapping_areas():
		
		if area is Bubble and !area.moving_active:
			current_target=area
			state=STATE.FOLLOW
	
	


func _on_check_distance_when_follow_timeout() -> void:
	print('timer out')
	is_time_to_check_distance=true
