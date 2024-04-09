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
	
func pressButton():
	if(!self.disabled && self.buttonState == false):
		self.set_pressed_no_signal(true)
		buttonState = true

func unPressButton():
	if(!self.disabled && self.buttonState == true):
		self.set_pressed_no_signal(false)
		buttonState = false

func _ready():
	pass # Replace with function body.


func _on_pressed():
	SoundManager.play_preset(SoundManager.CARD_SELECT_SOUND)
	buttonState = !buttonState
