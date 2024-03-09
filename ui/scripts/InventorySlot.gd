extends Node

class_name InventorySlot

@onready var panel = $Panel
@onready var texture_rect = $TextureRect

var active = false
	
func update(texture: Texture2D):
	if texture:
		texture_rect.texture = texture
	else:
		texture_rect.texture = null
	
	panel.visible = active
