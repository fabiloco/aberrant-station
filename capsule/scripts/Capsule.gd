extends RigidBody3D

@onready var capsule_rotation_velocity = $Model/ControlStation/SubViewport/CapsuleRotationVelocity
@onready var station_rotation_velocity = $Model/ControlStation/SubViewport2/StationRotationVelocity
@onready var capsule_x_velocity = $Model/ControlStation/SubViewport3/CapsuleXVelocity
@onready var capsule_z_velocity = $Model/ControlStation/SubViewport4/CapsuleZVelocity
@onready var chair = $Model/Chair

@onready var eject_sound = $Model/ControlStation/EjectSound
@onready var scream_sound = $Model/ControlStation/ScreamSound

@onready var station = get_node("/root/Space/Station")
@onready var engine = $Engine
@onready var thursters = $Thursters
@onready var land_sound = $LandSound


# var station_rotation_speed = 0

var is_on_landing_area = false
var landed = false
var landing_started = false

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
	# station_rotation_speed = station.rotation_speed

func _physics_process(delta):
	if landed:
		# rotation.z = lerpf(rotation.z, 0, 1 * delta)
		return

	if landing_started:
		capsule_rotation_velocity.text = "%.1f m/s" % angular_velocity.z
		# station_rotation_velocity.text = "%.1f m/s" % station_rotation_speed
		capsule_x_velocity.text = "%.1f m/s" % velocity.z
		capsule_z_velocity.text = "%.1f m/s" % velocity.x
		
		thursters.volume_db = linear_to_db(dir.length())
		
		velocity.z = (dir.x * speed)
		velocity.x = (dir.y * speed)
		
		position.z += velocity.z * delta
		position.x -= velocity.x * delta

		# if (angular_velocity.z >= station_rotation_speed - 0.1 and angular_velocity.z <= station_rotation_speed + 0.1) and is_on_landing_area:
		if is_on_landing_area:
			land_capsule()

	rotation.x = 0
	rotation.y = 0

func rotate_right():
	apply_torque_impulse(Vector3(0, 0, -1 * rotation_force))

func rotate_left():
	# rotate_z(my_angular_velocity)
	apply_torque_impulse(Vector3(0, 0, 1 * rotation_force))

func _on_right_rot_button_interacted(_body:Variant):
	if landing_started:
		rotate_right()
	else:
		NoticeManager.add_notice({"title": "Sit in the chair to start the landing operation."})

func _on_left_rot_button_interacted(_body:Variant):
	if landing_started:
		rotate_left()
	else:
		NoticeManager.add_notice({"title": "Sit in the chair to start the landing operation."})

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
	
	engine.stop_with_fade_out()
	thursters.stop()
	
	land_sound.play()


func enter_station(_body):
	if landed:
		Globals.stage = "Stage2"
		get_tree().change_scene_to_file("res://ui/scenes/Loading.tscn")
	else:
		NoticeManager.add_notice({"title": "You have to land into the station first."})
		
func eject(body):
	eject_sound.play()
	scream_sound.play()
	body.is_sitting = false
	body.velocity = Vector3(0, 1, 0) * 100

func _on_chair_lading_started():
	landing_started = true
	engine.play_with_fade_in()
	thursters.play()
	get_tree().create_timer(3).timeout.connect( func (): NoticeManager.add_notice({"title": "To land the spaceship, align your position with that of the station and accelerate."}))
