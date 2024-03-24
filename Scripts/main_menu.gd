extends Control

@onready var playerMenu = preload("res://Menus/player_number_selection.tscn")
@onready var rulesMenu = preload("res://Menus/rules_menu.tscn")
@onready var settingsMenu = preload("res://Menus/settings_menu.tscn")
@onready var creditsMenu = preload("res://Menus/credits_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
#Music Starts Here

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


