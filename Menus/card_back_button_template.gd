extends Button

func init(isDisabled,texture,alreadyPressed):
	if isDisabled:
		self.disabled = true
		$TextureRect.set_texture(GameManager.cardLocked)
	else:
		$TextureRect.set_texture(texture)
		self.set_pressed_no_signal(alreadyPressed)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
