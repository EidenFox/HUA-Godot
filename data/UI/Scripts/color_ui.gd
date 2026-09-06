extends Control

@onready var green_panel: Panel = $GREEN/TextureRect/Panel
@onready var red_panel: Panel = $RED/TextureRect/Panel
@onready var blue_panel: Panel = $BLUE/TextureRect/Panel

var primary_key: String = ""
var secondary_key: String = ""

const ID_RED = "red"
const ID_GREEN = "green"
const ID_BLUE = "blue"

func _ready() -> void:
	_update_visuals()

func _input(event: InputEvent) -> void:
	_handle_input(event, "color_red", ID_RED)
	_handle_input(event, "color_green", ID_GREEN)
	_handle_input(event, "color_blue", ID_BLUE)

# Tecla primária segurada e tecla secundária
func _handle_input(event: InputEvent, action: String, color_id: String) -> void:
	if event.is_action_pressed(action):
		if primary_key == "":
			# cor primária
			primary_key = color_id
			_apply_color_combination()
			_update_visuals()
		elif primary_key != color_id:
			secondary_key = color_id
			_apply_color_combination()
			
	# Quando soltar a tecla prim/sec
	elif event.is_action_released(action):
		if color_id == primary_key:
			primary_key = ""
			secondary_key = ""
			_update_visuals()
		elif color_id == secondary_key:
			secondary_key = ""
			_apply_color_combination()

# cores dos botões (misturas)
func _update_visuals() -> void:
	if primary_key == "":
		red_panel.self_modulate = GlobalState.COLOR_RED
		green_panel.self_modulate = GlobalState.COLOR_GREEN
		blue_panel.self_modulate = GlobalState.COLOR_BLUE
	elif primary_key == ID_RED:
		red_panel.self_modulate = GlobalState.COLOR_RED
		green_panel.self_modulate = GlobalState.COLOR_YELLOW
		blue_panel.self_modulate = GlobalState.COLOR_MAGENTA
	elif primary_key == ID_GREEN:
		red_panel.self_modulate = GlobalState.COLOR_YELLOW
		green_panel.self_modulate = GlobalState.COLOR_GREEN
		blue_panel.self_modulate = GlobalState.COLOR_CYAN
	elif primary_key == ID_BLUE:
		red_panel.self_modulate = GlobalState.COLOR_MAGENTA
		green_panel.self_modulate = GlobalState.COLOR_CYAN
		blue_panel.self_modulate = GlobalState.COLOR_BLUE

# Aplica a cor escolhida no globalState
func _apply_color_combination() -> void:
	if secondary_key == "":
		match primary_key:
			ID_RED: GlobalState.current_aura_color = GlobalState.COLOR_RED
			ID_GREEN: GlobalState.current_aura_color = GlobalState.COLOR_GREEN
			ID_BLUE: GlobalState.current_aura_color = GlobalState.COLOR_BLUE
	else:
		var combo = primary_key + "_" + secondary_key
		match combo:
			"red_green", "green_red": GlobalState.current_aura_color = GlobalState.COLOR_YELLOW
			"red_blue", "blue_red": GlobalState.current_aura_color = GlobalState.COLOR_MAGENTA
			"green_blue", "blue_green": GlobalState.current_aura_color = GlobalState.COLOR_CYAN
