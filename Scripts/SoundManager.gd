extends Node

var continueSound = preload("res://assets/audio/soundEffects/buttondefault4.mp3")
var returnSound = preload("res://assets/audio/soundEffects/returnbutton.mp3")
var switchSound = preload("res://assets/audio/soundEffects/switchplayerbutton.mp3")
var cardSelectSound = preload("res://assets/audio/soundEffects/cardSelect.mp3")

var sortCards = preload("res://assets/audio/soundEffects/sortcards2.mp3")
var pauseMenuOpen = preload("res://assets/audio/soundEffects/pausemenuopen2.mp3")
var pauseMenuClose = preload("res://assets/audio/soundEffects/pausemenuclose2.mp3")
var defeatSound = preload("res://assets/audio/soundEffects/DefeatSound.mp3")
var victorySound = preload("res://assets/audio/soundEffects/victorysound.mp3")

#	Here is the sounds With their Volume
var soundDictionary = [[continueSound, 10], 
[returnSound, -3], 
[switchSound, -5], 
[cardSelectSound, 4],
[sortCards,-6],
[pauseMenuOpen,-6],
[pauseMenuClose,-11],
[defeatSound,-3],
[victorySound,0]]

enum {CONTINUE_SOUND,
RETURN_SOUND,
SWITCH_SOUND,
CARD_SELECT_SOUND,
SORT_CARDS_SOUND,
PAUSE_OPEN_SOUND,
PAUSE_CLOSE_SOUND,
DEFEAT_SOUND,
VICTORY_SOUND}

#Only One Song Will Play at a time
var currentSong : AudioStreamPlayer
var nextSong : AudioStreamPlayer
#Sound Controller Derived from : https://youtu.be/mnm7uV4MOTk?si=Edpxw_AZpkCln1s_

func play_preset(soundKey: int):
	var instance = AudioStreamPlayer.new()
	instance.stream = soundDictionary[soundKey][0]
	instance.volume_db = soundDictionary[soundKey][1]
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()

func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()


func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
