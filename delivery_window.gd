extends StaticBody2D
class_name DeliveryWindow

@onready var client_position: Marker2D = $Marker2D

var current_client: Client = null

func spawn_client(client_scene: Client):
	if current_client != null: return 
	
	current_client = client_scene
	add_child(client_scene)
	client_scene.position = client_position.position
	
	client_scene.client_left.connect(_on_client_left)

func interact(player: CharacterBody2D):
	if current_client != null and player.held_item != null:
		var item = player.held_item
		
		var success = current_client.receive_delivery(item)
		
		if success:
			GameManager.add_score(GameManager.points_per_delivery)
			player.drop_item()
			item.queue_free()
			
			
func _on_client_left(success: bool):
	current_client = null
