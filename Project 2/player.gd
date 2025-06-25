extends CharacterBody2D

const IDLE_SPEED : float = 0.
const MOVE_SPEED : float =  20.
var facing_left := true
var direction := Vector2.ZERO

enum States {IDLE, WALKING}
var state := States.IDLE

func _ready():
	pass
	
func get_direction():
	return Input.get_vector("left", "right", "up", "down")
	
func _physics_process(delta):
	direction = get_direction()
	
	if direction != Vector2.ZERO:
		state = States.WALKING
	else:
		state = States.IDLE
	
	match state:
		States.IDLE:
			velocity = direction * IDLE_SPEED
		States.WALKING:
			velocity = direction * MOVE_SPEED
	move_and_slide()
