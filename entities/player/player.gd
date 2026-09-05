extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var pivot: Node2D = $Pivot
@onready var player_sprite: AnimatedSprite2D = $Pivot/PlayerSprite
@onready var player_colision: CollisionShape2D = $PlayerColision
@onready var color_rect: ColorRect = $ColorRect

var djump = 0
var baseDJump = 1

func _ready() -> void:
	color_rect.color = GlobalState.current_background_color
	GlobalState.background_color_changed.connect(_on_background_color_changed)

func _on_background_color_changed(new_color: Color) -> void:
	color_rect.color = new_color

func _physics_process(delta: float) -> void:
	#double jump (adicionar função para couldown depois)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		djump = baseDJump
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor(): 
		velocity.y = JUMP_VELOCITY
		#djump = baseDJump
	
	if Input.is_action_just_pressed("jump") and djump >= 1 and not is_on_floor():
		djump -= 1
		velocity.y = JUMP_VELOCITY-50
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = direction * SPEED * 1.5
			player_sprite.play("Run")
		else:
			velocity.x = direction * SPEED
			player_sprite.play("Walk")
		
		if direction < 0:
			pivot.scale.x = -1
			player_colision.position.x = 50
		else:
			pivot.scale.x = 1
			player_colision.position.x = -50	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		player_sprite.play("Idle")

	move_and_slide()
