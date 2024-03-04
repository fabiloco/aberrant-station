extends Node3D

@onready var model = $Model

@export var rotation_speed = 1.1

var landed = false

func _physics_process(delta):
	print(landed)
	if landed:
		rotate_z((-rotation_speed) * delta)
	else:
		rotate_z((rotation_speed) * delta)
