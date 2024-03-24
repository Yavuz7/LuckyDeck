extends Panel


func _on_return_pressed():
	SoundManager.play_preset(SoundManager.RETURN_SOUND)
	self.queue_free()
	pass # Replace with function body.
