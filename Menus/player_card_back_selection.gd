extends Panel



@onready var cardBacksContainer = $mainLayoutCredits/SelectionBox/cardSelection/MarginContainer/ScrollContainer/CardBacks
@onready var cardSelectTemplate = load("res://Menus/card_back_button_template.tscn")
@onready var matchesTotalDisplay = $mainLayoutCredits/SelectionBox/TitleHeading/textBoxes/VBoxContainer/TotalMatchesText
var cardLocked = preload("res://assets/Images/lockedCard.png")
var numberOfCardsExpected = 34
var matchesTotal = SaveManager.loadedData["matchTotal"]
var matchesLeft = 25 + matchesTotal
var arrayOfLoadedBacks = SaveManager.loadedData["cardBacks"]
# Called when the node enters the scene tree for the first time.
func _ready():
	matchesTotalDisplay.text = str(matchesTotal) + " Total Matches"	
	var i = 0
	while i < numberOfCardsExpected:
		matchesLeft -= 5
		if(matchesLeft >= 0):
			var indexString = str(i)
			while indexString.length() < 3:
				indexString = "0" + indexString
			var imageInstance = load("res://assets/Images/cardBacks/cb" + indexString +".png")
			if(imageInstance):
				var instance = cardSelectTemplate.instantiate()
				if(arrayOfLoadedBacks && arrayOfLoadedBacks.size() > 0):
					instance.init(false,imageInstance,arrayOfLoadedBacks.has(i));
				else:
					instance.init(false,imageInstance,false);					
				cardBacksContainer.add_child(instance)
		else:
			#Locked Cards
			var instance = cardSelectTemplate.instantiate()
			instance.init(true,cardLocked,false);	
			cardBacksContainer.add_child(instance)
		i+= 1
	pass # Replace with function body.


func _on_return_button_pressed():
	get_parent().call_deferred("add_child",load("res://Menus/player_favorite_card_menu.tscn").instantiate())
	self.queue_free()
	pass # Replace with function body.


func _on_start_game_pressed():
	get_parent().call_deferred("add_child",load("res://Menus/Game.tscn").instantiate())
	self.queue_free()
