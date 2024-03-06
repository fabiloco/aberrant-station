extends Node

@onready var label = $SubViewport/Label

func _ready():
	StationEvents.oxygen_changed.connect(on_oxygen_change)

func on_oxygen_change(oxygen: int):
	label.text = "Oxygen levels: " + str(oxygen) + "\nRadiation levels: unknown"
