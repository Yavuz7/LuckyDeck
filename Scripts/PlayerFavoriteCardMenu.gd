extends Panel

@export var suitSelect: ButtonGroup
enum suitValues{none,Diamond,Heart,Spade,Club}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func saveSelection():
	print(suitValues.get(suitSelect.get_pressed_button().name))


func _on_start_game_pressed():
	saveSelection()
	pass # Replace with function body.
