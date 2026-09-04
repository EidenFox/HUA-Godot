extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var pivot: Node2D = $Pivot
@onready var player_sprite: AnimatedSprite2D = $Pivot/PlayerSprite
@onready var player_colision: CollisionShape2D = $PlayerColision


var djump = 0
var baseDJump = 1
func _physics_process(delta: float) -> void:
	#double jump (adicionar função para couldown depois)
	
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor(): 
		velocity.y = JUMP_VELOCITY
		djump = baseDJump
	
	if Input.is_action_just_pressed("jump") and djump >= 1 and not is_on_floor():
		djump -= 1
		velocity.y = JUMP_VELOCITY-50
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	var run := Input.get
	
	if direction:
		
		if Input.is_action_pressed("run"):
			velocity.x = direction * SPEED * 1.5
			player_sprite.play("Run")
		else:
			velocity.x = direction * SPEED
			player_sprite.play("Walk")
		
		# Quando o player muda de dureção
		if direction < 0:
			pivot.scale.x = -1 #inverte a sprite (com base no centro do desenho, não no centro da imagem)
			player_colision.position.x = 50 #Centraliza a colision com base no centro do desenho
		else:
			pivot.scale.x = 1
			player_colision.position.x = -50	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		player_sprite.play("Idle")

	move_and_slide()
