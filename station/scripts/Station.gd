extends Node3D

@onready var model = $Model

@export var rotation_speed = 1.1

@export var landed = false

func on_enter_station():
	TasksManager.add_task({"title": "You're consuming your oxygen. Reestore the oxygen levels of the station."})

func _ready():
	if landed:
		get_tree().create_timer(3).timeout.connect(on_enter_station)
		

func _physics_process(delta):
	if landed:
		rotation.z = lerpf(rotation.z, 0, rotation_speed * delta)
	else:
		rotate_z((rotation_speed) * delta)
