extends LineEdit
signal text_send
signal focus_text
signal finished_typing

var place;

func _on_text_changed(new_text):
	text_send.emit(new_text,place)
	pass

	
func _on_focus_entered():
	focus_text.emit(self,true)


func _on_focus_exited():
	focus_text.emit(self,false)


func _on_text_submitted(new_text):
	finished_typing.emit()
