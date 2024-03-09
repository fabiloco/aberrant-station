extends Control

@onready var tasks_container: VBoxContainer = $VBoxContainer

var task_scene = load("res://player/scenes/Task.tscn")

func _ready():
	TasksManager.task_added.connect(on_task)

func on_task(task):
	var task_instance: TaskUI = task_scene.instantiate()
	tasks_container.add_child(task_instance)
	
	if tasks_container.get_child_count() > 3:
		tasks_container.get_children()[0].queue_free()
		
	for index in range(tasks_container.get_children().size()):
		if index != tasks_container.get_children().size()-1:
			task_instance.text.text = task.title
			tasks_container.get_children()[index].check_box.button_pressed = true
			tasks_container.get_children()[index].modulate = Color("#717171")
			
		else:
			task_instance.text.text = task.title
			task_instance.check_box.button_pressed = false
			tasks_container.get_children()[index].modulate = Color.WHITE
		

