extends CharacterBody2D

var speed = 0
const WALK_SPEED = 60
const RUN_SPEED = 100

@onready var sprite = $AnimatedSprite2D
var input_direction = Vector2.ZERO

## State Machine
enum States {IDLE, WALKING, RUN}
var state: States = States.IDLE

func _ready():
	position = get_viewport_rect().size / 2

func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	
func handle_facing():
	if Input.is_action_pressed("right"):
		sprite.flip_h = false
	if Input.is_action_pressed("left"):
		sprite.flip_h = true

func _physics_process(delta):
	get_input()
	if input_direction != Vector2.ZERO && !Input.is_action_pressed("run"):
		state = States.WALKING
	elif input_direction != Vector2.ZERO && Input.is_action_pressed("run"):
		state = States.RUN
	elif input_direction == Vector2.ZERO:
		state = States.IDLE
	
	match state:
		States.IDLE:
			sprite.play("idle")
			
		States.WALKING:
			speed = WALK_SPEED
			sprite.play("walk")
			handle_facing()
			
			velocity = input_direction * speed
			move_and_slide()
			
		States.RUN:
			sprite.play("run")
			speed = RUN_SPEED
			handle_facing()
			
			velocity = input_direction * speed
			move_and_slide()
