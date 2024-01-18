extends Node

class_name Player

var index
#var playerName:Strin
var favoriteCard;
var cards = Array()
var cardTextures = Array()

#Arrays Of Each Individual Card and Suit value is stored here
#For The Purposes of Checking Victory Conditions
var arrayOfCardValues = Array()
var arrayOfSuitValues = Array()

func _init(favCard):
	favoriteCard = load("res://assets/Images/CardFronts/cards"+str(favCard[0])+"-"+str(favCard[1])+".png")
	cards = []
	cardTextures = []
	
