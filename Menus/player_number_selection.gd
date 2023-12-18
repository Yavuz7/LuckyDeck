extends Panel

@onready var players = $mainLayoutCredits/playerButtons/TextureRect/totalPlayers


func _on_minus_pressed():
	players.value -= 1
	if(players.value < 2):
		players.value = 2
	pass # Replace with function body.


func _on_plus_pressed():
	players.value += 1
	if(players.value > 100):
		players.value = 100
