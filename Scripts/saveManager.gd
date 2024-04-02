extends Node

var loadedData

#
#custonNames, numOfPlayers, favoriteCards, cardBacks
func _ready():
	loadedData = load_game_settings(["customNames","numOfPlayers"])


func save_game_settings(save_data_dict):
	var config = ConfigFile.new()
	
	for key in save_data_dict:
		config.set_value("Settings",key,save_data_dict[key])
		
	config.save("user://savedGameSettings.cfg")


func load_game_settings(load_data_array):
	var config = ConfigFile.new()
	var loadedData = {}
	
	var err = config.load("user://savedGameSettings.cfg")
	
	if err != OK:
		print("Error Loading Data")
		return
	
	for key in load_data_array:
		loadedData[key] = config.get_value("Settings", key)	

	
	return loadedData
