extends CharacterBody2D

var speed = 0
const WALK_SPEED = 60
const RUN_SPEED = 100

@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite = $AnimatedSprite2D
var input_direction = Vector2.ZERO

## State Machine
enum States {IDLE, WALKING, RUN}
var state: States = States.IDLE

func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	
func handle_facing():
	if Input.is_action_pressed("right"):
		sprite.flip_h = false
	if Input.is_action_pressed("left"):
		sprite.flip_h = true

func _ready():
	camera_2d.make_current()
	call_deferred("limit_camera")

func limit_camera():
	var ground = get_tree().get_nodes_in_group("Ground")[0]
	var map_limit : Rect2i
	map_limit = ground.get_used_rect()
	var tile_size = Vector2i(16, 16)

	camera_2d.limit_left = map_limit.position.x * tile_size.x
	camera_2d.limit_top = map_limit.position.y * tile_size.y
	camera_2d.limit_right = (map_limit.position.x + map_limit.size.x) * tile_size.x
	camera_2d.limit_bottom = (map_limit.position.y + map_limit.size.y) * tile_size.y

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
