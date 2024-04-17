extends Panel


func _on_return_pressed():
	SoundManager.play_preset(SoundManager.RETURN_SOUND)
	self.queue_free()
	pass # Replace with function body.


func _on_web_button_pressed():
	OS.shell_open("https://buymeacoffee.com/yavuzbavuz")
