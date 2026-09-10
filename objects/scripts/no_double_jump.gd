extends Area2D
class_name NoDoubleJumpZone

var oldDJump

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# salva e zera o baseDJump e zera o restante dos dJump 
func _on_body_entered(body: Node2D) -> void:
	if "baseDJump" in body:
		oldDJump = body.baseDJump
		body.baseDJump = 0
		if "djump" in body:
			body.djump = 0

# devolve o duplo pulo
func _on_body_exited(body: Node2D) -> void:
	if "baseDJump" in body:
		body.baseDJump = oldDJump
