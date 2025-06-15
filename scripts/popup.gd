extends Control

func _ready() -> void:
	Engine.set_time_scale(0)



func _on_button_button_down() -> void:
	Engine.set_time_scale(1.0)
	queue_free() # Replace with function body.
