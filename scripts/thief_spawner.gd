extends Node

@export var perna_scene: PackedScene
@export var min_time: float = 10.0
@export var max_time: float = 30.0

@export var spawn_y_min: float = -128.0
@export var spawn_y_max: float = 360.0

@onready var timer: Timer = $Timer

func _ready():
	randomize_timer()
	timer.timeout.connect(spawn_perna)

func randomize_timer():
	timer.wait_time = randf_range(min_time, max_time)
	timer.start()

func spawn_perna():
	if perna_scene == null: return
	
	var perna = perna_scene.instantiate()
	add_child(perna)
	
	var spawn_left = randf() > 0.5
	var spawn_pos = Vector2.ZERO
	var move_right = true
	
	var random_y = randf_range(spawn_y_min, spawn_y_max)
	
	if spawn_left:
		spawn_pos = Vector2(-660, random_y)
		move_right = true
	else:
		spawn_pos = Vector2(700, random_y)
		move_right = false
		
	perna.setup_direction(spawn_pos, move_right)
	
	randomize_timer()
