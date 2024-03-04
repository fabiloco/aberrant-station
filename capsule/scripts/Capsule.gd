extends RigidBody3D

var velocity = Vector3.ZERO

@export var velocity_label: Label
@export var station_velocity_label: Label

@onready var station = get_node("/root/Space/Station")

var station_rotation_speed = 0

var is_on_landing_area = false
var landed = false

var rotation_force = 1

func _ready():
	station_rotation_speed = station.rotation_speed

func _physics_process(delta):
	if landed: return

	var velocity_text = "\n %.1f m/s" % angular_velocity.z

	velocity_label.text = velocity_text
	station_velocity_label.text = "\n %.1f m/s" % station_rotation_speed


	position.z += velocity.x * delta
	position.x -= velocity.y * delta

	if (angular_velocity.z >= station_rotation_speed - 1 or angular_velocity.z <= station_rotation_speed + 1) and is_on_landing_area:
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
	get_parent().remove_child(self)
	station.add_child(self)
	station.landed = true
	landed = true
	freeze = true

	global_position = Vector3(0, 0, -12.141)
	rotation.y = deg_to_rad(180)
