extends DraggableItem

class_name OxygenTank

@onready var oxygen_bar = $SubViewport/ProgressBar
@onready var station_area = $Area3D

@export var oxygen_amount = 0
@export var random_amount = true

@onready var collision_sound = $CollisionSound

func _ready():
	if random_amount:
		oxygen_amount = randi_range(80, 100)
	
	oxygen_bar.value = oxygen_amount

func decrease_oxygen_amount(val: int):
	oxygen_amount-=val
	if oxygen_amount < 0: oxygen_amount = 0
	oxygen_bar.value = oxygen_amount


func _on_body_entered(body):
	collision_sound.pitch_scale = randf_range(0.5, 0.7)
	collision_sound.play()
