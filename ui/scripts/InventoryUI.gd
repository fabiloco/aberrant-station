extends Control

class_name InventoryUI

@onready var grid_container = $Panel/MarginContainer/GridContainer
@onready var inventory: Inventory = preload("res://items/res/PlayerInventory.tres")

@onready var slots: Array = grid_container.get_children()
@onready var item_holder = $"../../Head/ItemHolder"

var active_index = 0

func _ready():
	inventory.update.connect(update_slots)
	slots[active_index].active = true
	update_slots()
	equip_item()

func _process(delta):
	if Input.is_action_just_pressed("scroll_up"):
		if active_index != 0: 
			active_index -= 1
			slots[active_index].active = true
			update_slots()
			equip_item()
			
	if Input.is_action_just_pressed("scroll_down"):
		if active_index != slots.size() - 1: 
			active_index += 1
			slots[active_index].active = true
			update_slots()
			equip_item()
			
func remove_items():
	for item in item_holder.get_children():
		item.queue_free()

func equip_item():
	remove_items()
	if inventory.items[active_index] != null:
		var item_instance = inventory.items[active_index].scene.instantiate()
		item_holder.add_child(item_instance)
	

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		if i != active_index:
			slots[i].active = false
		
		if inventory.items[i]:
			slots[i].update(inventory.items[i].texture)
