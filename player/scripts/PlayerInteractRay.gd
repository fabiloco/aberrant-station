extends RayCast3D

@onready var prompt_label = $Prompt
@onready var hand: Marker3D = $Hand

@onready var capsule = get_node("/root/Space/Capsule")

var joystick = null
var dragging_object = null
var pull_power = 4


func _ready():
	add_exception(owner)

func _physics_process(_delta):
	prompt_label.text = ""

	if is_colliding():
		var detected = get_collider()

		if detected is Interactable:
			prompt_label.text = detected.get_prompt()
			
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)

		if detected is DraggableItem:
			prompt_label.text = detected.get_prompt()
			
			if Input.is_action_just_pressed("drag"):
				if dragging_object == null:
					detected.sleeping = false
					detected.freeze = false
					
					dragging_object = detected
					
					dragging_object.station_area.monitorable = false
				else:
					dragging_object.station_area.monitorable = true
					dragging_object = null

		if detected is InteractableJoystick:
			prompt_label.text = detected.get_prompt()

			if Input.is_action_pressed(detected.prompt_action):
				joystick = detected
				var b = get_collision_point()

				joystick.look_at(b, Vector3.FORWARD)
				
				joystick.rotation.z = 0
				joystick.rotation.x = clamp(joystick.rotation.x, -0.3, 1.4)
				joystick.rotation.y = clamp(joystick.rotation.y, -1.4, 1.4)
				
				var dir_x = remap(joystick.rotation.x, -0.3, 1.4, -1, 1)
				var dir_y = remap(joystick.rotation.y, -1.4, 1.4, -1, 1)
				
				capsule.dir = Vector2(dir_x, dir_y)
			else:
				joystick = null
				# detected.interact(owner)
	
		if detected is Item:
			prompt_label.text = detected.get_prompt()
			
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
			
	_drag_object()

func _drag_object():
	if dragging_object != null:
		var a = dragging_object.global_transform.origin
		var b = hand.global_transform.origin
		dragging_object.set_linear_velocity((b - a) * pull_power)
