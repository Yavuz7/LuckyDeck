extends Panel

@onready var cardBacks = $mainLayoutCredits/SelectionBox/cardSelection/MarginContainer/CardBacks

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_return_button_pressed():
	get_parent().call_deferred("add_child",load("res://Menus/player_favorite_card_menu.tscn").instantiate())
	self.queue_free()
	pass # Replace with function body.


func _on_start_game_pressed():
	get_parent().call_deferred("add_child",load("res://Menus/Game.tscn").instantiate())
	self.queue_free()
