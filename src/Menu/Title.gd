extends Label

export(Color, RGB) var text_color

func _ready():
	set_modulate(text_color)
	pass
