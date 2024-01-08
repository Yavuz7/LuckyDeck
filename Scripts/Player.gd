extends Node

class_name Player

var index
#var playerName:String
var favoriteCard = Array()
var cards = Array()
var cardTextures = Array()

#Arrays Of Each Individual Card and Suit value is stored here
#For The Purposes of Checking Victory Conditions
var arrayOfCardValues = Array()
var arrayOfSuitValues = Array()

func _init(favCard):
	favoriteCard = favCard
	cards = []
	cardTextures = []
	
