extends Button

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	emit_signal("start_game")
	self.hide()
	#get_node("../TileMap").show()
