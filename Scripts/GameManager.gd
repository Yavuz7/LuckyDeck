extends Node


var Game
var previewCard
var card_animator
var playerDisplay
var footerDisplay

var pauseButton = preload("res://assets/Images/Buttons/pauseButtonLarge.svg")
var closeButton = preload("res://assets/Images/Buttons/closeButtonNew.svg")
var cardBack = preload("res://assets/Images/cardbacknew2.png")
var numberGenerator = RandomNumberGenerator.new()
enum cardValues {suit,value}

const numberNeededFor4OfAKind = 4
const numberNeededForFlush = 7
const numberNeededForStraight = 7

var Deck = Array()

var numOfPlayers = 4
var currentPlayer = 0
var Players = Array()
var playerCardTextures = {}
var playerFavoriteCards = {}
var outPlayers = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setUpGame():
	Game = get_node('/root/Game/')
	previewCard = get_node('/root/Game/drawnCard/')
	card_animator = previewCard.get_node("cardAnimator")
	playerDisplay = get_node('/root/Game/gameHeader/TopGui/HSplitContainer/HBoxContainer/CurrentPlayerName')


func fillPlayerArray():
	var i = 0
	while (i < numOfPlayers):
		Players.append([])
		playerCardTextures[i] = []
		print(playerCardTextures)
		i+= 1

func setDeck(newDeck):
	Deck = newDeck.duplicate()
	pass

func gameTurn():
	cardHandler()
	changeCurrentPlayer()


func cardHandler():
	var randomIndex = numberGenerator.randi_range(0,Deck.size() - 1)
	
	showCard(randomIndex)
	addCardToPlayer(randomIndex)
	if(Players[currentPlayer].size() >= 1):
		if(checkVictory()):			
			return	
	checkDefeat(randomIndex)
	Deck.remove_at(randomIndex)
	
func showCard(randomIndex):
	var randomCard = Deck[randomIndex]
	var s = randomCard[cardValues.suit]
	var v = randomCard[cardValues.value] 
	
	var texture = load("res://assets/Images/CardFronts/cards"+str(s)+"-"+str(v)+".png")
	playerCardTextures[currentPlayer].append(texture)
	previewCard.set_texture(texture)
	

	card_animator.seek(0,true)
	card_animator.play("make_card_disappear")
func addCardToPlayer(i):
	if ((Deck[i][cardValues.value] == 1) || Deck[i][cardValues.suit] == 5):
		return
	else:
		Players[currentPlayer].append(Deck[i])
		print("Player " + str(currentPlayer + 1) + "\'s Current Hand: " + str(Players[currentPlayer]))
	
func changeCurrentPlayer():	
	currentPlayer += 1
	if(currentPlayer == numOfPlayers):
			currentPlayer = 0
	
	if(outPlayers.find(currentPlayer) != -1):
		while (outPlayers.find(currentPlayer) != -1):
			currentPlayer += 1
			if (currentPlayer == numOfPlayers):
				currentPlayer = 0	
#		print("Current Player After OutPlayers Loop: " + str( currentPlayer + 1))	
	
	playerDisplay.text = "Player "+ str(currentPlayer +1) +"'s Turn"
	
	
func checkDefeat(i):
	if ((Deck[i][cardValues.value] == 1) || Deck[i][cardValues.suit] == 5):
		outPlayers.append(currentPlayer)
		print("Player " +str(currentPlayer + 1) + " Is Out!")
		if(outPlayers.size() == (numOfPlayers -1)):
			print("Victory By Default!(Last Player Standing)")
			return
func checkVictory():
	var victoryMessage = checkVictoryHands()
	if( victoryMessage != null):
		print(victoryMessage + " By Player " + str(currentPlayer + 1))
		return true
func checkVictoryHands():
	var completeArrayValue = Array()
	var completeArraySuit = Array()
	var tempCardValue = Array()
	var tempCardSuit = Array()
	var i = 0
	for card in Players[currentPlayer]:
		tempCardValue = Players[currentPlayer][i].duplicate()
		tempCardSuit = tempCardValue.duplicate()
		
		tempCardSuit.remove_at(cardValues.value)
		tempCardValue.remove_at(cardValues.suit)
		
		completeArraySuit += tempCardSuit
		completeArrayValue += tempCardValue
		i+= 1
	i = 0
	while i <= 13:
		if(completeArrayValue.count(i) == numberNeededFor4OfAKind):
			print("Card Values: " + str(completeArrayValue))
			return "Victory By 4 Of A Kind!"	
		i+= 1		
#	print("Card Values: " + str(completeArrayValue))
	i = 0
	while i <= 4:
		if(completeArraySuit.count(i) == numberNeededForFlush):
			print("Card Suits: " +str(completeArraySuit))
			return "Victory By " + str(numberNeededForFlush) + " Cards of The Same Suit!"
		i+= 1		
#	print("Card Suits: " +str(completeArraySuit))
	
	return checkStraightVictory(completeArrayValue)
func checkStraightVictory(valuesArray):
	if(valuesArray.size() < numberNeededForStraight):
		return null
	valuesArray.sort()
	var uniqueArray = Array()
	for value in valuesArray:
		if (!uniqueArray.has(value)):
			uniqueArray.append(value)
	var i = 0 
	var inARowCount = 0
	while (i < uniqueArray.size() - 1):
		
		if((uniqueArray[i]) == (uniqueArray[i + 1] - 1)):
			i+= 1
			inARowCount+= 1
		else:
			inARowCount = 0
			if((uniqueArray.size() - (i + 1) < numberNeededForStraight)):
				return null
			i+= 1
		if(inARowCount + 1 == numberNeededForStraight):
			return "Victory By Straight!"
	return null
			
	
