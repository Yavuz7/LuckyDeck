extends Node

class_name Player

var index
#var playerName:Strin
var favoriteCard;
var cards = Array()
var cardTextures = Array()

#Sorted Arrays
var cardTexturesSortedValues = Array()
var cardTexturesSortedSuits = Array()


func _init(favCard):
	favoriteCard = load("res://assets/Images/CardFronts/cards"+str(favCard[0])+"-"+str(favCard[1])+".png")
	cards = []
	cardTextures = []
	
func addToArray(targetArray, cardValue, textureReference):

	if(targetArray.size() > 0):		
		for c in targetArray.size():
			if(targetArray[c][0] >= cardValue):
				targetArray.insert(c,[cardValue,textureReference])
				return
			if(targetArray[c] == targetArray[targetArray.size() - 1]):
				targetArray.insert(c+1,[cardValue,textureReference])
				return
	else:
		targetArray.append([cardValue,textureReference])

func getValues(val):
	return cardTexturesSortedValues.filter(func (pair): return pair[0] == val );
	
func getSuits(val):
	return cardTexturesSortedSuits.filter(func (pair): return pair[0] == val );

func getStraight(uniqueArray):
	var iteratedArray = uniqueArray;
	return cardTexturesSortedValues.filter(func (pair): 
		var cardIndex = iteratedArray.find(pair[0])
		if(cardIndex != -1):
			iteratedArray.remove_at(cardIndex)
			return true
		else:	
			return false );
	
