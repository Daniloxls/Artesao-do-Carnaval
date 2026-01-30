extends Table

class_name CuttingStation

@onready var selector_ui: Node2D = $SelectorUI
@onready var icon_up: Sprite2D = $SelectorUI/IconUp
@onready var icon_down: Sprite2D = $SelectorUI/IconDown
@onready var icon_left: Sprite2D = $SelectorUI/IconLeft
@onready var icon_right: Sprite2D = $SelectorUI/IconRight

@onready var sequence_ui: Node2D = $SequenceUI
@onready var arrow_sprites: Array[Sprite2D] = [
	$SequenceUI/Arrow1,
	$SequenceUI/Arrow2,
	$SequenceUI/Arrow3,
	$SequenceUI/Arrow4
]

@export var arrow_texture: Texture2D

@export_group("Modelos de Máscara")
@export var texture_up: Texture2D
@export var texture_down: Texture2D
@export var texture_left: Texture2D
@export var texture_right: Texture2D
@export var sfx_cut_success: AudioStream

@export var input_item_name : String = "Papelão"
@export var output_scene: PackedScene
@export var cut_duration: float = 3.0

var sequences = {
	"up":    ["up", "up", "down", "down"],
	"down":  ["left", "right", "left", "right"],
	"left":  ["left", "up", "right", "down"],
	"right": ["right", "down", "left", "up"]
}

var active_player: CharacterBody2D = null
var is_selecting: bool = false
var is_cutting: bool = false

var selected_texture: Texture2D = null
var current_sequence: Array = []
var sequence_step: int = 0

func set_selecting(selecting):
	is_selecting = selecting

func _ready() -> void:
	selector_ui.visible = false
	sequence_ui.visible = false
	
	
	if texture_up: icon_up.texture = texture_up
	if texture_down: icon_down.texture = texture_down
	if texture_left: icon_left.texture = texture_left
	if texture_right: icon_right.texture = texture_right
	

func _process(delta: float) -> void:
	if active_player == null:
		return
		
	if is_selecting:
		handle_selection_input()
	
	elif is_cutting:
		handle_cutting_input()


func interact(player: CharacterBody2D):
	if held_item == null and player.held_item != null:
		if player.held_item.item_name == input_item_name:
			var item = player.held_item
			player.drop_item()
			recieve_item(item)
			
			
	elif held_item != null and player.held_item == null:
		
		if held_item is MaskItem:
			player.pick_item(held_item)
			held_item = null
			reset_station()
			return
		
		if !is_selecting and !is_cutting:
			start_selection(player)
		elif is_selecting:
			cancel_all()
			
			
			
func start_selection(player):
	active_player = player
	player.is_locked = true
	player.velocity = Vector2.ZERO
	
	selector_ui.visible = true
	set_selecting(true)
	selector_ui.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(selector_ui, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_BACK)
	tween.tween_interval(0.2)
	#tween.tween_callback(set_selecting.bind(true))

func handle_selection_input():
	var prefix = "p" + str(active_player.player_id) + "_"
	
	if Input.is_action_just_pressed(prefix + "up"): 
		confirm_selection(texture_up, "up")
	elif Input.is_action_just_pressed(prefix + "down"): 
		confirm_selection(texture_down, "down")
	elif Input.is_action_just_pressed(prefix + "left"): 
		confirm_selection(texture_left, "left")
	elif Input.is_action_just_pressed(prefix + "right"): 
		confirm_selection(texture_right, "right")


func confirm_selection(texture: Texture2D, direction_key: String):
	if texture == null: return
	selected_texture = texture
	selector_ui.visible = false
	is_selecting = false
	start_cutting_sequence(direction_key)
	

func start_cutting_sequence(type_key: String):
	is_cutting = true
	sequence_step = 0
	
	current_sequence = sequences[type_key]
	
	update_sequence_ui()
	sequence_ui.show()
	
	sequence_ui.scale = Vector2(0.5, 0.5)
	var tween = create_tween()
	tween.tween_property(sequence_ui, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_BOUNCE)


func handle_cutting_input():
	var prefix = "p" + str(active_player.player_id) + "_"
	
	if Input.is_action_just_pressed(prefix + "up"):    check_input("up")
	elif Input.is_action_just_pressed(prefix + "down"):  check_input("down")
	elif Input.is_action_just_pressed(prefix + "left"):  check_input("left")
	elif Input.is_action_just_pressed(prefix + "right"): check_input("right")
	
	elif Input.is_action_just_pressed(prefix + "interact"): cancel_all()
	

func check_input(key_pressed: String):
	var expected_key = current_sequence[sequence_step]
	
	if key_pressed == expected_key:
		sequence_step += 1
		highlight_arrow(sequence_step - 1, true)
		AudioManager.play_sfx(sfx_cut_success)
		
		if sequence_step >= current_sequence.size():
			finish_cutting()
			
	else:
		sequence_step = 0
		update_sequence_ui()
		shake_ui()
		
		
func update_sequence_ui():
	for i in range(4):
		var arrow = arrow_sprites[i]
		var direction = current_sequence[i]
		
		arrow.texture = arrow_texture
		arrow.modulate = Color.WHITE
		
		match direction:
			"up": arrow.rotation_degrees = 0
			"down": arrow.rotation_degrees = 180
			"left": arrow.rotation_degrees = 270
			"right": arrow.rotation_degrees = 90
			

func highlight_arrow(index: int, is_correct: bool):
	if index < arrow_sprites.size():
		var color = Color.GREEN if is_correct else Color.RED
		arrow_sprites[index].modulate = color
		
		var tween = create_tween()
		tween.tween_property(arrow_sprites[index], "scale", Vector2(1.2, 1.2), 0.1)
		tween.tween_property(arrow_sprites[index], "scale", Vector2(1.0, 1.0), 0.1)
		
func shake_ui():
	var tween = create_tween()
	for i in range(5):
		var offset = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		tween.tween_property(sequence_ui, "position", sequence_ui.position + offset, 0.05)
	tween.tween_property(sequence_ui, "position", Vector2(70, -100), 0.05)
	
func cancel_all():
	is_selecting = false
	is_cutting = false
	
	selector_ui.hide()
	sequence_ui.hide()
	
	if active_player:
		active_player.is_locked = false
		active_player = null
		
func recieve_item(item: GameItem):
	held_item = item
	item.reparent(self)
	item.position = item_point.position
	
	cancel_all()
	
func finish_cutting():
	var material_color = held_item.item_color
	held_item.queue_free()
	
	var new_mask = output_scene.instantiate()
	add_child(new_mask)
	
	if new_mask.has_method("setup_mask"):
		new_mask.setup_mask(material_color, selected_texture)
	
	new_mask.position = item_point.position
	held_item = new_mask
	
	cancel_all()
	
	
func reset_station():
	cancel_all()
	
