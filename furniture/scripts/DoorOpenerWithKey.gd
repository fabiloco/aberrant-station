extends Interactable

class_name DoorOpenerWithKey

@onready var label = $SubViewport/Label
@onready var cube = $door_opener/Cube

@onready var access_mat = preload("res://furniture/res/AccessMaterial.tres")
@onready var aproved = $Aproved
@onready var denied = $Denied
@onready var open_door = $OpenDoor

@export var other_side_opener: DoorOpenerWithKey


var authorized = false

func get_prompt():
	var key_name = ""

	if authorized:
		for action in InputMap.action_get_events(prompt_action):
			if action is InputEventKey:
				key_name = OS.get_keycode_string(action.physical_keycode)
		return prompt_message + "\n[" + key_name+ "]"
	else:
		return "Requires a key"

func interact(body):
	if authorized:
		interacted.emit(body)
		open_door.play()
	else:
		denied.play()

func _on_area_3d_area_entered(area):
	area.get_owner().dropped.emit()
	area.get_owner().queue_free()
	
	authorize()
	other_side_opener.authorize()

func authorize():
	authorized = true
	aproved.play()
	label.text = "Permission to open:\nGranted"
	cube.set_surface_override_material(3, access_mat)
