extends Interactable

@onready var animation_player = $AnimationPlayer

func interact(body):
	animation_player.play("click")
	interacted.emit(body)
