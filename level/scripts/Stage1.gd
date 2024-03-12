extends Node

func _ready():
	AudioServer.get_bus_effect(2, 0).wet = 0

func _on_death_area_body_exited(body):
	if body is Player:
		DeathScreen.show_screen("You got lost in the space", "Stage1")
		
