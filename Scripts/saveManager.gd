extends Node

var loadedData

#
#custonNames, numOfPlayers, favoriteCards, matchTotal ,cardBacks, matchTotal
func _ready():
	loadedData = load_game_settings(["customNames","numOfPlayers","favoriteCards","cardBacks","AudioSettings"])	
#	save_game_settings({"customNames":["Joey Wheeler", "Kevin"],"numOfPlayers":2, "favoriteCards":{ 0: [2, 1], 1: [3, 11], 2: [4, 12], "cardBacks":[0,1,2] }})
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !loadedData["AudioSettings"][0])
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sounds"), !loadedData["AudioSettings"][1])
	
func update_data():
		loadedData = load_game_settings(["customNames","numOfPlayers","favoriteCards","cardBacks","matchTotal","AudioSettings"])
func save_game_settings(save_data_dict):	
	var config = ConfigFile.new()
	
	var err = config.load("user://savedGameSettings.cfg")
	
	if err != OK:
		print("Error Loading Data")
		return
	
	
	for key in save_data_dict:
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
