extends RigidBody3D

class_name Item
signal interacted(body)

@export var prompt_message = "Interact"
@export var prompt_action = "interact"
@export var inventory_item: InventoryItem

func get_prompt():
	var key_name = ""

	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
	return prompt_message + "\n[" + key_name+ "]"

func interact(body):
	interacted.emit(body)
	if body is Player:
		if not body.inventory.insert(inventory_item):
			print("inventory full")
			
