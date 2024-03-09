extends Node

@onready var label = $SubViewport/Label

func _ready():
	StationEvents.oxygen_changed.connect(on_oxygen_change)

func on_oxygen_change(oxygen: int):
	var stimated_time = oxygen/60
	var stimated_text = "%.0f minutes" % stimated_time
	label.text = "Oxygen levels: " + str(oxygen) + "\nStimated oxygen time: " + stimated_text + "\nRadiation levels: unknown"
