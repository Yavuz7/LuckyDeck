extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	var deckDealer = preload("res://Scripts/deckDealer.gd").new(GameManager.numOfPlayers)
	add_child(deckDealer)
	GameManager.fillPlayerArray()
	setUpGame()
	GameManager.setStart(0)	
func setUpGame():
	GameManager.Game = $"."
	GameManager.previewCard = $drawnCard
	GameManager.card_animator = $drawnCard/cardAnimator
	GameManager.playerDisplay = $gameHeader/TopGui/HSplitContainer/HBoxContainer/CurrentPlayerName
	GameManager.turnPlayerFavoriteCard = $gameHeader/TopGui/HSplitContainer/HBoxContainer/turnPlayerFavoriteCard
	GameManager.footerDisplay = $ButtonSceneFooter/BottomGui/ScrollContainer/currentPlayerCards
	GameManager.victoryScreen = $VictoryScreen
	GameManager.matchScoresVbox = $VictoryScreen/VictoryPopup/VBoxContainer/MarginContainer2/playerScores/VBoxContainer
	GameManager.matchScoresTotalDisplay = $VictoryScreen/VictoryPopup/VBoxContainer/MatchesTotal
	SoundManager.cardSelectionRandomizer = $GameSoundsSpecifically/cardSelection
	SoundManager.songSets = [$GameSoundsSpecifically/SongSet1,$GameSoundsSpecifically/SongSet2,
	$GameSoundsSpecifically/SongSet3,$GameSoundsSpecifically/SongSet4]
	SoundManager.songSetsChangeSong()
func _on_button_scene_footer_pressed():
	SoundManager.play_preset(SoundManager.SORT_CARDS_SOUND)
	GameManager.displayCurrentPlayerCards(true)
	pass # Replace with function body.


func _on_restart_game_pressed():
	SoundManager.songSets[SoundManager.songSetPlaying].stop()
	SoundManager.changeSongSets()
	SoundManager.songSetsChangeSong()
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	$VictoryScreen.visible = false;

#Reset GameManager Stuff
	GameManager.outPlayers = []
	
	for player in GameManager.gamePlayers:
		player.deleteSelf();
	
	GameManager.gamePlayers.clear()
	
	for n in $VictoryScreen/VictoryPopup/VBoxContainer/MarginContainer2/playerScores/VBoxContainer.get_children():
		$VictoryScreen/VictoryPopup/VBoxContainer/MarginContainer2/playerScores/VBoxContainer.remove_child(n)
		n.queue_free()
#Clear Footer Array
	for n in $ButtonSceneFooter/BottomGui/ScrollContainer/currentPlayerCards.get_children():
		$ButtonSceneFooter/BottomGui/ScrollContainer/currentPlayerCards.remove_child(n)
		n.queue_free()
#Clear Current Grid Of Cards
	for n in $gridMargin/grid.get_children():
		$gridMargin/grid.remove_child(n);
		n.queue_free()
#Create A New Deck, Again
	var deckDealer = preload("res://Scripts/deckDealer.gd").new(GameManager.numOfPlayers)
	add_child(deckDealer)
	

	GameManager.fillPlayerArray()

	
	GameManager.setStart(GameManager.currentPlayer)
	pass # Replace with function body.


func _on_return_to_main_menu_pressed():
	var buttonText = $VictoryScreen/ReturnToMainMenu/Label	
	if(buttonText.text == "Return To Main Menu"):
		buttonText.text = "You really want to return?"
		await get_tree().create_timer(5).timeout
		buttonText.text = "Return To Main Menu"
		return;
	elif(buttonText.text == "You really want to return?"):
		buttonText.text = "Really really want to return??"
	elif(buttonText.text == "Really really want to return??"):
		GameManager.matchScores = []
		GameManager.matchTotal = 0
		GameManager.usedCardBacks.clear()
		GameManager.cardBacks.clear()
		#Reset Stuff For Music
		SoundManager.play_preset(SoundManager.RETURN_SOUND)
		SoundManager.crossfade_to(SoundManager.menuMusic)
		GameManager.gameOver = false
		SoundManager.changeSongSets()
		#Clear Everything else
		for player in GameManager.gamePlayers:
			player.deleteSelf();
		GameManager.disabledAces.clear()
		GameManager.gamePlayers.clear()
		
		GameManager.outPlayers = []
		self.queue_free()
		pass # Replace with function body.

@onready var settingsMenu = preload("res://Menus/settings_menu.tscn")

func _on_settings_2_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	var instance = settingsMenu.instantiate()
	add_child(instance)
	
