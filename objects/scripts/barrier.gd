@tool
extends StaticBody2D
class_name Barrier

# Cria as 6 opções fixas para o menu
enum AvailableColors {
	RED,
	GREEN,
	BLUE,
	YELLOW,
	MAGENTA,
	CYAN
}

# Exporta o menu para o Inspector e monitora as mudanças
@export var barrier_type: AvailableColors = AvailableColors.MAGENTA:
	set(value):
		barrier_type = value
		_apply_color_from_selection()

var barrier_color: Color = Color.html("#FF00FF")

@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_apply_color_from_selection()
	
	if not Engine.is_editor_hint():
		set_collision_layer_value(2, true)

func _apply_color_from_selection() -> void:
	match barrier_type:
		AvailableColors.RED: barrier_color = Color.html("#FF0000")
		AvailableColors.GREEN: barrier_color = Color.html("#00FF00")
		AvailableColors.BLUE: barrier_color = Color.html("#0000FF")
		AvailableColors.YELLOW: barrier_color = Color.html("#FFFF00")
		AvailableColors.MAGENTA: barrier_color = Color.html("#FF00FF")
		AvailableColors.CYAN: barrier_color = Color.html("#00FFFF")
		
	_update_visuals()

func _update_visuals() -> void:
	if is_node_ready() and color_rect:
		color_rect.color = barrier_color

func update_collision_state(aura_color: Color) -> void:
	if barrier_color == aura_color:
		set_collision_layer_value(1, false)
	else:
		set_collision_layer_value(1, true)

func reset_collision_state() -> void:
	set_collision_layer_value(1, true)
