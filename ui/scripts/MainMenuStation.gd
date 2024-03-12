extends Node3D

var rotation_speed = 0.2

func _physics_process(delta):
	rotate_z(rotation_speed*delta)
