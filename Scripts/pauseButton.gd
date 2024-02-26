extends TextureButton

@onready var settings = $"../../../../SettingsMenu"
@onready var playersMenuLocation = $"../../../../SettingsMenu/Settings/PlayerScores/Players"


var pauseButton = preload("res://assets/Images/Buttons/pauseButtonLarge.svg")
var closeButton = preload("res://assets/Images/Buttons/closeButtonNew.svg")
var cardPreviewTemplate = preload("res://Scripts/player_preview_scene.tscn")
var playerScenes = Array()
var paused = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	set_texture_normal(pauseButton)	
	settings.visible = false
	
func _pressed():
	pause()

func pause(): 
	if(!paused):
		loadCardsFromPlayers()
		set_texture_normal(closeButton)	
	else:
		removePreview()				
		set_texture_normal(pauseButton)
	settings.visible = !settings.visible
	paused = !paused

func removePreview():
	pass
	for c in playersMenuLocation.get_children():
		c.queue_free()
		
func loadCardsFromPlayers():
	var gamePlayers = GameManager.gamePlayers
	for player in gamePlayers.size():
		var template = cardPreviewTemplate.instantiate();
		var templateDisplay = template.get_node("HSplitContainer/ScrollContainer/PlayerCards")
		var templateName = template.get_node("HSplitContainer/PlayerName")		
		templateName.text = "Player " + str(player + 1)
		var cardsToDisplay = gamePlayers[player].cardTextures;
		if(templateDisplay.get_children().size() < cardsToDisplay.size()):
			while (templateDisplay.get_children().size() < cardsToDisplay.size()):
				var newCardPreview = TextureRect.new()
				newCardPreview.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
				newCardPreview.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
				newCardPreview.set_custom_minimum_size(Vector2(60,90))
				templateDisplay.add_child(newCardPreview)
		var i = 0
		for cardPreview in templateDisplay.get_children():		
			cardPreview.set_texture(cardsToDisplay[i])
			i+= 1
		playersMenuLocation.add_child(template);		
func _on_return_to_game_pressed():
	pause();

