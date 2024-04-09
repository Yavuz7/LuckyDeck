extends Button

func init(isDisabled,texture,alreadyPressed):
	if isDisabled:
		self.disabled = true
	else:
		self.set_pressed_no_signal(alreadyPressed)
	$TextureRect.set_texture(texture)
	
	
func _ready():
	pass # Replace with function body.
