extends RayCast3D

@onready var prompt_label = $Prompt

func _ready():
	add_exception(owner)


func _physics_process(_delta):
	if is_colliding():
		prompt_label.text = "that something"
