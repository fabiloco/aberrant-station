extends Node

@onready var interactable: StaticBody3D = $Interactable
@onready var sit_position: Marker3D = $SitPosition

func _ready():
	interactable.interacted.connect(move_player)


func move_player(body):
	if body is Player:
		body.global_position = sit_position.global_position 
		body.is_sitting = true 
