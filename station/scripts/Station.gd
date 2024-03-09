extends Node3D

@onready var model = $Model

@export var rotation_speed = 1.1

@export var landed = false			

func _physics_process(delta):
	if landed:
		rotation.z = lerpf(rotation.z, 0, rotation_speed * delta)
	else:
		rotate_z((rotation_speed) * delta)
