extends Panel

func _on_return_pressed():
	SoundManager.play_preset(1,-3)
	self.queue_free()
	pass # Replace with function body.
