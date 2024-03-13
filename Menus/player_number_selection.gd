extends Panel

@onready var players = $mainLayoutCredits/playerButtons/TextureRect/totalPlayers
@onready var playerFavoriteCardSelection = preload("res://Menus/player_favorite_card_menu.tscn")


func _on_minus_pressed():
	players.value -= 1
	if(players.value < 2):
		players.value = 2


func _on_plus_pressed():
	players.value += 1
	if(players.value > 16):
		players.value = 16


func _on_continue_pressed():
	GameManager.numOfPlayers = players.value
	
	get_parent().add_child(playerFavoriteCardSelection.instantiate())
	self.queue_free()
