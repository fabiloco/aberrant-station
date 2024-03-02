extends Node

@onready var animation_player = $AnimationPlayer

var is_open = false

func toggle_door(_body):
	is_open = !is_open

	if is_open:
		animation_player.play("move")
	else:
		animation_player.play_backwards("move")
