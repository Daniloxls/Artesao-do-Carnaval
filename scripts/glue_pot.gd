extends StaticBody2D

@onready var spawnTimer = $SpawnTimer as Timer
@onready var alert_sfx = $AlertSound as AudioStreamPlayer
@onready var alert_icon = $AlertIcon as Sprite2D
@onready var progressBar = $ProgressBar as TextureProgressBar
@onready var startProgress = $startProgress as Timer

@export var timeToExplode = 5

var puddles = [
	preload("res://scenes/tables/puddles/glue_puddle_01.tscn"),
	preload("res://scenes/tables/puddles/glue_puddle_02.tscn")
]
var progress: float = 0
var isPlayingAlert = false
var isStirring = false
var isCold = false
var activePlayer: CharacterBody2D = null

func _process(delta: float) -> void:
	if isStirring:
		spawnTimer.stop()
		alert_sfx.playing = false
		alert_icon.visible = false
		isPlayingAlert = false
		if progress > 0:
			progress -= (100.0 / timeToExplode) * delta * 2
		else:
			activePlayer.is_locked = false
			isStirring = false
			isCold = true
			activePlayer = null
			startProgress.start()
	elif not isCold:
		if progress < 100:
			progress += (100.0 / timeToExplode) * delta
		else:
			if not isPlayingAlert:
				alert_sfx.playing = true
				alert_icon.visible = true
				spawnTimer.start()
				isPlayingAlert = true
	progressBar.value = progress

func interact(player: CharacterBody2D):
	activePlayer = player
	if (activePlayer.held_item == null):
		if(progress > 0):
			activePlayer.is_locked = true
			isStirring = true
	elif(activePlayer.held_item is MaskItem):
		(activePlayer.held_item as MaskItem).with_glue = true

func _on_spawn_timer_timeout() -> void:
	var choiced = puddles.pick_random()
	var newPuddle = choiced.instantiate()
	var rand_x = randf_range(0.0, 1150.0)
	var rand_y = randf_range(0.0, 640.0)
	newPuddle.position = Vector2(rand_x, rand_y)
	get_parent().add_child(newPuddle)

func _on_start_progress_timeout() -> void:
	isCold = false
