extends Node

var loadedData

var sampleData = {"customNames":["Player 1", "Player 2"],"numOfPlayers":2, "favoriteCards":{ 0: [1, 1], 1: [2, 1], 2: [3, 1]}, "cardBacks":[0,1,2], "matchTotal": 0 }

#
#custonNames, numOfPlayers, favoriteCards, matchTotal ,cardBacks, matchTotal
func _ready():
	loadedData = load_game_settings(["customNames","numOfPlayers","favoriteCards","cardBacks","AudioSettings", "matchTotal"])	
	if(!loadedData):
		save_game_settings(sampleData)
	if(loadedData && loadedData.has("AudioSettings") && loadedData["AudioSettings"]):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !loadedData["AudioSettings"][0])
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sounds"), !loadedData["AudioSettings"][1])
	
	
func update_data():
		loadedData = load_game_settings(["customNames","numOfPlayers","favoriteCards","cardBacks","matchTotal","AudioSettings"])

func save_game_settings(save_data_dict):	
	var config = ConfigFile.new()
	
	if(loadedData):
		for key in loadedData:
			config.set_value("Settings",key,loadedData[key])			
	
	for key in save_data_dict:
		config.set_value("Settings",key,save_data_dict[key])
	
	
	config.save("user://savedGameSettings.cfg")
	update_data()


func load_game_settings(load_data_array):
	var config = ConfigFile.new()
	var Data = {}
	
	var err = config.load("user://savedGameSettings.cfg")
	
	if err != OK:
		print("Error Loading Data")
		return
	
	for key in load_data_array:
		if(config.has_section_key("Settings",key)):
			Data[key] = config.get_value("Settings", key)	

	
	return Data
