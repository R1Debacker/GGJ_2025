extends RigidBody2D

@export var damage_amount := 100.0
@export var enemy_speed := 300.0
@export var distance_patrol := 300.0

var current_target : Node2D = null
var target_position := Vector2.ZERO
var direction_patrol_movement := Vector2(0,1)

@onready var radar_area_2d: Area2D = $RadarArea2D
@onready var patrol_timer: Timer = $PatrolTimer
@onready var time_before_charge: Timer = $TimeBeforeCharge
@onready var dart_fish_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var in_radar_time: Timer = $InRadarTime


enum STATE{
	PREPARE,
	CHARGE,
	PATROL
}

var state :=STATE.PATROL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	dart_fish_sprite.play('Idle')
	patrol_timer.wait_time= distance_patrol/enemy_speed
	patrol_timer.start()
	
func _prepare(delta: float):
	look_at(current_target.global_position)
	dart_fish_sprite.flip_v = current_target.global_position.x<global_position.x
	
func _charge(delta: float):
	
	look_at(target_position)
	dart_fish_sprite.flip_v = target_position.x<global_position.x
	global_position=global_position.move_toward(target_position,delta*enemy_speed)
	
	if global_position==target_position:

		state=STATE.PATROL
		in_radar_time.start()
	
	
func _patrol_movement(delta: float):

	look_at(position+50.0*direction_patrol_movement)
	#dart_fish_sprite.flip_v = direction_patrol_movement.y>0
	global_position+=direction_patrol_movement*delta*100.0
	
func _physics_process(delta: float) -> void:

	match(state):
		STATE.PREPARE:
			if current_target != null:
				_prepare(delta)
			else:
				state = STATE.PATROL
		STATE.PATROL:
			_patrol_movement(delta)
		STATE.CHARGE:
			_charge(delta)
			

func _on_time_before_charge_timeout() -> void:
	if current_target != null:
		target_position=current_target.global_position
		state=STATE.CHARGE


func _on_patrol_timer_timeout() -> void:
	
	direction_patrol_movement=Vector2(0,direction_patrol_movement.y*-1.0)
	if state==STATE.PATROL:
		rotate(PI)


func _on_radar_area_2d_area_entered(area: Area2D) -> void:
	if area is Bubble and area.air_volume>0 and !area.moving_active and state==STATE.PATROL :
		time_before_charge.wait_time=randi() % 3+2 # Entre 2 et 4
		state=STATE.PREPARE
		current_target=area
		time_before_charge.start()


func _on_nose_area_2d_area_entered(area: Area2D) -> void:
	
	if area is Bubble :
		if !area.moving_active:
			if area.air_volume>damage_amount:
				area.add_volume(-damage_amount)
			else:
				area.set_volume(0)
			state=STATE.PATROL
			current_target = null
		else:
			area._burst_bubble()

func _on_in_radar_time_timeout() -> void:
	
	for area in radar_area_2d.get_overlapping_areas():
		
		if area is Bubble and !area.moving_active:
			current_target=area
			state=STATE.PREPARE
			time_before_charge.wait_time=randi() % 3+2 # Entre 2 et 4
			time_before_charge.start()
			
			
