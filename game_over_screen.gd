extends CanvasLayer

@onready var score_label: Label = $VBoxContainer/ScoreLabel

func _ready() -> void:
	$VBoxContainer/HBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	$VBoxContainer/HBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func set_final_score(score: int):
	score_label.text = "Máscaras Entregues: " + str(score)
	get_tree().paused = true

func _on_restart_pressed():
	get_tree().paused = false
	
	get_tree().reload_current_scene()
	
	GameManager.start_game()
	
	queue_free()

func _on_quit_pressed():
	get_tree().quit()
