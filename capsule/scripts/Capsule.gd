extends RigidBody3D

@onready var capsule_rotation_velocity = $Model/ControlStation/SubViewport/CapsuleRotationVelocity
@onready var station_rotation_velocity = $Model/ControlStation/SubViewport2/StationRotationVelocity
@onready var capsule_x_velocity = $Model/ControlStation/SubViewport3/CapsuleXVelocity
@onready var capsule_z_velocity = $Model/ControlStation/SubViewport4/CapsuleZVelocity
@onready var chair = $Model/Chair


@onready var station = get_node("/root/Space/Station")

var station_rotation_speed = 0

var is_on_landing_area = false
var landed = false

var rotation_force = 50

var angular_vel = 0
var angular_acc = 0

var acceleration = Vector3.ZERO
var dir = Vector3.ZERO
var velocity = Vector3.ZERO
var speed = 2


func add_landing_task():
	TasksManager.add_task({"title": "Land the spachip into the station."})
	
func _ready():
	get_tree().create_timer(3).timeout.connect(add_landing_task)
	station_rotation_speed = station.rotation_speed

func _physics_process(delta):
	if landed:
		rotation.z = lerpf(rotation.z, 0, station.rotation_speed * delta)
		return

	capsule_rotation_velocity.text = "%.1f m/s" % angular_velocity.z
	station_rotation_velocity.text = "%.1f m/s" % station_rotation_speed
	capsule_x_velocity.text = "%.1f m/s" % velocity.z
	capsule_z_velocity.text = "%.1f m/s" % velocity.x
	
	velocity.z = (dir.x * speed)
	velocity.x = (dir.y * speed)
	
	position.z += velocity.z * delta
	position.x -= velocity.x * delta

	if (angular_velocity.z >= station_rotation_speed - 0.1 and angular_velocity.z <= station_rotation_speed + 0.1) and is_on_landing_area:
		land_capsule()

	rotation.x = 0
	rotation.y = 0

func rotate_right():
	apply_torque_impulse(Vector3(0, 0, -1 * rotation_force))

func rotate_left():
	# rotate_z(my_angular_velocity)
	apply_torque_impulse(Vector3(0, 0, 1 * rotation_force))

func _on_right_rot_button_interacted(_body:Variant):
	rotate_right()

func _on_left_rot_button_interacted(_body:Variant):
	rotate_left()

func _on_area_3d_area_entered(_area):
	is_on_landing_area = true

func _on_area_3d_area_exited(_area):
	is_on_landing_area = false


func land_capsule():
	TasksManager.add_task({"done": false, "title": "Spaceship landed. Enter into the station."})
	chair.can_stand_up = true
	get_parent().remove_child(self)
	station.add_child(self)
	station.landed = true
	landed = true
	freeze = true

	global_position = Vector3(0, 0, -7.8)
	rotation.y = deg_to_rad(180)


func enter_station(_body):
	# change in final build
	#if landed:
	#	Globals.stage = "Stage2"
	#	get_tree().change_scene_to_file("res://ui/scenes/Loading.tscn")
	Globals.stage = "Stage2"
	get_tree().change_scene_to_file("res://ui/scenes/Loading.tscn")
		
func eject(body):
	body.is_sitting = false
	body.velocity = Vector3(0, 1, 0) * 200
	
