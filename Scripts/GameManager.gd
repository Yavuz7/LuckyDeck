extends Node


var Game
var previewCard
var card_animator
var playerDisplay
var footerDisplay
var turnPlayerFavoriteCard
var matchScoresVbox
var matchScoresTotalDisplay

#Grid used for resizing after cards are picked
var grid
var victoryScreen

var cardBacks = Array()
var usedCardBacks = Array()
var cardBack = preload("res://assets/Images/cardBacks/cb005.png")
var numberGenerator = RandomNumberGenerator.new()

const numberNeededFor4OfAKind = 4
const numberNeededForFlush = 5
const numberNeededForStraight = 6

var Deck = Array()

var numOfPlayers = 4
var currentPlayer = 0

var gamePlayers = Array()
var playerFavoriteCards = {}
var outPlayers = Array()
var playerNames = Array()
var matchScores = Array()
var matchTotal = 0
var disabledAces = Array()

#Variables For Music to work better
var cardsDrawn:= 0
var gameOver := false

func getCardBack():
	if(cardBacks.size() == 0):
		cardBacks = usedCardBacks.duplicate()
		usedCardBacks.clear()
	var randomIndex = numberGenerator.randi_range(0,cardBacks.size() - 1)
	var cardBackToReturn = cardBacks[randomIndex]
	usedCardBacks.append(cardBackToReturn)
	cardBacks.erase(cardBackToReturn)
	return cardBackToReturn
	
func fillPlayerArray():
	cardsDrawn = 0
	gameOver = false
	var i = 0
	while (i < numOfPlayers):
		if(matchScores.size() < numOfPlayers):
			matchScores.append(0)
		gamePlayers.append(Player.new(playerFavoriteCards[i],playerNames[i]))
		if playerFavoriteCards[i][1] == 1 && !disabledAces.has(playerFavoriteCards[i][0]):
			disabledAces.append(playerFavoriteCards[i][0])		
		i+= 1
	print("Disabled Aces:" ,disabledAces)
	print("Match Scores: ",matchScores)
#This Function Handles Stuff That Needs To Happen before player input
#But After Everything Is Created
func setStart(startingPlayer):
	currentPlayer = startingPlayer
	turnPlayerFavoriteCard.set_texture(gamePlayers[currentPlayer].favoriteCard)
	playerDisplay.text = gamePlayers[currentPlayer].playerName	+ "'s turn"
	
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
#	if(cardsDrawn > 9 && !gameOver):
#		SoundManager.songSetsChangeSong()
#		cardsDrawn = 0
#	else:
#		cardsDrawn+= 1

func changeSongsWithScene():
	if(cardsDrawn > 9 && !gameOver):
		SoundManager.songSetsChangeSong()
		cardsDrawn = 0
	else:
		cardsDrawn+= 1
		
func showCard(randomIndex):
	var randomCard = Deck[randomIndex]
	var s = randomCard[0]
	var v = randomCard[1] 
	
	var texture = load("res://assets/Images/CardFronts/cards"+str(s)+"-"+str(v)+".png")
	gamePlayers[currentPlayer].cardTextures.append(texture)	
	previewCard.set_texture(texture)
	
	gamePlayers[currentPlayer].addToArray(gamePlayers[currentPlayer].cardTexturesSortedValues,v,texture)
	gamePlayers[currentPlayer].addToArray(gamePlayers[currentPlayer].cardTexturesSortedSuits,s,texture)

	previewCard.visible = true
	card_animator.seek(0,true)
	card_animator.play("make_card_disappear")
	
func addCardToPlayer(i):
	var lastCard = Deck[i]
	gamePlayers[currentPlayer].cards.append(lastCard)
	#print("Player " + str(currentPlayer + 1) + "\'s Current Hand: " + str(gamePlayers[currentPlayer].cards))
	
func changeCurrentPlayer():	

	loopThroughPlayers()
#		print("Current Player After OutPlayers Loop: " + str( currentPlayer + 1))	
	
	playerDisplay.text = gamePlayers[currentPlayer].playerName	+ "'s turn"
	turnPlayerFavoriteCard.set_texture(gamePlayers[currentPlayer].favoriteCard)
	displayCurrentPlayerCards(false)

var toggleArray = true;

func loopThroughPlayers():
	if(gameOver):
		return
	currentPlayer += 1
	if(currentPlayer == numOfPlayers):
			currentPlayer = 0
	
	if(outPlayers.find(currentPlayer) != -1):
		while (outPlayers.find(currentPlayer) != -1):
			currentPlayer += 1
			if (currentPlayer == numOfPlayers):
				currentPlayer = 0

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
			newCardPreview.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
			newCardPreview.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
			newCardPreview.set_custom_minimum_size(Vector2(60,90))
			footerDisplay.add_child(newCardPreview)
	var i = 0
	for cardPreview in footerDisplay.get_children():		
		cardPreview.set_texture(cardsToDisplay[i])
		i+= 1
	pass
		
