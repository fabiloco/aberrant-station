extends Control

@onready var tasks_container: VBoxContainer = $VBoxContainer

var task_scene = load("res://player/scenes/Task.tscn")

func _ready():
	TasksManager.task_added.connect(on_task)

func on_task(task):
	var task_instance = task_scene.instantiate()
	task_instance.text = task.title
	tasks_container.add_child(task_instance)
	
	if tasks_container.get_child_count() > 3:
		tasks_container.get_children()[0].queue_free()
		

