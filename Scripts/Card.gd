extends TextureButton

class_name Card

var face
var back

func _init(cardBack):
	back = cardBack
	set_texture_normal(back)
	
func _pressed():
	SoundManager.cardSelectionRandomizer.play()
	flip()
# Called when the node enters the scene tree for the first time.

func flip():
	GameManager.gameTurn()
#	if(GameManager.Deck.size() > 55):
#	self.queue_free()
#	else:
	self.disabled = true
	self.modulate.a = 0
	self.mouse_filter =Control.MOUSE_FILTER_IGNORE
	pass

func deleteSelf():
	if(self.modulate.a == 0):
		self.queue_free()
func _ready():
	set_h_size_flags(3)
	set_v_size_flags(2)
	set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
	
	
	pass # Replace with function body.


