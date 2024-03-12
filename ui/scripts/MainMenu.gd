extends CanvasLayer

@onready var options_menu = $OptionsMenu

func play():
	get_tree().change_scene_to_file("res://ui/scenes/Loading.tscn")

func toggle_options_menu():
	if options_menu.visible:
		options_menu.visible = false
	else:
		options_menu.visible = true

func exit_game():
	get_tree().quit()
