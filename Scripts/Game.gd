extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	var deckDealer = preload("res://Scripts/deckDealer.gd").new(GameManager.numOfPlayers)
	add_child(deckDealer)
	GameManager.fillPlayerArray()
	setUpGame()
	GameManager.setStart()
func setUpGame():
	GameManager.Game = $"."
	GameManager.previewCard = $drawnCard
	GameManager.card_animator = $drawnCard/cardAnimator
	GameManager.playerDisplay = $gameHeader/TopGui/HSplitContainer/HBoxContainer/CurrentPlayerName
	GameManager.turnPlayerFavoriteCard = $gameHeader/TopGui/HSplitContainer/HBoxContainer/turnPlayerFavoriteCard
	GameManager.footerDisplay = $ButtonSceneFooter/BottomGui/ScrollContainer/currentPlayerCards
