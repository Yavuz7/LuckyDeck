extends LineEdit
signal text_send
signal focus_text
signal finished_typing

var place;

func _on_text_changed(new_text):
	text_send.emit(new_text,place)
	pass

	
func _on_focus_entered():
	self.focus_next = get_parent().get_child(1).get_path()	
	focus_text.emit(self,true)


func _on_focus_exited():
	focus_text.emit(self,false)
#	await get_tree().create_timer(1).timeout

func _on_text_submitted(_nt):
	finished_typing.emit(self)
