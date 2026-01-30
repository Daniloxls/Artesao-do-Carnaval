extends StaticBody2D

class_name  MultiColorSource

@export var item_scene: PackedScene

@export_group("Cores da Seleção")
@export var color_up: Color = Color.RED
@export var color_down: Color = Color.BLUE
@export var color_left: Color = Color.GREEN
@export var color_right: Color = Color.YELLOW

@export var pick_up_sound : AudioStream

@onready var selector_ui: Node2D = $SelectorUI
@onready var icon_up: Sprite2D = $SelectorUI/IconUp
@onready var icon_down: Sprite2D = $SelectorUI/IconDown
@onready var icon_left: Sprite2D = $SelectorUI/IconLeft
@onready var icon_right: Sprite2D = $SelectorUI/IconRight


var active_player: CharacterBody2D = null
var is_selecting: bool = false


func set_selecting(selecting):
	is_selecting = selecting
	

func _ready() -> void:
	icon_up.modulate = color_up
	icon_down.modulate = color_down
	icon_left.modulate = color_left
	icon_right.modulate = color_right
	
func _process(delta: float) -> void:
	if is_selecting and active_player != null:
		handle_selection_input()

func interact(player: CharacterBody2D):
	
	if player.held_item == null:
		start_selection(player)
	
	elif is_selecting:
		cancel_selection()
		return

func start_selection(player: CharacterBody2D):
	active_player = player
	
	player.is_locked = true
	player.velocity = Vector2.ZERO
	set_selecting(true)
	selector_ui.show()
	selector_ui.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(selector_ui, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_BACK)
	tween.tween_interval(0.2)
	#tween.tween_callback(set_selecting.bind(true))

func handle_selection_input():
	var prefix = "p" + str(active_player.player_id) + "_"
	if Input.is_action_just_pressed(prefix + "up"):
		spawn_item(color_up)
	elif Input.is_action_just_pressed(prefix + "down"):
		spawn_item(color_down)
	elif Input.is_action_just_pressed(prefix + "left"):
		spawn_item(color_left)
	elif Input.is_action_just_pressed(prefix + "right"):
		spawn_item(color_right)
	
	
func spawn_item(chosen_color: Color):
	if item_scene:
		var new_item = item_scene.instantiate()
		active_player.add_child(new_item)
		new_item.modulate = chosen_color
		new_item.item_color = chosen_color
			
		active_player.pick_item(new_item)
		AudioManager.play_sfx(pick_up_sound)
	cancel_selection()
	
func cancel_selection():
	selector_ui.hide()
	is_selecting = false
	
	if active_player:
		active_player.is_locked = false
		active_player = null
