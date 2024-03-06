extends Chair

class_name RadiationCapsule

# @onready var interactable: StaticBody3D = $Interactable
# @onready var sit_position: Marker3D = $SitPosition
@onready var restore_radiation_timer = $RestoreRadiationTimer

var player = null

func _ready():
	can_stand_up = false
	interactable.interacted.connect(move_player)


func move_player(body):
	if body is Player:
		if body.is_sitting:
			return
		
		restore_radiation_timer.start()
		
		player = body
		body.is_sitting = true 
		body.active_chair = self
		
		body.get_parent().remove_child(body)
		add_child(body)
		
		body.standing_collison_shape.disabled = true
		body.crouching_collison_shape.disabled = true
		
		body.global_position = sit_position.global_position
		#	body.rotation = sit_position.rotation
		
		# get_tree().create_timer(10).timeout.connect(stand_up_player)

func stand_up_player():
	restore_radiation_timer.stop()
	player.is_sitting = false

	player.get_parent().remove_child(player)
	player.space.add_child(player)
	
	player.standing_collison_shape.disabled = false
	player.crouching_collison_shape.disabled = false
	
	player.global_position = player.active_chair.global_position

	player.active_chair = null


func _on_restore_radiation_timer_timeout():
	if player is Player:
		var radiation = player.vitals.radiation
		player.vitals.set_radiation(radiation-1)
		if radiation <= 0:
			stand_up_player()
		
