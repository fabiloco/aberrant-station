extends Node

@onready var animation_player = $AnimationPlayer
@onready var cut_scene = $CanvasLayer/CutScene

var can_skip = true

func _ready():
	AudioServer.get_bus_effect(2, 0).wet = 0

func _on_death_area_body_exited(body):
	if body is Player:
		DeathScreen.show_screen("You got lost in the space", "Stage1")
		
func _process(delta):
	if can_skip and Input.is_action_just_pressed("jump"):
		can_skip = false
		cut_scene.visible = false
		animation_player.seek(55)
