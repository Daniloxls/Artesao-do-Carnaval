extends StaticBody2D

class_name Table

@onready var item_point: Marker2D = $ItemPoint
@onready var held_item: Node2D = $Item


#var held_item: GameItem = null


func interact(player: CharacterBody2D):
	var player_item = player.held_item
	if player.held_item != null and held_item != null:
		try_combine_items(player, held_item, player_item)
	
	if player.held_item == null and held_item != null:
		var item_to_give = held_item
		player.pick_item(item_to_give)
		held_item = null
		
	elif player.held_item != null and held_item == null:
		var item_from_player = player.held_item
		player.drop_item()
		
		recieve_item(item_from_player)

func try_combine_items(player, table_item, hand_item):
	if table_item is MaskItem and hand_item is PropItem:
		var mask = table_item
		var prop = hand_item
		
		if mask.can_add_prop(prop):
			player.drop_item()
			mask.add_prop(prop)
			prop.sprite_icon.hide()
			prop.sprite_applied.show()
			
	elif table_item is PropItem and hand_item is MaskItem:
		var prop = table_item
		var mask = hand_item
		
		if mask.can_add_prop(prop):
			held_item = null
			prop.sprite_icon.hide()
			prop.sprite_applied.show()
			mask.add_prop(prop)
			recieve_item(mask)
			player.drop_item()

func recieve_item(item: GameItem):
	held_item = item
	item.reparent(self)
	item.position = item_point.position
