extends UsuableItem

class_name UsuableKey

@onready var animation_player = $AnimationPlayer

func use():
	animation_player.play("use")
