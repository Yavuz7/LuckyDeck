extends Button

var buttonState = false
var cardIndex

func init(isDisabled,texture,alreadyPressed,passedIndex):
	if isDisabled:
		self.disabled = true
	elif alreadyPressed:
		self.set_pressed_no_signal(alreadyPressed)
		buttonState = true
	cardIndex = passedIndex
	$TextureRect.set_texture(texture)
	

func returnTexture():
	return $TextureRect.texture
func _ready():
	pass # Replace with function body.


func _on_pressed():
	buttonState = !buttonState
