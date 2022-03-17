extends TextureRect

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	print("intro/ready")
	pass # Replace with function body.


func hide_intro():
	print("intro/hide")
	self.visible = false


func _on_Intro_start_game():
	print("intro/startgame")
	self.visible = false
