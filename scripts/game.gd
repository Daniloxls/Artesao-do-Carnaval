extends Node2D

@export var game_over_scene: PackedScene

func _ready() -> void:
	GameManager.game_over.connect(_on_game_over)
	GameManager.start_game()

func _on_game_over():
	var screen = game_over_scene.instantiate()
	add_child(screen)
	screen.set_final_score(GameManager.score)
