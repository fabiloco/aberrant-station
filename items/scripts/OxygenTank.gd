extends DraggableItem

class_name OxygenTank

@onready var oxygen_bar = $SubViewport/ProgressBar
@onready var station_area = $Area3D

var oxygen_amount = 100

func _ready():
	oxygen_bar.value = oxygen_amount
