extends Node

signal f
signal game_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	print("oui")


func hide_screen():
	$Map.visible = true
	$Intro.visible = false
	$Background.visible = true
	$Map/Player/Camera.current = true
	yield(get_node("Map/Trophee"),"game_ended")
	rpc("signal_f")
	
remotesync func signal_f():
	emit_signal("f")

