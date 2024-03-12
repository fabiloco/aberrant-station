extends CanvasLayer

@onready var message_label = $Control/VBoxContainer/Message
@onready var animation_player = $Control/AnimationPlayer


func _ready():
	visible = false

func show_screen():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	animation_player.play("show")	

func _on_main_menu_button_pressed():
	visible = false
	get_tree().change_scene_to_file("res://ui/scenes/MainMenu.tscn")

func delete_scene():
	get_tree().get_root().get_node("Space").queue_free()