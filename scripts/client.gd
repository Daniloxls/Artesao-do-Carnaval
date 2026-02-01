extends Node2D
class_name Client

var required_color: Color
var required_texture: Texture2D
var required_props: Array[String] = []
var prop_icons_ref: Dictionary = {}

@export_group("Audio")
@export var sfx_success: AudioStream
@export var sfx_timeout: AudioStream

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var mask_icon: Sprite2D = $OrderBubble/MaskIcon
@onready var prop_icon_1: Sprite2D = $OrderBubble/PropIcon1
@onready var prop_icon_2: Sprite2D = $OrderBubble/PropIcon2
@onready var patience_bar: TextureProgressBar = $PatienceBar

@export var color_calm: Color = Color.GREEN
@export var color_angry: Color = Color.RED

var initial_bar_pos: Vector2
var shake_intensity: float = 0.0

var total_time: float = 45.0
var current_time: float = 0.0

signal client_left(success: bool)
var possible_sprites = ["a", "b", "c", "d", "e"]

func setup_order(color: Color, texture: Texture2D, props: Array[String], prop_textures: Dictionary):
	required_color = color
	required_texture = texture
	required_props = props
	prop_icons_ref = prop_textures 

func _ready():
	if animated_sprite_2d:
		var chosen_sprite = possible_sprites.pick_random()
		animated_sprite_2d.play("client_" + chosen_sprite, 0.0)
	if patience_bar:
		patience_bar.max_value = total_time
		patience_bar.value = total_time
		initial_bar_pos = patience_bar.position
	
	update_visuals()

func update_visuals():
	if mask_icon:
		mask_icon.texture = required_texture
		mask_icon.modulate = required_color
	
	if prop_icon_1: prop_icon_1.visible = false
	if prop_icon_2: prop_icon_2.visible = false
	
	if required_props.size() > 0 and prop_icon_1:
		prop_icon_1.visible = true
		prop_icon_1.texture = prop_icons_ref.get(required_props[0])
		
	if required_props.size() > 1 and prop_icon_2:
		prop_icon_2.visible = true
		prop_icon_2.texture = prop_icons_ref.get(required_props[1])

func _process(delta):
	current_time += delta
	if patience_bar:
		var time_left = total_time - current_time
		patience_bar.value = time_left
		var percent = time_left / total_time
		patience_bar.tint_progress = color_angry.lerp(color_calm, percent)
		if percent < 0.3:
			animated_sprite_2d.frame = 3
			shake_intensity = (0.3 - percent) * 10.0 
			apply_shake()
		else:
			shake_intensity = 0.0
			patience_bar.position = initial_bar_pos # Reseta posição
			
	
	if current_time >= total_time:
		leave(false)

func receive_delivery(item: GameItem) -> bool:
	if not item is MaskItem: return false
	var mask = item as MaskItem
	
	if mask.item_color != required_color: return false
	if mask.mask_sprite.texture != required_texture: return false
	

	if mask.current_props.size() != required_props.size(): return false

	for prop in required_props:
		if not mask.current_props.has(prop): return false
			
	leave(true)
	return true

func leave(success: bool):
	var tween = create_tween()
	if success:
		animated_sprite_2d.frame = 2
		if sfx_success:
			AudioManager.play_sfx(sfx_success)
	else:
		if sfx_timeout:
			AudioManager.play_sfx(sfx_timeout)
			
	tween.tween_interval(1.0)
	tween.tween_callback(emit_signal.bind("client_left", success))
	tween.tween_callback(queue_free)
	#emit_signal("client_left", success)
	#queue_free()

func apply_shake():
	var offset = Vector2(
		randf_range(-shake_intensity, shake_intensity),
		randf_range(-shake_intensity, shake_intensity)
	)
	patience_bar.position = initial_bar_pos + offset
