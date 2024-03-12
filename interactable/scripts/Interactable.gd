extends StaticBody3D

class_name Interactable

signal interacted(body)

@export var prompt_message = "Interact"
@export var prompt_action = "interact"

func get_prompt():
	if prompt_action == "":
		return prompt_message
		
	var key_name = ""

	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
	return prompt_message + "\n[" + key_name+ "]"

func interact(body):
	interacted.emit(body)
