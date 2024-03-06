extends Node3D

@onready var pos_1 = $Pos1
@onready var pos_2 = $Pos2
@onready var pos_3 = $Pos3
@onready var pos_4 = $Pos4

@onready var positions = [pos_1, pos_2, pos_3, pos_4]

@onready var oxygen_progress = $tubes_box/SubViewport/OxygenProgress

@onready var consume_oxygen_timer = $ConsumeOxygenTimer



var oxygen_consumed_per_second = 10
var oxygen_in_station = 0

var slots: Array[OxygenTank] = [null, null, null, null]

func set_oxygen_in_station(val: int):
	oxygen_in_station = val
	oxygen_progress.value = oxygen_in_station
	StationEvents.oxygen_changed.emit(oxygen_in_station)

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
		
		set_oxygen_in_station(oxygen_in_station + body.oxygen_amount)

func _on_area_3d_area_exited(area):
	var body = area.owner
	if body is OxygenTank:
		set_oxygen_in_station(oxygen_in_station - body.oxygen_amount)
		
		var pos_index = 0
		for slot in slots:
			if slot == body:
				slots[pos_index] = null
				break
			pos_index += 1

func _on_consume_oxygen_timer_timeout():
	if oxygen_in_station <= 0: return
	
	var pos_index = 0
	for slot in slots:
		if slot != null:
			if slots[pos_index].oxygen_amount > 0:
				
				if oxygen_in_station - oxygen_consumed_per_second < 0: 
					set_oxygen_in_station(0)
				else:
					set_oxygen_in_station(oxygen_in_station - oxygen_consumed_per_second)
				
				slots[pos_index].decrease_oxygen_amount(oxygen_consumed_per_second)
				break
		pos_index += 1
