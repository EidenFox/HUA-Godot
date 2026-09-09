extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -700.0

@onready var pivot: Node2D = $Pivot
@onready var player_spriteD: AnimatedSprite2D = $Pivot/PlayerSprite
@onready var player_sprite: AnimatedSprite2D = $Pivot/Raposo
@onready var player_collision: CollisionShape2D = $PlayerCollision
@onready var aura_area: Area2D = $aura_area
@onready var aura_shape: CollisionShape2D = $aura_area/radius

var djump = 0
var baseDJump = 1

func _ready() -> void:
	GlobalState.aura_color_changed.connect(_on_aura_color_changed)
	aura_area.set_collision_mask_value(2, true)
	
	aura_area.body_entered.connect(_on_aura_body_entered)
	aura_area.body_exited.connect(_on_aura_body_exited)

func _on_aura_color_changed(_new_color: Color) -> void:
	queue_redraw()
	_update_aura_bodies()

# itera sobre todos os corpos físicos dentro do raio do Area2D e atualiza seus estados de colisão
func _update_aura_bodies() -> void:
	for body in aura_area.get_overlapping_bodies():
		if body is Barrier:
			body.update_collision_state(GlobalState.current_aura_color)

# acionada via signal quando um nó entra no raio
func _on_aura_body_entered(body: Node2D) -> void:
	if body is Barrier:
		body.update_collision_state(GlobalState.current_aura_color)

# acionada via signal quando um nó sai do raio
func _on_aura_body_exited(body: Node2D) -> void:
	if body is Barrier:
		body.reset_collision_state()

func _draw() -> void:
	var aura_color = GlobalState.current_aura_color
	aura_color.a = 0.3 # Define 30% de opacidade
	
	var center = aura_area.position + aura_shape.position
	var radius = aura_shape.shape.radius * aura_shape.scale.x
	
	draw_circle(center, radius, aura_color)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		player_sprite.play("Air");
		
	if is_on_floor():
		djump = baseDJump
		
	if Input.is_action_just_pressed("jump") and is_on_floor(): 
		velocity.y = JUMP_VELOCITY
		player_sprite.play("Jump");
	
	if Input.is_action_just_pressed("jump") and djump >= 1 and not is_on_floor():
		djump -= 1
		velocity.y = JUMP_VELOCITY-50
		player_sprite.play("Jump");
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		if Input.is_action_pressed("run"):
			velocity.x = direction * SPEED * 1.5
			player_sprite.play("Run");
			player_spriteD.play("Run");
			
		else:
			velocity.x = direction * SPEED
			player_sprite.play("Walk");
			player_spriteD.play("Walk");
		
		if direction < 0:
			pivot.scale.x = -1
			player_collision.position.x = 45
			aura_shape.position.x = 40
			queue_redraw()
		else:
			pivot.scale.x = 1
			player_collision.position.x = -45
			aura_shape.position.x = -40
			queue_redraw()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		player_sprite.play("Idle");
		player_spriteD.play("Idle");

	move_and_slide()
