extends Panel

#Audio Mute Code From: https://youtu.be/ydT7V2L2jFA?si=zByJABpLn57EeXq9
var music_bus = AudioServer.get_bus_index("Music")
var sounds_bus = AudioServer.get_bus_index("Sounds")

@onready var musicCheck = $"mainLayoutSettings/SettingsSeperator/Music Toggle/MarginContainer/MusicCheck"
@onready var soundsCheck = $"mainLayoutSettings/SettingsSeperator/VFX Toggle/MarginContainer/SoundsCheck"

func _ready():
	musicCheck.button_pressed = SaveManager.loadedData["AudioSettings"][0]
	soundsCheck.button_pressed = SaveManager.loadedData["AudioSettings"][1]

func _on_return_pressed():
	SoundManager.play_preset(SoundManager.RETURN_SOUND)
	SaveManager.save_game_settings({"AudioSettings":[musicCheck.button_pressed,soundsCheck.button_pressed]})
	SaveManager.update_data()
	self.queue_free()
	pass # Replace with function body.


func _on_music_check_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))


func _on_sounds_check_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	AudioServer.set_bus_mute(sounds_bus, not AudioServer.is_bus_mute(sounds_bus))
	
