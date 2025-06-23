extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var camera_2d: Camera2D = $Camera2D

func _ready():
	camera_2d.make_current()
	call_deferred("limit_camera")
	pass

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
	camera_2d.global_position = player.global_position
