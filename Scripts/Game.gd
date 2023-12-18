extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	var deckDealer = preload("res://Scripts/deckDealer.gd").new(GameManager.numOfPlayers)
	add_child(deckDealer)
	GameManager.fillPlayerArray()
	GameManager.setUpGame()
	pass # Replace with function body.

