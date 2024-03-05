extends Node

func play():
	get_tree().change_scene_to_file("res://ui/scenes/Loading.tscn")

func exit_game():
	get_tree().quit()
