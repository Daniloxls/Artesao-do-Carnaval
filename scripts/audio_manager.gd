extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer


var default_pitch: float = 1.0

func _ready() -> void:
	default_pitch = music_player.pitch_scale


func play_music(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return
	
	music_player.stream = stream
	music_player.play()


func play_sfx(stream: AudioStream):
	sfx_player.pitch_scale = randf_range(0.9, 1.1)
	sfx_player.stream = stream
	sfx_player.play()


func stop_music():
	music_player.stop()


func set_music_speed(speed: float):
	var tween = create_tween()
	tween.tween_property(music_player, "pitch_scale", speed, 2.0)
