extends Node

signal background_color_changed(new_color: Color)

var current_background_color: Color = Color.html("#a7a7a7"):
	set(value):
		current_background_color = value
		RenderingServer.set_default_clear_color(value)
		background_color_changed.emit(value)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_UP:
			current_background_color = Color.html("#FF0000")
		elif event.keycode == KEY_LEFT:
			current_background_color = Color.html("00FF00")
		elif event.keycode == KEY_RIGHT:
			current_background_color = Color.html("0000FF")
