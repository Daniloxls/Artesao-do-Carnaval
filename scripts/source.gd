extends StaticBody2D

class_name SourceTable

@export var item_scene : PackedScene
@export var pick_up_sound : AudioStream

@onready var item_point: Marker2D = $ItemPoint

func _ready() -> void:
	var display_item = item_scene.instantiate()
	add_child(display_item)
	display_item.position = item_point.position

func interact(player : CharacterBody2D):
	if player.held_item == null:
		if item_scene != null:
			var new_item = item_scene.instantiate()
			player.add_child(new_item)
			player.pick_item(new_item)
			AudioManager.play_sfx(pick_up_sound)
			
			
