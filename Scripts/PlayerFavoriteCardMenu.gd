extends Panel

@onready var playerDisplay = $mainLayoutCredits/SelectionBox/PlayerHeading/PlayerChange/VBoxContainer/PlayerDisplay
@onready var returnButton = $ReturnDoubleCheck/Label
@export var suitSelect: ButtonGroup
@export var valueSelect: ButtonGroup

var currentPlayers
var playerNames = Array()
var playerIndex = 0
var playerFavoriteCards = {}
var suitIndexes = Array()
var valueIndexes = Array()
enum suitValues{none,Diamond,Heart,Spade,Club}

var loadedCards = SaveManager.loadedData["favoriteCards"]

# Called when the node enters the scene tree for the first time.
func _ready():
	print(loadedCards)
	currentPlayers = GameManager.numOfPlayers
	playerNames = GameManager.playerNames
	suitIndexes = suitSelect.get_buttons()
	valueIndexes = valueSelect.get_buttons()
	playerDisplay.text = playerNames[playerIndex] + "'s"
	var i = 0
	while (i < currentPlayers):
		if(loadedCards.size() > i):			
			playerFavoriteCards[i] = loadedCards[i]
		else:				
			playerFavoriteCards[i] = []
		i+= 1
	loadSelection(0)
#Get Button Values, Save to Game Manager Index
func saveSelection(i):
	if(!playerFavoriteCards[i]):
		playerFavoriteCards[i].append(suitValues.get(suitSelect.get_pressed_button().name))
		playerFavoriteCards[i].append(valueSelect.get_pressed_button().name.to_int())
	else:
		playerFavoriteCards[i].clear()
		playerFavoriteCards[i].append(suitValues.get(suitSelect.get_pressed_button().name))
		playerFavoriteCards[i].append(valueSelect.get_pressed_button().name.to_int())	


#Get Player Card of index and set buttons that correspond
func loadSelection(i):
	if(playerFavoriteCards[i]):
		suitIndexes[playerFavoriteCards[i][0] - 1].set_pressed(true)
		valueIndexes[playerFavoriteCards[i][1] - 1].set_pressed(true)
	else:
		suitIndexes[0].set_pressed(true)
		valueIndexes[0].set_pressed(true)

func _on_start_game_pressed():
	saveSelection(playerIndex)
	sendToGameManager()
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	SaveManager.save_game_settings({"favoriteCards": playerFavoriteCards})
	SaveManager.update_data()
	get_parent().call_deferred("add_child",load("res://Menus/Game.tscn").instantiate())
	self.queue_free()
	


func _on_back_button_pressed():
	if((playerIndex - 1) >= 0):
		saveSelection(playerIndex)
		playerIndex-= 1
		playerDisplay.text = playerNames[playerIndex] + "\'s"
		loadSelection(playerIndex)
		SoundManager.play_preset(SoundManager.SWITCH_SOUND)


func _on_forward_button_pressed():
	if((playerIndex + 1) < currentPlayers):
		saveSelection(playerIndex)
		playerIndex+= 1
		playerDisplay.text = playerNames[playerIndex] + "\'s"	
		loadSelection(playerIndex)
		SoundManager.play_preset(SoundManager.SWITCH_SOUND)		


func _on_return_double_check_pressed():
	saveSelection(playerIndex)	
	SoundManager.play_preset(SoundManager.RETURN_SOUND)
	SaveManager.save_game_settings({"favoriteCards": playerFavoriteCards})
	SaveManager.update_data()
	get_parent().call_deferred("add_child",load("res://Menus/player_number_selection.tscn").instantiate())
	self.queue_free()
	
func sendToGameManager():
	GameManager.playerFavoriteCards = playerFavoriteCards	
	fillPlayerArray()
	print(playerFavoriteCards)
	pass

#Different than the one found in Game Manager
func fillPlayerArray():
	for card in playerFavoriteCards:
		if(playerFavoriteCards[card].size() == 0):
			playerFavoriteCards[card] = [1,1]
