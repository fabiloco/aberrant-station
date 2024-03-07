extends Resource

class_name Inventory

signal update

@export var items: Array[InventoryItem]

func insert(item: InventoryItem):
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item
			update.emit()
			return true
	return false 
