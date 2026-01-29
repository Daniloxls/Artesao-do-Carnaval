extends GameItem
class_name  MaskItem

@export var mask_sprite: Sprite2D

var max_props: int = 2
var current_props: Array[String] = []

@onready var slot1: Marker2D = $Slot1
@onready var slot2: Marker2D = $Slot2


var current_color : Color = Color.WHITE
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
	
	
func setup_mask(base_color: Color, new_texture: Texture2D):
	current_color = base_color
	item_color = base_color
	if mask_sprite:
		mask_sprite.modulate = base_color
		if new_texture:
			mask_sprite.texture = new_texture
	else:
		modulate = base_color
