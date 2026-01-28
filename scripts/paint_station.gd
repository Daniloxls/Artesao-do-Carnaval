extends StaticBody2D

class_name PaintStation

@export var paint_color: Color = Color.RED
@export var color_name: String = "Vermelho"
@onready var tinta_sprite: Sprite2D = $TintaSprite

func _ready() -> void:
	tinta_sprite.modulate = paint_color
	
func interact(player: CharacterBody2D):
	if player.held_item != null:
		
		if player.held_item is MaskItem:
			var mask = player.held_item as MaskItem
			if !mask.is_painted:
				
				mask.apply_paint(paint_color, color_name)
				#Som de pincel ou splash
				
			else:
				#Algum feedback visual de mascara já foi pintada
				pass
			
