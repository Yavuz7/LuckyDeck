extends HBoxContainer



func play_selection_sound():
	SoundManager.play_preset(SoundManager.CARD_SELECT_SOUND)
	

func _on_diamond_pressed():
	play_selection_sound()

func _on_heart_pressed():
	play_selection_sound()

func _on_spade_pressed():
	play_selection_sound()
	
func _on_club_pressed():
	play_selection_sound()
