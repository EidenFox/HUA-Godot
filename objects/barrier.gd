extends StaticBody2D
class_name Barrier

# COR
@export var barrier_color: Color = Color.WHITE

@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# Aplica a cor definida ao ColorRect visualmente
	color_rect.color = barrier_color
	
	# Conecta o sinal do Autoload (assumindo que o nome do sinal no GlobalState é background_color_changed)
	GlobalState.background_color_changed.connect(_on_background_color_changed)
	
	# Faz a checagem inicial para garantir o estado correto ao iniciar a cena
	_check_color_match(GlobalState.current_background_color)

func _on_background_color_changed(new_color: Color) -> void:
	_check_color_match(new_color)

# checa se a cor é = ao fundo
func _check_color_match(bg_color: Color) -> void:
	if barrier_color == bg_color:
		hide()
		collision_shape.set_deferred("disabled", true)
	else:
		show()
		collision_shape.set_deferred("disabled", false)
