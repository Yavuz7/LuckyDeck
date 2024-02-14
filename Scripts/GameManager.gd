extends Node


var Game
var previewCard
var card_animator
var playerDisplay
var footerDisplay
var turnPlayerFavoriteCard
var grid
var victoryScreen


var cardBack = preload("res://assets/Images/cardback1.png")
var numberGenerator = RandomNumberGenerator.new()
enum cardValues {suit,value}

const numberNeededFor4OfAKind = 4
const numberNeededForFlush = 7
const numberNeededForStraight = 7

var Deck = Array()

var numOfPlayers = 4
var currentPlayer = 0

var gamePlayers = Array()

var playerFavoriteCards = {}

var outPlayers = Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func fillPlayerArray():
	var i = 0
	while (i < numOfPlayers):
		gamePlayers.append(Player.new(playerFavoriteCards[i]))
		i+= 1

#This Function Handles Stuff That Needs To Happen before player input
#But After Everything Is Created
func setStart():
	turnPlayerFavoriteCard.set_texture(gamePlayers[currentPlayer].favoriteCard)	
	
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
	if(checkVictory()):			
		return	
	checkDefeat(randomIndex)
#	print(gamePlayers[currentPlayer].cards.back())
	Deck.remove_at(randomIndex)
	if(Deck.size() % 9 == 0):
		reSizeGrid()
	
func showCard(randomIndex):
	var randomCard = Deck[randomIndex]
	var s = randomCard[cardValues.suit]
	var v = randomCard[cardValues.value] 
	
	var texture = load("res://assets/Images/CardFronts/cards"+str(s)+"-"+str(v)+".png")
	gamePlayers[currentPlayer].cardTextures.append(texture)	
	previewCard.set_texture(texture)
	
	gamePlayers[currentPlayer].addToArray(gamePlayers[currentPlayer].cardTexturesSortedValues,v,texture)
	gamePlayers[currentPlayer].addToArray(gamePlayers[currentPlayer].cardTexturesSortedSuits,s,texture)

	card_animator.seek(0,true)
	card_animator.play("make_card_disappear")
	
func addCardToPlayer(i):
	var lastCard = Deck[i]
	gamePlayers[currentPlayer].cards.append(lastCard)
	print("Player " + str(currentPlayer + 1) + "\'s Current Hand: " + str(gamePlayers[currentPlayer].cards))
	
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
	turnPlayerFavoriteCard.set_texture(gamePlayers[currentPlayer].favoriteCard)
	displayCurrentPlayerCards(false)

var toggleArray = true;
func displayCurrentPlayerCards(toggle):
	var cardsToDisplay = Array()
	if(toggle):
		toggleArray = !toggleArray
	if(toggleArray):
		cardsToDisplay = gamePlayers[currentPlayer].cardTexturesSortedSuits.map(func(pair): return pair[1]);
	else:
		cardsToDisplay = gamePlayers[currentPlayer].cardTexturesSortedValues.map(func(pair): return pair[1]);	

	if(footerDisplay.get_children().size() < cardsToDisplay.size()):
		while (footerDisplay.get_children().size() < cardsToDisplay.size()):
			var newCardPreview = TextureRect.new()
			newCardPreview.set_stretch_mode(5)
			newCardPreview.set_expand_mode(1)
			newCardPreview.set_custom_minimum_size(Vector2(60,90))
			footerDisplay.add_child(newCardPreview)
	var i = 0
	for cardPreview in footerDisplay.get_children():		
		cardPreview.set_texture(cardsToDisplay[i])
		i+= 1
	pass
		
func checkDefeat(i):
#	return
	if ((Deck[i][cardValues.value] == 1) || Deck[i][cardValues.suit] == 5):
		outPlayers.append(currentPlayer)
		print("Player " +str(currentPlayer + 1) + " Is Out!")
		if(outPlayers.size() == (numOfPlayers -1)):
			print("Victory By Default!(Last Player Standing)")
			return
						
func checkVictory():
	var victoryMessage
	if(gamePlayers[currentPlayer].cards.size() > 4):
		victoryMessage = checkVictoryHands()
	if(victoryMessage == null):
		victoryMessage = checkFavoriteCardVictory()	
	if( victoryMessage != null):
		print(victoryMessage + " By Player " + str(currentPlayer + 1))
		return true
		
func checkFavoriteCardVictory():
	if(gamePlayers[currentPlayer].cards.back() == playerFavoriteCards[currentPlayer]):
		return "Favorite Card Drawn!"
		
func checkVictoryHands():
	var arrayOfValues = gamePlayers[currentPlayer].cardTexturesSortedValues.map(func(pair): return pair[0]);
	var arrayOfSuits = gamePlayers[currentPlayer].cardTexturesSortedSuits.map(func(pair): return pair[0]);
	var i = 0
	while i <= 13:
		if(arrayOfValues.count(i) == numberNeededFor4OfAKind):
			var cards = gamePlayers[currentPlayer].cards.map()
			victoryHandler("Victory By 4 of A Kind!", i)
			return "Victory By 4 Of A Kind!"	
		i+= 1	
					
	i = 0		
	while i <= 4:
		if(arrayOfSuits.count(i) == numberNeededForFlush):
			return "Victory By " + str(numberNeededForFlush) + " Cards of The Same Suit!"
		i+= 1			
	return checkStraightVictory(arrayOfValues)
	
func checkStraightVictory(targetArray):
	if(targetArray.size() < numberNeededForStraight):
		return null
	targetArray.sort()
	var uniqueArray = Array()
	for value in targetArray:
		if (!uniqueArray.has(value)):
			uniqueArray.append(value)
	print(uniqueArray)
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
			print(uniqueArray)
			return "Victory By Straight!"
	return null
			
func victoryHandler(victoryMessage, victoryCards):
	#Get Victory Message
	#Display cards related to victory
	pass	

func reSizeGrid():
	grid.get_children().map(func(card): card.deleteSelf())
	#Increase in Size calculated, so new size over original gives us ratio, ratios might be different for x and y
	var changeInSizeH = grid.get_parent().size[0] / 710
	var hsize = grid.get_parent().size[0]/ (96 * changeInSizeH) 
	var numberOfRows = grid.get_children().size()/hsize
	

	var changeInSizeV = grid.get_parent().size[1] / 1044
	
#Then we get the number of cards remaining if you have hsize number of cards
#	var totalExtraSpace = grid.get_parent().size[1]  - (numberOfRows* 128)
	var newSize = (grid.get_parent().size[1]  - (numberOfRows* 128 * changeInSizeV))/(numberOfRows)
	grid.add_theme_constant_override("v_separation", newSize)

