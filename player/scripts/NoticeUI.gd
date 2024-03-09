extends HBoxContainer

class_name NoticeUI

@onready var text: RichTextLabel = $Text
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	get_tree().create_timer(10).timeout.connect(on_timeout)
	
func on_timeout():
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	
	queue_free()
