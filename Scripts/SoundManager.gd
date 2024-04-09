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

@onready var menuMusic = preload("res://assets/audio/music/luckydeckmenumusic.mp3")

var _anim_player
var _track_1 
var _track_2 

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

var songSets = Array()
func _ready():	
	for n in 4:
		songSets.append([])
		songSets[n].append(load("res://assets/audio/music/style" + str(n+1) + "early.mp3"))
		songSets[n].append(load("res://assets/audio/music/style" + str(n+1) + "halfway.mp3"))
		songSets[n].append(load("res://assets/audio/music/style" + str(n+1) + "late.mp3"))
		songSets[n].append(load("res://assets/audio/music/style" + str(n+1) + "super.mp3"))

#Code from Gdquest : https://www.gdquest.com/tutorial/godot/audio/background-music-transition/
func crossfade_to(audio_stream: AudioStream) -> void:
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if _track_1.playing and _track_2.playing:
		return

	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	if _track_2.playing:
		_track_1.stream = audio_stream
		_track_1.play()
		_anim_player.play("FadeToTrack1")
	else:
		_track_2.stream = audio_stream
		_track_2.play()
		_anim_player.play("FadeToTrack2")


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

var songPlaying = 0;
var songSetPlaying = 0;

func songSetsChangeSong():
	if(songPlaying > 3):
		return
	crossfade_to(songSets[songSetPlaying].stream.get_stream(songPlaying))
	songPlaying += 1
	
func changeSongSets():
	songPlaying = 0;
#Play next series of songs
	songSetPlaying+= 1;
	if(songSetPlaying > 3):
		songSetPlaying = 0
	
func lowerSound():
	if _track_2.playing:
		_track_2.volume_db = -25
	else:
		_track_1.volume_db = -25		

func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
