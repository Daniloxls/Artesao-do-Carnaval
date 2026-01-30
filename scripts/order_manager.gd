extends Node

@export var client_scene: PackedScene
@export var windows: Array[DeliveryWindow]


@export_group("Possibilidades")
@export var available_colors: Array[Color] = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]
@export var available_models: Array[Texture2D]
@export var available_props: Array[String] = ["Chifre", "Fita", "Glitter"]

@export_group("Ícones dos Adereços")
@export var prop_names: Array[String]
@export var prop_textures: Array[Texture2D]

var prop_icons: Dictionary = {}

@onready var spawn_timer: Timer = $SpawnTimer

func _ready():
	spawn_timer.timeout.connect(spawn_random_order)
	setup_prop_dictionary()
	
func setup_prop_dictionary():
	if prop_names.size() != prop_textures.size():
		printerr("ERRO NO ORDER MANAGER: A lista de Nomes e Texturas tem tamanhos diferentes!")
		return

	for i in range(prop_names.size()):
		var p_name = prop_names[i]
		var p_texture = prop_textures[i]
		prop_icons[p_name] = p_texture

func spawn_random_order():
	# 1. Acha uma janela vazia
	var free_windows = []
	for w in windows:
		if w.current_client == null:
			free_windows.append(w)
	
	if free_windows.size() == 0:
		return
		
	var target_window = free_windows.pick_random()

	var color = available_colors.pick_random()
	var model = available_models.pick_random()
	
	
	var props_count = randi() % 3
	var props: Array[String] = []
	

	var props_pool = available_props.duplicate()
	for i in range(props_count):
		if props_pool.size() > 0:
			var p = props_pool.pick_random()
			props.append(p)
			props_pool.erase(p)
			
	var new_client = client_scene.instantiate()
	new_client.setup_order(color, model, props, prop_icons)
	
	target_window.spawn_client(new_client)
