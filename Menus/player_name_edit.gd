extends LineEdit
signal text_send

var place;

func _on_text_changed(new_text):
	text_send.emit(new_text,place)
	pass
	
