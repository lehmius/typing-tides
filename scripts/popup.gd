class_name popupPanel

extends Control

@export_multiline var text:String = ""
@onready var rich_text_label:RichTextLabel = $Panel/VBoxContainer/MarginContainer/RichTextLabel

func _ready() -> void:
	Engine.set_time_scale(0)
	set_text(text)

func _on_button_button_down() -> void:
	Engine.set_time_scale(1.0)
	queue_free() # Replace with function body.

func set_text(text:String):
	rich_text_label.append_text(text)
