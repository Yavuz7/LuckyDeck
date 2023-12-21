extends TextureButton

@onready var settings = $"../../../../SettingsMenu"
var paused = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_texture_normal(GameManager.pauseButton)	
	settings.visible = false


func _pressed():
	pause()

func pause(): 
	if(!paused):
		set_texture_normal(GameManager.closeButton)
	else:
		set_texture_normal(GameManager.pauseButton)
	settings.visible = !settings.visible
	paused = !paused


	
