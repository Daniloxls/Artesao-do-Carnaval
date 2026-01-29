extends CharacterBody2D

@onready var interact_colision: Area2D = $InteractColision
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var hand_marker: Marker2D = $HandMarker


var speed = 400
var held_item: GameItem = null
var is_locked: bool = false

func _physics_process(delta):
	if is_locked:
		return
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	update_animation(direction)
	move_and_slide()

func _process(delta: float) -> void:
	handle_input()
	
func handle_input():
	if Input.is_action_just_pressed("interact"):
		try_interact()
		
func try_interact():
	var areas = interact_colision.get_overlapping_bodies()
	
	for body in areas:
		if body.has_method("interact"):
			body.interact(self)
		
func pick_item(item: GameItem):
	held_item = item
	item.reparent(self)
	item.position = hand_marker.position
	
func drop_item():
	held_item = null
	

func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		player_sprite.stop()
		return
	update_interaction_direction(direction)
	if direction.x > 0 and direction.y < 0:
		player_sprite.play("walk_r_up")
	elif direction.x > 0 and direction.y > 0:
		player_sprite.play("walk_r_down")
	elif direction.x < 0 and direction.y < 0:
		player_sprite.play("walk_l_up")
	elif direction.x < 0 and direction.y > 0:
		player_sprite.play("walk_l_down")
		
	elif direction.y < 0:
		player_sprite.play("walk_up")
	elif direction.y > 0:
		player_sprite.play("walk_down")
	elif direction.x > 0:
		player_sprite.play("walk_right")
	elif direction.x < 0:
		player_sprite.play("walk_left")
		
func update_interaction_direction(dir: Vector2):
	if dir.y > 0: interact_colision.change_direction("down")
	elif dir.y < 0: interact_colision.change_direction("up")
	elif dir.x > 0: interact_colision.change_direction("right")
	elif dir.x < 0: interact_colision.change_direction("left")

func setSpeed(value: int):
	speed = value
