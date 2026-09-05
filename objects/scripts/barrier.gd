extends StaticBody2D
class_name Barrier

@export var barrier_color: Color = Color.MAGENTA

@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	color_rect.color = barrier_color
	set_collision_layer_value(2, true)

func update_collision_state(aura_color: Color) -> void:
	if barrier_color == aura_color:
		set_collision_layer_value(1, false)
	else:
		set_collision_layer_value(1, true)

func reset_collision_state() -> void:
	set_collision_layer_value(1, true)
