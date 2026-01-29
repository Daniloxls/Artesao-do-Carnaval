extends GameItem
class_name  MaskItem

@export var mask_sprite: Sprite2D

var max_props: int = 2
var current_props: Array[String] = []
var with_glue: bool = false

@onready var slot1: Marker2D = $Slot1
@onready var slot2: Marker2D = $Slot2

var is_painted: bool = false

var current_color_name : String = "natural"

func can_add_prop(prop: PropItem) -> bool:
	if current_props.size() >= max_props:
		return false
	if current_props.size() == 1:
		if current_props[0] == prop.prop_type:
			return false
	return true

func add_prop(prop: PropItem):
	current_props.append(prop.prop_type)
	
	prop.reparent(self)
	
	prop.position = slot1.position
	
	

func apply_paint(new_color: Color, color_name: String):
	if is_painted:
		return
		
	is_painted = true
	current_color_name = color_name
	
	if mask_sprite:
		mask_sprite.modulate = new_color
