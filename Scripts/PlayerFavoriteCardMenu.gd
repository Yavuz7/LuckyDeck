extends Panel

@onready var playerDisplay = $mainLayoutCredits/SelectionBox/PlayerHeading/PlayerChange/PlayerDisplay
@export var suitSelect: ButtonGroup
@export var valueSelect: ButtonGroup

var currentPlayers
var playerIndex = 0
var playerFavoriteCards = {}
var suitIndexes = Array()
enum suitValues{none,Diamond,Heart,Spade,Club}

# Called when the node enters the scene tree for the first time.
func _ready():
	currentPlayers = GameManager.numOfPlayers
	suitIndexes = suitSelect.get_buttons()
	var i = 0
	while (i < currentPlayers):
		playerFavoriteCards[i] = []
		i+= 1

#Get Button Values, Save to Game Manager Index
func saveSelection(i):
	if(!playerFavoriteCards[i]):
		playerFavoriteCards[i].append(suitValues.get(suitSelect.get_pressed_button().name))
	else:
		playerFavoriteCards[i].clear()
		playerFavoriteCards[i].append(suitValues.get(suitSelect.get_pressed_button().name))


#Get Player Card of index and set buttons that correspond
func loadSelection(i):
	if(playerFavoriteCards[i]):
		print(playerFavoriteCards[i][0])
		suitIndexes[playerFavoriteCards[i][0] - 1].set_pressed(true)
	else:
		suitIndexes[0].set_pressed(true)

func _on_start_game_pressed():
	saveSelection(playerIndex)


func _on_back_button_pressed():
	if((playerIndex - 1) >= 0):
		saveSelection(playerIndex)
		playerIndex-= 1
		playerDisplay.text = "Player " + str(playerIndex + 1)
		print("Player Index:" + str(playerIndex))
		loadSelection(playerIndex)


func _on_forward_button_pressed():
	if((playerIndex + 1) < currentPlayers):
		saveSelection(playerIndex)
		playerIndex+= 1
		playerDisplay.text = "Player " + str(playerIndex + 1)
		print("Player Index:" + str(playerIndex))		
		loadSelection(playerIndex)
		
