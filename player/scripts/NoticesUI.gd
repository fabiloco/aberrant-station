extends Control

@onready var notices_container: VBoxContainer = $VBoxContainer

var notice_scene = load("res://player/scenes/Notice.tscn")

func _ready():
	NoticeManager.notice_added.connect(on_notice)

func on_notice(notice):
	var notice_instance: NoticeUI = notice_scene.instantiate()
	notices_container.add_child(notice_instance)
	
	notice_instance.text.text = notice.title
	
	if notices_container.get_child_count() > 3:
		notices_container.get_children()[0].queue_free()

