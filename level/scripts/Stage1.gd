extends Node

func _on_death_area_body_exited(body):
	if body is Player:
		DeathScreen.show_screen("You got lost in the space", "Stage1")
