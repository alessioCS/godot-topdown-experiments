extends CharacterBody2D

@onready var front_ray: RayCast2D = $front_ray
@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite = $AnimatedSprite2D

const WALK_SPEED := 60
const RUN_SPEED := 100
var input_direction := Vector2.ZERO

var ignore_release := false

## Scene & Node Instancing/Loading
var dialog_box := preload("res://Project 1/dialog_box.tscn")
var active_dialog = null

## State Machine
enum States {IDLE, WALKING, RUN, TALKING}
var state: States = States.IDLE

func _ready():
	camera_2d.make_current()
	call_deferred("limit_camera")

## Gets normalized movement vector
func movement():
	input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction.length() > 0:
		front_ray.rotation = input_direction.angle()
		
## Handles other inputs, such as for dialog
func other_input():
	## OPEN DIALOG
	if state != States.TALKING:
		if Input.is_action_just_pressed("interact") and front_ray.is_colliding() and front_ray.get_collider().is_in_group("npcs"):
			state=States.TALKING
			active_dialog = dialog_box.instantiate()
			add_child(active_dialog)
			ignore_release = true
			sprite.play("idle")
	## CLOSE DIALOG
	if state == States.TALKING and Input.is_action_just_released("interact"):
			if ignore_release:
				ignore_release = false
				return
			state = States.IDLE
			active_dialog.queue_free()
			active_dialog = null

## Changes sprite facing direction w/ left & right press.
func handle_facing():
	if input_direction.x > 0:
		sprite.flip_h = false
	if input_direction.x < 0:
		sprite.flip_h = true

## Camera Limiting Tool
func limit_camera():
	var ground = get_tree().get_nodes_in_group("Ground")[0]
	var map_limit : Rect2i
	map_limit = ground.get_used_rect()
	var tile_size = Vector2i(16, 16)

	camera_2d.limit_left = map_limit.position.x * tile_size.x
	camera_2d.limit_top = map_limit.position.y * tile_size.y
	camera_2d.limit_right = (map_limit.position.x + map_limit.size.x) * tile_size.x
	camera_2d.limit_bottom = (map_limit.position.y + map_limit.size.y) * tile_size.y

## Called every frame
func _physics_process(_delta):
	
	## Talking State Check, prevents movement input until released
	if state == States.TALKING:
		other_input()
		return
	
	movement()
	
	## Change States
	if input_direction != Vector2.ZERO && !Input.is_action_pressed("run"):
		state = States.WALKING
	elif input_direction != Vector2.ZERO && Input.is_action_pressed("run"):
		state = States.RUN
	elif input_direction == Vector2.ZERO:
		state = States.IDLE
	
	
	## State Check // Talking State Done Separately
	match state:
		States.IDLE:
			sprite.play("idle")
			other_input()
			
		States.WALKING:
			sprite.play("walk")
			handle_facing()
			
			velocity = input_direction * WALK_SPEED
			move_and_slide()
			other_input()
			
		States.RUN:
			sprite.play("run")
			handle_facing()
			
			velocity = input_direction * RUN_SPEED
			move_and_slide()
			other_input()
