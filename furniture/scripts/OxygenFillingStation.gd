extends Node3D

@onready var pos_1 = $Pos1
@onready var pos_2 = $Pos2
@onready var pos_3 = $Pos3
@onready var pos_4 = $Pos4

@onready var positions = [pos_1, pos_2, pos_3, pos_4]

var slots = [null, null, null, null]

func _on_area_3d_area_entered(area):
	var body = area.owner
	if body is OxygenTank:
		body.sleeping = true
		body.freeze = true
		
		var pos_index = 0
		for slot in slots:
			if slot == null:
				break
			pos_index += 1

		body.global_position = positions[pos_index].global_position
		body.rotation = Vector3.ZERO
		
		slots[pos_index] = body

func _on_area_3d_area_exited(area):
	var body = area.owner
	if body is OxygenTank:
		var pos_index = 0
		for slot in slots:
			if slot == body:
				slots[pos_index] = null
				break
			pos_index += 1

