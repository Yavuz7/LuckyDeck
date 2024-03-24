extends GridContainer



func _on__pressed():
	SoundManager.play_preset(SoundManager.CARD_SELECT_SOUND)
