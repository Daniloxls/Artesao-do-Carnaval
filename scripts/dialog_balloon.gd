extends MarginContainer

@onready var dialog_label: Label = $DialogLabelMargin/DialogLabel
@onready var delete_timer: Timer = $DeleteTimer

const MAX_WIDTH = 256

func display_text(text_to_display: String):
	dialog_label.text = text_to_display
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		dialog_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	delete_timer.start()

func _on_delete_timer_timeout() -> void:
	queue_free()
