extends RayCast3D

@onready var prompt_label = $Prompt
@onready var hand: Marker3D = $Hand

@onready var capsule = get_node("/root/Space/Capsule")

var pick_object = null

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

		if detected is InteractableJoystick:
			prompt_label.text = detected.get_prompt()

			if Input.is_action_pressed(detected.prompt_action):
				pick_object = detected
				var b = get_collision_point()

				pick_object.look_at(b, Vector3.FORWARD)
				pick_object.rotation.z = 0
				# pick_object.rotation.y = 0
				capsule.velocity = pick_object.rotation
			else:
				pick_object = null
				# detected.interact(owner)
		
