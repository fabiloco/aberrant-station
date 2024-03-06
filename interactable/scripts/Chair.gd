extends Node

class_name Chair

@onready var interactable: StaticBody3D = $Interactable
@onready var sit_position: Marker3D = $SitPosition
@onready var leave_position: Marker3D = $LeavePosition

var can_stand_up = true

func _ready():
	interactable.interacted.connect(move_player)


func move_player(body):
	if body is Player:
		body.is_sitting = true 
		body.active_chair = self
		
		
		body.get_parent().remove_child(body)
		add_child(body)
		
		body.standing_collison_shape.disabled = true
		body.crouching_collison_shape.disabled = true
		
		body.global_position = sit_position.global_position

