extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("setSpeed"):
		body.setSpeed(100)

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("setSpeed"):
		body.setSpeed(400)
	
func _on_time_to_dry_timeout() -> void:
	queue_free()
