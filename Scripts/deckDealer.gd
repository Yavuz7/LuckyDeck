extends Node

class_name deckDealer

@onready var Game = get_node("/root/Game")
var Deck = Array()
var gridCards = Array()
var numOfPlayers


# Called when the node enters the scene tree for the first time.
func _ready():
	print("apple")
	generateDeck()
	dealDeck()
	GameManager.setDeck(Deck)
	self.queue_free()
	
func _init(players):
	numOfPlayers = players
	pass

func generateDeck():
	var s = 1
	var v = 1
	while s <= 4:
		v = 1
		while v <= 13:
			Deck.append([s,v])
			gridCards.append(Card.new())
			v+= 1
		s+= 1
	if (numOfPlayers > 4):
		var additionalPlayers = numOfPlayers - 4
		while(additionalPlayers > 0):
			Deck.append([5,1])
			gridCards.append(Card.new())
			additionalPlayers-= 1

func dealDeck():
	var c = 0
	if(numOfPlayers <= 4):
		while c < 47:		
			Game.get_node('gridMargin/grid/').add_child(gridCards[c])		
			c+= 1
		
		while c < gridCards.size():
			Game.get_node('gridMargin/grid/').add_child(gridCards[c])
			if (c != 49):
				Game.get_node('gridMargin/grid/').add_child(Container.new())
			c+=1
	elif(numOfPlayers == 5 || numOfPlayers == 6):
		while c < 47:		
			Game.get_node('gridMargin/grid/').add_child(gridCards[c])		
			c+= 1
		
		while c < gridCards.size():
			Game.get_node('gridMargin/grid/').add_child(gridCards[c])
			if (c == 50):
				Game.get_node('gridMargin/grid/').add_child(Container.new())
				Game.get_node('gridMargin/grid/').add_child(Container.new())
				if(numOfPlayers != 6):
					Game.get_node('gridMargin/grid/').add_child(Container.new())
			c+=1
	else:
		while c < gridCards.size():		
			Game.get_node('gridMargin/grid/').add_child(gridCards[c])		
			c+= 1
