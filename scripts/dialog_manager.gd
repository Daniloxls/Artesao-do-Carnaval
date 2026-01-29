extends Node

const DIALOG_BALLOON = preload("res://scenes/dialog_balloon.tscn")

func start_message(position: Vector2, message: String):
	var dialog_box = DIALOG_BALLOON.instantiate()
	get_tree().root.add_child(dialog_box)
	dialog_box.global_position = position
	dialog_box.display_text(message)
