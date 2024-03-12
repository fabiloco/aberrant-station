extends Control

@onready var options_menu: Control = $OptionsMenu

func _ready():
	visible = false
	

func _process(delta):
	if Input.is_action_just_pressed("leave") and not get_tree().paused:
		pause_game()
	elif Input.is_action_just_pressed("leave") and get_tree().paused:
		resume_game()

func pause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	visible = true

func resume_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	visible = false


func toggle_options_menu():
	if options_menu.visible:
		options_menu.visible = false
	else:
		options_menu.visible = true

func main_menu():
	get_tree().paused = false
	Globals.stage = "Stage1"
	get_tree().change_scene_to_file("res://ui/scenes/MainMenu.tscn")
