extends Area2D

@export var speed: float = 300.0
@export var steal_sound: AudioStream
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.RIGHT

func _ready():
	body_entered.connect(_on_body_entered)
	
	animated_sprite_2d.play("default")

func _process(delta: float):
	position += direction * speed * delta
	
	if position.x < -700 or position.x > 900:
		queue_free()

func setup_direction(start_pos: Vector2, move_right: bool):
	position = start_pos
	if move_right:
		direction = Vector2.RIGHT
		animated_sprite_2d.flip_h = true 
	else:
		direction = Vector2.LEFT
		animated_sprite_2d.flip_h = false 

func _on_body_entered(body: Node2D):
	if body is Table:
		try_steal(body)

func try_steal(table: Table):
	if table.held_item != null:
		
		table.held_item.queue_free()
		table.held_item = null
		
		if steal_sound:
			AudioManager.play_sfx(steal_sound)
			
