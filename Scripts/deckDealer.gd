extends Node

class_name deckDealer

@onready var Game = get_parent()
var Deck = Array()
var gridCards = Array()
var numOfPlayers
var favoriteCards = GameManager.playerFavoriteCards
var favoriteCardsSuitsUsed = Array()
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = Game.get_node('gridMargin/grid/')
	generateDeck()
	dealDeck()
	GameManager.setDeck(Deck)
	GameManager.grid = grid
	self.queue_free()
	
func _init(players):
	numOfPlayers = players
	pass

func generateDeck():
	var cardBack = GameManager.getCardBack()
	var s = 1
	var v = 1
	while s <= 4:
		v = 1
		while v <= 13:
			Deck.append([s,v])
			gridCards.append(Card.new(cardBack))
			v+= 1
		s+= 1
	if (numOfPlayers > 4):
		var additionalPlayers = numOfPlayers - 4
		while(additionalPlayers > 0):
			Deck.append([5,1])
			gridCards.append(Card.new(cardBack))
			additionalPlayers-= 1
	for card in favoriteCards:
		if (favoriteCards[card][1] == 1 && favoriteCardsSuitsUsed.find(favoriteCards[card]) == -1):
			favoriteCardsSuitsUsed.append(favoriteCards[card])
			Deck.append([5,1])
			gridCards.append(Card.new(cardBack))
#			print("Favorite Card Used",favoriteCardsSuitsUsed)

#Needs to be tested later, but should be dynamic row size
func figureOutSize():
	#Increase in Size calculated, so new size over original gives us ratio, ratios might be different for x and y
	var changeInSizeH = grid.get_parent().size[0] / 710
	var changeInSizeV = grid.get_parent().size[1] / 1044
	var hsize = grid.get_parent().size[0]/ (96 * changeInSizeH) 
#Then we get the number of cards remaining if you have hsize number of cards
	var numberOfRows = gridCards.size()/hsize
#	var totalExtraSpace = grid.get_parent().size[1]  - (numberOfRows* 128)
	return((grid.get_parent().size[1]  - (numberOfRows* 128 * changeInSizeV))/(numberOfRows))

func dealDeck():
	grid.add_theme_constant_override("v_separation", figureOutSize())
#	if(gridCards.size() < 55):
#	grid.set_v_size_flags(4)
	var c = 0
	while c < gridCards.size():
		grid.add_child(gridCards[c])
		c+=1

