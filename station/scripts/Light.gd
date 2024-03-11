extends Node

class_name Light

@onready var omni_light_3d = $OmniLight3D
@onready var flicker_timer = $FlickerTimer

@onready var model = $light/Cylinder_001

const LIGHT_ON = preload("res://station/res/LightOn.tres")
const LIGHT_OFF = preload("res://station/res/LightOff.tres")

var is_on = true

func _process(delta):
	if is_on:
		omni_light_3d.light_energy = 0
		model.set_surface_override_material(0, LIGHT_OFF)
		flicker_timer.wait_time = randf_range(2, 3)
	else:
		omni_light_3d.light_energy = 0.5
		model.set_surface_override_material(0, LIGHT_ON)
		flicker_timer.wait_time = randf_range(0.2, 0.6)

func _on_flicker_timer_timeout():
	is_on = !is_on
