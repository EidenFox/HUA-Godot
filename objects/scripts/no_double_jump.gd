extends Area2D
class_name NoDoubleJumpZone

var oldDJump = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# zera a base de pulos extras do player 
func _on_body_entered(body: Node2D) -> void:
	oldDJump = body.baseDJump
	if "baseDJump" in body:
		body.baseDJump = 0

# devolve a capacidade de duplo pulo
func _on_body_exited(body: Node2D) -> void:
	if "baseDJump" in body:
		body.baseDJump = oldDJump
