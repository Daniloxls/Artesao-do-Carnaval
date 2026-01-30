extends CanvasLayer

@onready var label_score: Label = $LabelScore
@onready var label_time: Label = $LabelTime

func _ready() -> void:
	GameManager.score_updated.connect(update_score_text)
	GameManager.time_updated.connect(update_time_text)
	GameManager.game_over.connect(show_game_over)

func update_score_text(new_score: int):
	label_score.text = "Pontos: " + str(new_score)

func update_time_text(seconds: int):
	var mins = seconds / 60
	var secs = seconds % 60
	label_time.text = "%02d:%02d" % [mins, secs]

func show_game_over():
	label_time.text = "ACABOU!"
