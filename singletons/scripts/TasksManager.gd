extends Node

signal task_added(task)

var tasks = []

func add_task(task):
	tasks.append(task)
	task_added.emit(task)
