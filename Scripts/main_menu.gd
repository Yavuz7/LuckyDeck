extends Control

@onready var playerMenu = preload("res://Menus/player_number_selection.tscn")
@onready var rulesMenu = preload("res://Menus/rules_menu.tscn")
@onready var settingsMenu = preload("res://Menus/settings_menu.tscn")
@onready var creditsMenu = preload("res://Menus/credits_menu.tscn")
@onready var buyMeABananaMenu = preload("res://Menus/buyMeABanana.tscn")

func _ready():
	SoundManager._anim_player = $MusicFader/AnimationPlayer
	SoundManager._track_1 = $MusicFader/Track1
	SoundManager._track_2 = $MusicFader/Track2
	SoundManager.crossfade_to(SoundManager.menuMusic)

func _on_play_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	var instance = playerMenu.instantiate()
	add_child(instance)
	
func _on_rules_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	var instance = rulesMenu.instantiate()
	add_child(instance)

func _on_settings_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	var instance = settingsMenu.instantiate()
	add_child(instance)


func _on_credits_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	var instance = creditsMenu.instantiate()
	add_child(instance)




func _on_buy_me_a_banana_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	var instance = buyMeABananaMenu.instantiate()
	add_child(instance)
