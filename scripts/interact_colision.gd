extends Area2D

@onready var colision_up: CollisionShape2D = $ColisionUp
@onready var colision_down: CollisionShape2D = $ColisionDown
@onready var colision_left: CollisionShape2D = $ColisionLeft
@onready var colision_right: CollisionShape2D = $ColisionRight

func _ready() -> void:
	colision_down.disabled = true;
	colision_up.disabled = true;
	colision_left.disabled = true;
	colision_right.disabled = true;

func change_direction(direction : String):
	colision_down.disabled = true;
	colision_up.disabled = true;
	colision_left.disabled = true;
	colision_right.disabled = true;
	
	match(direction):
		"up":
			colision_up.disabled = false;
		"down":
			colision_down.disabled = false;
		"left":
			colision_left.disabled = false;
		"right":
			colision_right.disabled = false;
		
