extends Table

class_name CuttingStation

@onready var progress_bar: TextureProgressBar = $ProgressBar

@export var input_item_name : String = "Papelão"
@export var output_scene: PackedScene
@export var cut_duration: float = 3.0

var current_time:float = 0.0
var active_player: CharacterBody2D = null


func _ready() -> void:
	progress_bar.visible = false
	progress_bar.max_value = cut_duration
	progress_bar.value = 0
	

func _process(delta: float) -> void:
	if active_player != null:
		if Input.is_action_pressed("interact"):
			process_cutting(delta)
		else:
			stop_cutting()

func interact(player: CharacterBody2D):
	if held_item == null and player.held_item != null:
		if player.held_item.item_name == input_item_name:
			var item = player.held_item
			player.drop_item()
			recieve_item(item)
	elif held_item != null and player.held_item == null:
		if current_time >= cut_duration:
			player.pick_item(held_item)
			held_item = null
			reset_station()
		else:
			active_player = player
			player.is_locked = true
			player.velocity = Vector2.ZERO

func process_cutting(delta: float):
	current_time += delta
	progress_bar.value = current_time
	var pulse = 1.0 +(sin(Time.get_ticks_msec() * 0.02) * 0.1)
	held_item.scale = Vector2(pulse, 1.0)
	
	if current_time >= cut_duration:
		finish_cutting()
		
func stop_cutting():
	if active_player:
		active_player.is_locked = false
	active_player = null
	if held_item:
		held_item.scale = Vector2(1,1)
		

func recieve_item(item: GameItem):
	held_item = item
	item.reparent(self)
	item.position = item_point.position
	current_time = 0.0
	progress_bar.value = 0
	progress_bar.visible = true
	
func finish_cutting():
	held_item.queue_free()
	var new_mask = output_scene.instantiate()
	add_child(new_mask)
	new_mask.position = item_point.position
	held_item = new_mask
	
func reset_station():
	progress_bar.visible = false
	current_time = 0.0
	active_player = null
	
