extends HBoxContainer

class_name PlayerVitals

@onready var oxygen_bar = $VBoxContainer/Oxygen
@onready var radiation_bar = $VBoxContainer2/Radiation

@onready var increase_radiation_timer = $IncreaseRadiationTimer

var consume_oxygen = false

var oxygen = 100
var oxygen_per_seconds = 1
var radiation = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	oxygen_bar.value = oxygen
	radiation_bar.value = radiation
	StationEvents.oxygen_changed.connect(on_oxygen_change)

func on_oxygen_change(oxygen: int):
	if oxygen <= 0:
		consume_oxygen = true
		TasksManager.add_task({"title": "You're consuming your oxygen. Reestore the oxygen levels of the station."})
	else:
		TasksManager.add_task({"title": "Oxygen in station reestablished."})
		consume_oxygen = false
	
func set_radiation(val: int):
	radiation = val
	if radiation < 0:
		radiation = 0
	radiation_bar.value = radiation
	

func _on_consume_oxygen_timer_timeout():
	if consume_oxygen:
		oxygen -= oxygen_per_seconds
		oxygen_bar.value = oxygen


func _on_increase_radiation_timer_timeout():
	set_radiation(radiation+1)
