extends Node3D

class_name UsuableItem

signal dropped

@export var physic_scene_path: String

func _process(delta):
	if Input.is_action_just_pressed("use"):
		use()
		
	if Input.is_action_just_pressed("drop_item"):
		var packed_scene: PackedScene = load(physic_scene_path)
		var item_instance: RigidBody3D = packed_scene.instantiate()
		get_node("/root/Space").add_child(item_instance)
		var camera = get_viewport().get_camera_3d()
		item_instance.global_position = global_position
		item_instance.apply_impulse(-camera.global_transform.basis.z * 3)
		dropped.emit()
		queue_free()
		
func use():
	pass
