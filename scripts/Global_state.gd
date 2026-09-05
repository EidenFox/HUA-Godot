extends Node

var COLOR_RED = Color.html("#FF0000")
var COLOR_GREEN = Color.html("#00FF00")
var COLOR_BLUE = Color.html("#0000FF")
var COLOR_YELLOW = Color.html("#FFFF00")
var COLOR_MAGENTA = Color.html("#FF00FF")
var COLOR_CYAN = Color.html("#00FFFF")
var COLOR_DEFAULT = Color.html("#a7a7a7")

signal aura_color_changed(new_color: Color)

var current_aura_color: Color = COLOR_DEFAULT:
	set(value):
		current_aura_color = value
		aura_color_changed.emit(value)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_UP:
			current_aura_color = COLOR_RED
		elif event.keycode == KEY_LEFT:
			current_aura_color = COLOR_GREEN
		elif event.keycode == KEY_RIGHT:
			current_aura_color = COLOR_BLUE
