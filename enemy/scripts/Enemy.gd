extends CharacterBody3D

@export var spawn_positions: Array[Marker3D]
@onready var timer = $Timer
@onready var eyes_pos = $EyesPos

# sounds
@onready var tension_1 = $Tension1
@onready var chase_player = $ChasePlayer

var speed = 200

var player: Player = null
var light_in_area: Light = null

enum actions{CHASE, ATTACK}

var action = null

var doing_action = false

func _ready():
	pass
	# set_new_position

func _physics_process(delta):
	if player and action == null:
		print("here")
		var rand_action = randi_range(0, 1)
		if rand_action == 0:
			action = actions.CHASE
		else:
			action = actions.ATTACK
	
	attack(delta)
	chase(delta)
	
func attack(delta):
	if player and action == actions.ATTACK:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(eyes_pos.global_position, Vector3(player.global_position.x, player.global_position.y + 1, player.global_position.z))
		var result = space_state.intersect_ray(query)
		
		if result.collider is Player:
			if not chase_player.playing:
				chase_player.play()
			print("seeing player")
			
			look_at(player.global_position)
			# rotation.y = 0
			
			# escape player
			var dir = (global_position - player.global_position).normalized()
			velocity = dir * delta * speed
			move_and_slide()
				

			if light_in_area != null and light_in_area.is_on:
				action = null
				chase_player.stop()
				global_position = calculate_position_behind(player.global_position, player.global_transform.basis.z.normalized(), -2)
				look_at(player.global_position)
				player = null
				light_in_area = null
				get_tree().create_timer(5).timeout.connect(set_new_position)
				# set_new_position()

func calculate_position_behind(target_position: Vector3, target_forward: Vector3, offset_distance: float) -> Vector3:
	var offset = target_forward * offset_distance
	var behind_position = target_position - offset
	return behind_position
	
	
func chase(delta):
	if player and action == actions.CHASE:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(eyes_pos.global_position, Vector3(player.global_position.x, player.global_position.y + 1, player.global_position.z))
		var result = space_state.intersect_ray(query)
		
		if result.collider is Player:
			if not chase_player.playing:
				chase_player.play()
			print("seeing player")
			
			look_at(player.global_position)
			# rotation.y = 0
			
			# chase player
			
			var dir = (player.global_position - global_position).normalized()
			velocity = dir * delta * speed
			move_and_slide()
				

			if light_in_area != null and light_in_area.is_on:
				action = null
				chase_player.stop()
				player = null
				light_in_area = null
				set_new_position()
	


func set_new_position():
	tension_1.play()
	var rand_index = randi_range(0, spawn_positions.size() - 1)
	global_position = spawn_positions[rand_index].global_position

func _on_area_3d_body_entered(body):
	player = body
	print("do something spooky")
	# timer.start()
	# await timer.timeout
	# set_new_position()

func _on_light_detector_area_entered(area):
	light_in_area = area.get_owner()
