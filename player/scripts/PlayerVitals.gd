extends HBoxContainer

class_name PlayerVitals

@onready var oxygen_bar = $VBoxContainer/Oxygen
@onready var radiation_bar = $VBoxContainer2/Radiation

@onready var increase_radiation_timer = $IncreaseRadiationTimer

@onready var player = $"../.."

var consume_oxygen = false

var oxygen = 100
var oxygen_per_seconds = 1
var radiation = 20

var increase_radiation = false
var radiation_per_seconds = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	oxygen_bar.value = oxygen
	radiation_bar.value = radiation
	StationEvents.oxygen_changed.connect(on_oxygen_change)

func on_oxygen_change(oxygen: int):
	if oxygen <= 0:
		consume_oxygen = true
	else:
		consume_oxygen = false
	
func set_radiation(val: int):
	radiation = val
	
	if radiation < 0:
		radiation = 0
	radiation_bar.value = radiation
	
	if radiation > 50:
		NoticeManager.add_notice({"title": "Your radiation levels are above 50%. Find a radiation capsule to recover."})
	
	if radiation >= 100:
		DeathScreen.show_screen("You died by radiation.", "Stage2")
	

func _on_consume_oxygen_timer_timeout():
	if player.is_in_capsule: return
	if consume_oxygen:
		oxygen -= oxygen_per_seconds
		oxygen_bar.value = oxygen
		
		if oxygen <= 0:
			DeathScreen.show_screen("You ran out of oxygen.", "Stage2")


func _on_increase_radiation_timer_timeout():
	if increase_radiation:
		set_radiation(radiation+radiation_per_seconds)


func _on_radiation_area_body_entered(body):
	increase_radiation = true


func _on_radiation_area_body_exited(body):
	increase_radiation = false
