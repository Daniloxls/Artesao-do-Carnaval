extends Node

signal score_updated(new_score: int)
signal time_updated(time_left: int)
signal game_over

var game_duration: float = 180.0
var points_per_delivery: int = 1


var score: int = 0
var time_left: float = 0.0
var is_playing: bool = false



func _process(delta: float) -> void:
	if is_playing:
		time_left -= delta
		
		time_updated.emit(int(time_left))
		
		if time_left <= 30.0 and AudioManager.music_player.pitch_scale == 1.0:
			AudioManager.set_music_speed(1.2) # Acelera 20%
		
		if time_left <= 0:
			end_game()

func start_game():
	score = 0
	time_left = game_duration
	is_playing = true
	AudioManager.set_music_speed(1.0)
	score_updated.emit(score)
	time_updated.emit(int(time_left))

func add_score(amount: int):
	if not is_playing: return
	
	score += amount
	score_updated.emit(score)

func remove_score(amount: int):
	if not is_playing: return
	
	score = max(0, score - amount)
	score_updated.emit(score)

func end_game():
	is_playing = false
	time_left = 0
	game_over.emit()
	
	
	# get_tree().paused = true
