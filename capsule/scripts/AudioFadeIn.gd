extends AudioStreamPlayer3D

func play_with_fade_in():
	play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", 0, 3)

func stop_with_fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -50, 3)
	tween.tween_callback(stop)

	
