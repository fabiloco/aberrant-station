extends CharacterBody3D

class_name Player

@export_category("Speed variables")
@export var walking_speed = 3.0
@export var sprinting_speed = 4.5
@export var crouching_speed = 1.0

@export_category("Conrtol variables")
@export var mouse_sens = 0.25 
@export var lerp_speed = 10 

@onready var head = $Head
@onready var standing_collison_shape = $StandingCollisionShape	
@onready var crouching_collison_shape = $CrouchingCollisionShape
@onready var crouching_ray_cast = $CroucingRayCast

@onready var walk_timer = $WalkTimer
@onready var step_sound = $StepSound

@export var inventory: Inventory

@onready var vitals: PlayerVitals = $CanvasLayer/Vitals
@export var is_in_capsule = true
@onready var inventory_ui: InventoryUI = $CanvasLayer/InventoryUI

@onready var item_holder = $Head/ItemHolder
@onready var cam_holder = $Head/CamHolder
var item_sway_amount: float = 1
var item_rotation_amount: float = 0.005
var cam_rotation_amount = 0.02
var def_item_holder_pos: Vector3
var invert_item_sway : bool = true
var mouse_input: Vector2



var current_speed = walking_speed

var jump_velocity = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var direction = Vector3.ZERO

var crouching_depth = 0.5

# sitting variables
var is_sitting = false
var active_chair: Chair

@onready var capsule = get_node("/root/Space/Capsule")

@onready var space = get_node("/root/Space")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))
		mouse_input = event.relative

func _physics_process(delta):
	if is_sitting: 
		if active_chair.can_stand_up && Input.is_action_just_pressed("crouch"):
			is_sitting = false

			get_parent().remove_child(self)
			space.add_child(self)

			global_position = active_chair.global_position

			active_chair = null
		if Input.is_action_just_pressed("crouch") && !capsule.landed && not active_chair is RadiationCapsule:
			NoticeManager.add_notice({"title": "Land the spaceship first"})
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
	
	if is_on_floor() and input_dir != Vector2.ZERO:
		if walk_timer.time_left <= 0:
				step_sound.pitch_scale = randf_range(0.8, 1)
				step_sound.play()
				walk_timer.start(0.6)

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
		
			
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
	cam_tilt(input_dir.x, delta)
	item_tilt(input_dir.x, delta)
	item_sway(delta)
	if input_dir.length() != 0:
		weapon_bob(velocity.length(), delta)

func cam_tilt(input_x, delta):
	if cam_holder:
		cam_holder.rotation.z = lerp(cam_holder.rotation.z, -input_x * cam_rotation_amount, 10 * delta)

func item_tilt(input_x, delta):
	if item_holder:
		item_holder.rotation.z = lerp(item_holder.rotation.z, -input_x * item_rotation_amount, 10 * delta)

func item_sway(delta):
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta)
	item_holder.rotation.x = lerp(item_holder.rotation.x, mouse_input.y * item_rotation_amount * (-1 if invert_item_sway else 1), 10 * delta)
	item_holder.rotation.y = lerp(item_holder.rotation.y, mouse_input.x * item_rotation_amount * (-1 if invert_item_sway else 1), 10 * delta)

func weapon_bob(vel : float, delta):
	if item_holder:
		if vel > 0 and is_on_floor():
			var bob_amount : float = 0.01
			var bob_freq : float = 0.01
			item_holder.position.y = lerp(item_holder.position.y, def_item_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			item_holder.position.x = lerp(item_holder.position.x, def_item_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
			
		else:
			item_holder.position.y = lerp(item_holder.position.y, def_item_holder_pos.y, 10 * delta)
			item_holder.position.x = lerp(item_holder.position.x, def_item_holder_pos.x, 10 * delta)