func checkDefeat(i):
#	return
	if ((Deck[i][1] == 1) || Deck[i][0] == 5):
		if disabledAces.has(Deck[i][0]):
			print("This ace is disabled")
			return
		outPlayers.append(currentPlayer)
		print("Player " +str(currentPlayer + 1) + " Is Out!")
		if(outPlayers.size() == (numOfPlayers -1)):
#We need to loop through the players to get to the player that is still standing
			loopThroughPlayers()
			victoryHandler("Victory By Default!\n(Last Player Standing)",null)
			return
		else:
			SoundManager.play_preset(SoundManager.DEFEAT_SOUND)				
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
		var winningCard = [[0,gamePlayers[currentPlayer].favoriteCard]]
		victoryHandler("Victory By Favorite Card Drawn!", winningCard)
		return "Favorite Card Drawn!"
		
func checkVictoryHands():
	var arrayOfValues = gamePlayers[currentPlayer].cardTexturesSortedValues.map(func(pair): return pair[0]);
	var arrayOfSuits = gamePlayers[currentPlayer].cardTexturesSortedSuits.map(func(pair): return pair[0]);
	var i = 0
	while i <= 13:
		if(arrayOfValues.count(i) == numberNeededFor4OfAKind):			
			var winningCards = gamePlayers[currentPlayer].getValues(i)
			victoryHandler("Victory By 4 of A Kind!", winningCards)
			return "Victory By 4 Of A Kind!"	
		i+= 1	
					
	i = 0		
	while i <= 4:
		if(arrayOfSuits.count(i) == numberNeededForFlush):
			var winningCards = gamePlayers[currentPlayer].getSuits(i)
			victoryHandler("Victory By " + str(numberNeededForFlush) + " Cards of The Same Suit!", winningCards)
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
			var slicedArray = uniqueArray.slice(i-numberNeededForStraight + 1, i + 1)
			print("Sliced Array", slicedArray)
			var winningCards = gamePlayers[currentPlayer].getStraight(slicedArray)
			victoryHandler("Victory By " + str(numberNeededForStraight) + " cards in a row!", winningCards)
			return "Victory By Straight!"
	changeSongsWithScene()	
	return null
			
func victoryHandler(victoryMessage, victoryCards):
	gameOver = true
	matchScores[currentPlayer] += 1
	matchTotal += 1
	if(SaveManager.loadedData && SaveManager.loadedData.has("matchTotal") && SaveManager.loadedData["matchTotal"]):
		SaveManager.save_game_settings({"matchTotal": SaveManager.loadedData["matchTotal"]+ 1})
	else:
		SaveManager.save_game_settings({"matchTotal": 1})
	showMatchData()	
	SoundManager.lowerSound()
	SoundManager.play_preset(SoundManager.VICTORY_SOUND)	
	#Initalize Stuff
	var victoryAnimator = victoryScreen.get_node("victoryAnimator")
	victoryScreen.visible = true
	victoryAnimator.seek(0,true)
	victoryAnimator.play("victory_screen_appear")
	
	victoryScreen.get_node("Winner/Label").text = gamePlayers[currentPlayer].playerName	+ " Wins!"
	victoryScreen.get_node("VictoryPopup/VBoxContainer/VictoryType").text = victoryMessage
	var victoryScreenCardDisplay = victoryScreen.get_node("VictoryPopup/VBoxContainer/FlowContainer/PlayerCards");

#Clear Victory Cards If Any	
	for n in victoryScreenCardDisplay.get_children():
		victoryScreenCardDisplay.remove_child(n)
		n.queue_free()
#Display Victory Cards
	if(victoryCards):
		var cardTexturesToDisplay = victoryCards.map(func(pair): return pair[1]);		
		if(victoryScreenCardDisplay.get_children().size() < cardTexturesToDisplay.size()):
			while (victoryScreenCardDisplay.get_children().size() < cardTexturesToDisplay.size()):
				var newCardPreview = TextureRect.new()
				newCardPreview.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
				newCardPreview.set_expand_mode(TextureRect.EXPAND_KEEP_SIZE)
				newCardPreview.set_custom_minimum_size(Vector2(70,100))
				victoryScreenCardDisplay.add_child(newCardPreview)
		var i = 0
		for cardPreview in victoryScreenCardDisplay.get_children():		
			cardPreview.set_texture(cardTexturesToDisplay[i])
			i+= 1
	

func showMatchData():
	matchScoresTotalDisplay.text = "Matches: " + str(matchTotal)	
	var scoresAndNames = Array()
	for index in matchScores.size():
		scoresAndNames.append([playerNames[index], matchScores[index]])
	scoresAndNames.sort_custom(func(a,b): return a[1] > b[1])
	for playerScore in scoresAndNames:
		var instance = Label.new()
		instance.text = str(playerScore[0]) + ": " + str(playerScore[1])
		instance.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		matchScoresVbox.add_child(instance) 

func restart():
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

