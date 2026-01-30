@export var prop_names: Array[String]
@export var prop_textures: Array[Texture2D]
var prop_icons = {}

func _ready():
	for i in range(prop_names.size()):
		prop_icons[prop_names[i]] = prop_textures[i]
