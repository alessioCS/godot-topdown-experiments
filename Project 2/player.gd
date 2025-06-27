extends CharacterBody2D

const IDLE_SPEED : float = 0.
const MOVE_SPEED : float =  60.
var direction := Vector2.ZERO
@onready var sprite = $AnimatedSprite2D

enum States {IDLE, WALKING}
var state := States.IDLE

func _ready():
	pass
	
func handle_facing():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
	
func get_direction():
	return Input.get_vector("left", "right", "up", "down")
	
func _physics_process(_delta):
	direction = get_direction()
	
	if direction != Vector2.ZERO:
		state = States.WALKING
	else:
		state = States.IDLE
	
	match state:
		States.IDLE:
			sprite.play("idle")
			velocity = direction * IDLE_SPEED
		States.WALKING:
			sprite.play("walk")
			velocity = direction * MOVE_SPEED
	handle_facing()
	move_and_slide()
