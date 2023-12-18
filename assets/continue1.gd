extends Button
		
func _on_pressed():
	var players = get_parent().get_node("mainLayoutCredits/playerButtons/TextureRect/totalPlayers")
	GameManager.numOfPlayers = players.value
	print("Players: " + str(GameManager.numOfPlayers))
	
