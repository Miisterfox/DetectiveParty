extends Area2D

class_name Dice

signal dice_rolled

func _unhandled_input(event):
	if event.is_action_pressed("dice_clicked"):
		emit_signal("dice_rolled")

