extends Panel



@onready var cardBacks = $mainLayoutCredits/SelectionBox/cardSelection/MarginContainer/CardBacks
@onready var cardSelectTemplate = load("res://Menus/card_back_button_template.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = cardSelectTemplate.instantiate()
	instance.init(false,GameManager.cardBack,false);
	cardBacks.add_child(instance)
	pass # Replace with function body.


func _on_return_button_pressed():
	get_parent().call_deferred("add_child",load("res://Menus/player_favorite_card_menu.tscn").instantiate())
	self.queue_free()
	pass # Replace with function body.


func _on_start_game_pressed():
	get_parent().call_deferred("add_child",load("res://Menus/Game.tscn").instantiate())
	self.queue_free()
