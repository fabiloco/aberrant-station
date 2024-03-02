extends Node

@onready var model = $Model

@export var rotation_speed = 2


func _physics_process(delta):
	pass
	# model.rotate_z(rotation_speed * delta)
