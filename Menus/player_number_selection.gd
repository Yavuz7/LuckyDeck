extends Panel

@onready var players = $mainLayoutCredits/playerButtons/TextureRect/totalPlayers
@onready var playerFavoriteCardSelection = preload("res://Menus/player_favorite_card_menu.tscn")
@onready var player_line_edit = preload("res://Menus/player_name_edit.tscn")
@onready var playerNames = $mainLayoutCredits/PlayerNameChange/Panel/ScrollContainer/PlayerNames


var arrayOfCustomNames = SaveManager.loadedData["customNames"]
var previousNumOfPlayers = SaveManager.loadedData["numOfPlayers"]

func _ready():
	for n in range(previousNumOfPlayers):			
		var instance = player_line_edit.instantiate()
		var customName = get_custom_name(n)
		if(customName):
			instance.set_text(customName)
		else:
			instance.set_text("Player " + str(n+ 1))
			arrayOfCustomNames.append(instance.text);
		instance.place = n		
		instance.text_send.connect(_received_text_change)
		playerNames.add_child(instance)
	
	players.value = previousNumOfPlayers			
	print(playerNames.get_child_count());

func _received_text_change(text,place):
	arrayOfCustomNames[place] = text;
	
func _on_minus_pressed():
	if(players.value < 2):
		players.value = 2
		return;
	SoundManager.play_preset(SoundManager.SWITCH_SOUND)
	players.value -= 1


func _on_plus_pressed():
	players.value += 1
	if(players.value > 10):
		players.value = 10
		return
	SoundManager.play_preset(SoundManager.SWITCH_SOUND)	


func _on_continue_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	GameManager.numOfPlayers = players.value
	var arrayOfNamesToUse = arrayOfCustomNames.slice(0,players.value)
	GameManager.playerNames = arrayOfNamesToUse
	await SaveManager.save_game_settings({"numOfPlayers" : players.value, "customNames" : arrayOfCustomNames})
	await SaveManager.update_data()
	print(SaveManager.loadedData)
	get_parent().add_child(playerFavoriteCardSelection.instantiate())
	self.queue_free()


func _on_return_to_main_menu_pressed():
	SoundManager.play_preset(SoundManager.RETURN_SOUND)
	SaveManager.save_game_settings({"numOfPlayers" : players.value, "customNames" : arrayOfCustomNames})
	SaveManager.update_data()
	self.queue_free()

#This function Adds and removes children to match the number of players
#Then it sets them to a custom name if there is one
#Otherwise it will simply Set it to the old name
func _on_total_players_value_changed(value):
	if(playerNames.get_child_count() < players.value):
		while playerNames.get_child_count() < players.value:
			var instance = player_line_edit.instantiate()
			instance.place = playerNames.get_child_count()
			instance.text_send.connect(_received_text_change)			
			#Replace text with previous name
			var customName = get_custom_name(playerNames.get_child_count());
			if(customName):
				instance.set_text(customName)
			else:
				#This case shouldn't exist after loading
				instance.set_text("Player " + str(playerNames.get_child_count()+ 1))
				arrayOfCustomNames.append(instance.text)
			playerNames.add_child(instance)
			
			
	if(playerNames.get_child_count() > players.value):
		while playerNames.get_child_count() > players.value:	
			var playerToBeRemoved = playerNames.get_child(playerNames.get_child_count() - 1)
			playerNames.remove_child(playerToBeRemoved)
			playerToBeRemoved.queue_free()
			print(playerNames.get_child_count());	

func get_custom_name(index):
	if(arrayOfCustomNames.size() > index):
		return arrayOfCustomNames[index]
	else:
		return null
