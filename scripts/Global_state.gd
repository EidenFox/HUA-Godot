extends Node

# Sinal emitido sempre que a cor de fundo mudar
signal background_color_changed(new_color: Color)

var current_background_color: Color = Color.BLACK:
	set(value):
		current_background_color = value
		background_color_changed.emit(value)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_O:
			current_background_color = Color.html("#fc00ff")
		elif event.keycode == KEY_P:
			current_background_color = Color.BLACK
