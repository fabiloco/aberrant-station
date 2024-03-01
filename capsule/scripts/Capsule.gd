extends RigidBody3D


var is_on = false

func _physics_process(delta):
	if is_on:
		var dir = Input.get_vector("left", "right", "forward", "backward")

		var force = Vector3(dir.x, 0, dir.y)

		apply_force(force * delta)

		var rot = Input.get_axis("rotate_left", "rotate_right")

		apply_torque(Vector3(0, 0,rot * delta))

