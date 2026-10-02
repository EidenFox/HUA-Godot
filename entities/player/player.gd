extends CharacterBody2D

#Valores Padrão
const SPEED = 500.0
const JUMP_VELOCITY = -700.0
var djump = 1
var baseDJump = 1

#player
@onready var pivot: Node2D = $Pivot
@onready var player_sprite: AnimatedSprite2D = $Pivot/Raposo
#Colisores/sensores
@onready var player_collision: CollisionPolygon2D = $BodyCollision
@onready var feet_collision: CollisionShape2D = $FeetCollision
@onready var platform_detector: Area2D = $PlatformDetector
#Aura
@onready var aura_area: Area2D = $aura_area
@onready var aura_shape: CollisionShape2D = $aura_area/radius


func _ready() -> void:
	GlobalState.aura_color_changed.connect(_on_aura_color_changed)
	aura_area.set_collision_mask_value(2, true)
	
	aura_area.body_entered.connect(_on_aura_body_entered)
	aura_area.body_exited.connect(_on_aura_body_exited)

func _on_aura_color_changed(_new_color: Color) -> void:
	queue_redraw()
	_update_aura_bodies()

# Efeito da Aura
func _update_aura_bodies() -> void:
	for body in aura_area.get_overlapping_bodies():
		if body is Barrier:
			body.update_collision_state(GlobalState.current_aura_color)

# Efeito da Aura
func _on_aura_body_entered(body: Node2D) -> void:
	if body is Barrier:
		body.update_collision_state(GlobalState.current_aura_color)

# Efeito da Aura
func _on_aura_body_exited(body: Node2D) -> void:
	if body is Barrier:
		body.reset_collision_state()

# Desenha a Aura
func _draw() -> void:
	var aura_color = GlobalState.current_aura_color
	aura_color.a = 0.3
	
	var center = aura_area.position + aura_shape.position
	var radius = aura_shape.shape.radius * aura_shape.scale.x
	
	draw_circle(center, radius, aura_color)

# Animações
func _update_animations(direction: float) -> void:
	if not is_on_floor():
		if velocity.y > 0:
			player_sprite.play("Fall")
	else:
		if direction != 0:
			if Input.is_action_pressed("run"):
				player_sprite.play("Run")
			else:
				player_sprite.play("Walk")
		else:
			player_sprite.play("Idle")

# Fisica
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		djump = baseDJump
		
	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor(): 
		#Plataforma que desce
		if Input.is_action_pressed("down"):
			set_collision_mask_value(3, false)
		else:
			velocity.y = JUMP_VELOCITY
			player_sprite.play("Jump")
	
	#para atravessar uma plataforma que desce
	if not get_collision_mask_value(3):
		var still_in_platform = false
		for body in platform_detector.get_overlapping_bodies():
			if body != self: #tinha dado ruim pq o detector tava sempre em cima de algo... do personagem
				still_in_platform = true
				break
		if still_in_platform == false:
			set_collision_mask_value(3, true)
	
	# Pulo Duplo
	if Input.is_action_just_pressed("jump") and djump >= 1 and not is_on_floor():
		djump -= 1
		velocity.y = JUMP_VELOCITY - 50
		player_sprite.stop()
		player_sprite.play("Jump")
	
	var direction := Input.get_axis("left", "right")
	
	# Andar
	if direction:
		# Correr
		if Input.is_action_pressed("run"):
			velocity.x = direction * SPEED * 1.5
		else:
			velocity.x = direction * SPEED
		
		if direction < 0:
			pivot.scale.x = -1
			player_collision.scale.x = -1
			feet_collision.position.x = 50
			aura_shape.position.x = 40
			queue_redraw()
		else:
			pivot.scale.x = 1
			player_collision.scale.x = 1
			feet_collision.position.x = -50
			aura_shape.position.x = -40
			queue_redraw()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D:
			collider.apply_central_impulse(-collision.get_normal() * 20.0)
			
	_update_animations(direction)
