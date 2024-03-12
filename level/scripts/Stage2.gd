extends Node

func _ready():
	AudioServer.get_bus_effect(2, 0).wet = 0.5
	TasksManager.add_task({"title": "You're consuming your oxygen. restore the oxygen levels of the station."})

func _on_death_area_body_exited(body):
	if body is Player:
		DeathScreen.show_screen("You got lost in the space", "Stage2")
		
