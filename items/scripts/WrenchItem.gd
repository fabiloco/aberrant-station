extends Node3D

class_name UsableItem

@onready var animation_player = $AnimationPlayer

func _process(delta):
	if Input.is_action_just_pressed("use"):
		use()

func use():
	animation_player.play("use")
