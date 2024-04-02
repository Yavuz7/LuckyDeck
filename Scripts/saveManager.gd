extends Node

var loadedData

#
#custonNames, numOfPlayers, favoriteCards, cardBacks
func _ready():
	loadedData = load_game_settings(["customNames","numOfPlayers","favoriteCards"])	
#	save_game_settings({"customNames":["Joey Wheeler", "Kevin"],"numOfPlayers":2, "favoriteCards":{ 0: [2, 1], 1: [3, 11], 2: [4, 12] }})
	save_game_settings({"numOfPlayers" : "3"})
	
func save_game_settings(save_data_dict):	
	var config = ConfigFile.new()
	
	var err = config.load("user://savedGameSettings.cfg")
	
	if err != OK:
		print("Error Loading Data")
		return
	
	
	for key in save_data_dict:
		var temp = config.get_value("Settings", key)
		print(temp)
		config.set_value("Settings",key,save_data_dict[key])
		
	config.save("user://savedGameSettings.cfg")


func load_game_settings(load_data_array):
	var config = ConfigFile.new()
	var Data = {}
	
	var err = config.load("user://savedGameSettings.cfg")
	
	if err != OK:
		print("Error Loading Data")
		return
	
	for key in load_data_array:
		Data[key] = config.get_value("Settings", key)	

	
	return Data
