extends Panel

@onready var playerDisplay = $mainLayoutCredits/SelectionBox/PlayerHeading/PlayerChange/VBoxContainer/PlayerDisplay
@onready var returnButton = $ReturnDoubleCheck
@export var suitSelect: ButtonGroup
@export var valueSelect: ButtonGroup

var currentPlayers
var playerIndex = 0
var playerFavoriteCards = {}
var suitIndexes = Array()
var valueIndexes = Array()
enum suitValues{none,Diamond,Heart,Spade,Club}

# Called when the node enters the scene tree for the first time.
func _ready():
	currentPlayers = GameManager.numOfPlayers
	suitIndexes = suitSelect.get_buttons()
	valueIndexes = valueSelect.get_buttons()
	var i = 0
	while (i < currentPlayers):
		playerFavoriteCards[i] = []
		i+= 1

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
	get_parent().call_deferred("add_child",load("res://Menus/Game.tscn").instantiate())
	self.queue_free()
	


func _on_back_button_pressed():
	if((playerIndex - 1) >= 0):
		saveSelection(playerIndex)
		playerIndex-= 1
		playerDisplay.text = "Player " + str(playerIndex + 1) + "\'s"
		loadSelection(playerIndex)


func _on_forward_button_pressed():
	if((playerIndex + 1) < currentPlayers):
		saveSelection(playerIndex)
		playerIndex+= 1
		playerDisplay.text = "Player " + str(playerIndex + 1) + "\'s"	
		loadSelection(playerIndex)
		


func _on_return_double_check_pressed():
	if(returnButton.text == "Return"):
		returnButton.text = "You really want to return?"
		await get_tree().create_timer(5).timeout
		returnButton.text = "Return"
	elif(returnButton.text == "You really want to return?"):
		returnButton.text = "Really really want to return??"
	elif(returnButton.text == "Really really want to return??"):
		
		get_parent().call_deferred("add_child",load("res://Menus/player_number_selection.tscn").instantiate())
		self.queue_free()
	
func sendToGameManager():
	fillPlayerArray()
	GameManager.playerFavoriteCards = playerFavoriteCards
	pass

func fillPlayerArray():
	for card in playerFavoriteCards:
		if(playerFavoriteCards[card].size() == 0):
			playerFavoriteCards[card] = [1,1]
