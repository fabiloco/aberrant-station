extends UsuableItem

class_name UsuableWrench

@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

func use():
	animation_player.play("use")
	
func play_whoosh_sound():
	audio_stream_player_3d.pitch_scale = randf_range(0.8, 1)
	audio_stream_player_3d.play()
