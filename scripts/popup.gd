class_name popupPanel

extends Control

@onready var close_button: Button = $Panel/Button
@export var ui_element:Control

func _on_button_button_down() -> void:
	ui_element.queue_free()
