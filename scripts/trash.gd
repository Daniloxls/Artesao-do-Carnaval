extends StaticBody2D

class_name  TrashTable

func interact(player: CharacterBody2D):
	if player.held_item != null:
		var item_to_destroy = player.held_item
		
		player.drop_item()
		
		item_to_destroy.queue_free()
		
		
