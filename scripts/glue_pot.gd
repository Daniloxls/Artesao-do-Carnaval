extends StaticBody2D

@onready var spawnTimer = $SpawnTimer as Timer
@onready var alert_sfx = $AlertSound as AudioStreamPlayer
@onready var alert_icon = $AlertIcon as Sprite2D
@onready var progressBar = $ProgressBar as TextureProgressBar
@onready var startProgress = $startProgress as Timer

@export var timeToExplode = 30
@export var splash_sound : AudioStream

@export_group("Visuals")
@export var color_safe: Color = Color.GREEN
@export var color_danger: Color = Color.RED
var initial_bar_pos: Vector2
var shake_intensity: float = 0.0

var lines : Array[String] = [
	"Jà passei cola neste!",
	"Cola demais estraga!",
	"Hora de por os apetrechos!",
	"Aqui já tá bom de cola!"
]

var puddles = [
	preload("res://scenes/tables/puddles/glue_puddle_01.tscn"),
	preload("res://scenes/tables/puddles/glue_puddle_02.tscn")
]
var progress: float = 0
var isPlayingAlert = false
var isStirring = false
var isCold = false
var activePlayer: CharacterBody2D = null

func _ready() -> void:
	if progressBar:
		initial_bar_pos = progressBar.position

func _process(delta: float) -> void:
	var interact_action = "ui_accept"
	if activePlayer != null:
		interact_action = "p" + str(activePlayer.player_id) + "_interact"
	
	if activePlayer != null and Input.is_action_pressed(interact_action) and activePlayer.held_item == null:
		if not isCold and progress > 0:
			perform_stir(delta)
		else:
			release_player()
			
	elif activePlayer != null:
		release_player()

	if not isStirring and not isCold:
		increase_pressure(delta)
		
	# --- ATUALIZAÇÃO VISUAL ---
	update_visuals()


func update_visuals():
	if not progressBar: return
	
	progressBar.value = progress
	
	var percent = progress / 100.0
	
	progressBar.tint_progress = color_safe.lerp(color_danger, percent)
	
	if percent > 0.7:
		shake_intensity = (percent - 0.7) * 15.0 
		apply_shake()
	else:
		shake_intensity = 0.0
		progressBar.position = initial_bar_pos


func apply_shake():
	var offset = Vector2(
		randf_range(-shake_intensity, shake_intensity),
		randf_range(-shake_intensity, shake_intensity)
	)
	progressBar.position = initial_bar_pos + offset


func perform_stir(delta: float):
	isStirring = true
	activePlayer.is_locked = true
	activePlayer.velocity = Vector2.ZERO
	
	spawnTimer.stop()
	if isPlayingAlert:
		alert_sfx.playing = false
		alert_icon.visible = false
		isPlayingAlert = false
	
	progress -= (100.0 / timeToExplode) * delta * 2
	
	if progress <= 0:
		progress = 0
		isCold = true
		startProgress.start()
		release_player()


func release_player():
	isStirring = false
	if activePlayer:
		activePlayer.is_locked = false
		activePlayer = null


func increase_pressure(delta: float):
	if progress < 100:
		progress += (100.0 / timeToExplode) * delta
	else:
		if not isPlayingAlert:
			alert_sfx.playing = true
			alert_icon.visible = true
			spawnTimer.start()
			isPlayingAlert = true

func interact(player: CharacterBody2D):
	activePlayer = player
	
	if activePlayer.held_item is MaskItem:
		var mask = activePlayer.held_item as MaskItem
		if not mask.with_glue:
			mask.with_glue = true
			
			activePlayer = null 
		else:
			DialogManager.start_message($DialogSpawner.global_position, lines.pick_random())
			activePlayer = null

func _on_spawn_timer_timeout() -> void:
	var choiced = puddles.pick_random()
	var newPuddle = choiced.instantiate()
	var rand_x = randf_range(-520.0, 520.0)
	var rand_y = randf_range(-123.0, 265.0)
	newPuddle.position = Vector2(rand_x, rand_y)
	newPuddle.z_index = -1
	get_parent().add_child(newPuddle)
	
	if splash_sound:
		AudioManager.play_sfx(splash_sound)

func _on_start_progress_timeout() -> void:
	isCold = false
