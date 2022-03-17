extends Area2D

signal game_ended


func _on_Trophee_body_entered(body):
	self.hide()
	get_node("../EndGame").visible = true
	get_node("../EndGame/Camera2D").current = true
	emit_signal("game_ended")
