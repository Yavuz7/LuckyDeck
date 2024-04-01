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
	SoundManager.cardSelectionRandomizer = $GameSoundsSpecifically/cardSelection
	SoundManager.songSets = [$GameSoundsSpecifically/SongSet1,$GameSoundsSpecifically/SongSet2,
	$GameSoundsSpecifically/SongSet3,$GameSoundsSpecifically/SongSet4]
	SoundManager.songSetsChangeSong()
func _on_button_scene_footer_pressed():
	SoundManager.play_preset(SoundManager.SORT_CARDS_SOUND)
	GameManager.displayCurrentPlayerCards(true)
	pass # Replace with function body.


func _on_restart_game_pressed():
	SoundManager.play_preset(SoundManager.CONTINUE_SOUND)
	$VictoryScreen.visible = false;

#Reset GameManager Stuff
	GameManager.outPlayers = []
	
	for player in GameManager.gamePlayers:
		player.deleteSelf();
	
	GameManager.gamePlayers.clear()
	
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

	
	var randomPlayer = RandomNumberGenerator.new()
	var randomIndex = randomPlayer.randi_range(0,GameManager.numOfPlayers - 1)
	GameManager.setStart(randomIndex)
	pass # Replace with function body.


func _on_return_to_main_menu_pressed():

	
	var buttonText = $VictoryScreen/ReturnToMainMenu/Label
	if(buttonText.text == "Return To Main Menu"):
		buttonText.text = "You really want to return?"
		await get_tree().create_timer(5).timeout
		buttonText.text = "Return To Main Menu"
	elif(buttonText.text == "You really want to return?"):
		buttonText.text = "Really really want to return??"
	elif(buttonText.text == "Really really want to return??"):
		SoundManager.play_preset(SoundManager.RETURN_SOUND)
		for player in GameManager.gamePlayers:
			player.deleteSelf();
		
		GameManager.disabledAces.clear()
		GameManager.gamePlayers.clear()
		
		GameManager.outPlayers = []
		self.queue_free()
	pass # Replace with function body.
