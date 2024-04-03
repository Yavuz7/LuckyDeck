extends Node

var cardSelectionRandomizer

var continueSound = preload("res://assets/audio/soundEffects/selectsymbolsound3.mp3")
var returnSound = preload("res://assets/audio/soundEffects/selectsymbolsound.mp3")
var switchSound = preload("res://assets/audio/soundEffects/selectsymbolsound2.mp3")
var cardSelectSound = preload("res://assets/audio/soundEffects/cardselect2.mp3")

var sortCards = preload("res://assets/audio/soundEffects/sortcards2.mp3")
var pauseMenuOpen = preload("res://assets/audio/soundEffects/pauseOpen.mp3")
var pauseMenuClose = preload("res://assets/audio/soundEffects/pauseClose.mp3")
var defeatSound = preload("res://assets/audio/soundEffects/luckydeckdefeat.mp3")
var victorySound = preload("res://assets/audio/soundEffects/luckydeckvictory2.mp3")

var soundDictionary = [[continueSound, -4], 
[returnSound, -3], 
[switchSound, -5], 
[cardSelectSound, -3],
[sortCards,-6],
[pauseMenuOpen,-6],
[pauseMenuClose,-3],
[defeatSound,-6],
[victorySound,-6]]

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
	instance.bus = "Sounds"
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

var mainMenuSong : AudioStreamPlayer

var songPlaying = 0;
var songSetPlaying = 0;
var songSets

func songSetsChangeSong():
	#This needs to transition
	mainMenuSong.stop()
	songPlaying+= 1
	if(songPlaying > 4):
		return
	songSets[songSetPlaying].play()

func changeSongSets():
#Stop Music
	var previousVolume = songSets[songSetPlaying].volume_db
	songSets[songSetPlaying].volume_db = -100
#Cycle Back To Begining of Music without it playing noise
	while(songPlaying < 4):
		songSets[songSetPlaying].play()
		songPlaying += 1
	songPlaying = 0;
	songSets[songSetPlaying].stop()
	songSets[songSetPlaying].volume_db = previousVolume

#Play next series of songs
	songSetPlaying+= 1;
	if(songSetPlaying > 3):
		songSetPlaying = 0
#This should be called when the game is restarted
#	songSetsChangeSong()
	
		

func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
