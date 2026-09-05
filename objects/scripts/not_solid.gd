extends StaticBody2D
class_name NotSolid

@export var not_solid_color: Color = Color.BLACK

@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	color_rect.color = not_solid_color
