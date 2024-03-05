extends CharacterBody3D

class_name Player

@export_category("Speed variables")
@export var walking_speed = 5.0
@export var sprinting_speed = 8.0
@export var crouching_speed = 3.0

@export_category("Conrtol variables")
@export var mouse_sens = 0.25 
@export var lerp_speed = 10 

@onready var head = $Head	
@onready var standing_collison_shape = $StandingCollisionShape	
@onready var crouching_collison_shape = $CrouchingCollisionShape
@onready var crouching_ray_cast = $CroucingRayCast

var current_speed = walking_speed

var jump_velocity = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var direction = Vector3.ZERO

var crouching_depth = 0.5

# sitting variables
var is_sitting = false
var active_chair: Chair

@onready var space = get_node("/root/Space")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta):
	if is_sitting and active_chair != null: 
		global_position = active_chair.global_position
		if Input.is_action_just_pressed("leave"):
			is_sitting = false

			get_parent().remove_child(self)
			space.add_child(self)

			global_position = active_chair.global_position

			active_chair = null
		return

	# handling movement state
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		head.position.y = lerp(head.position.y, 1.8 - crouching_depth, delta * lerp_speed)
		standing_collison_shape.disabled = true
		crouching_collison_shape.disabled = false
	elif not crouching_ray_cast.is_colliding():

		head.position.y = lerp(head.position.y, 1.8, delta * lerp_speed)
		standing_collison_shape.disabled = false
		crouching_collison_shape.disabled = true
		if Input.is_action_pressed("sprint"):
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
