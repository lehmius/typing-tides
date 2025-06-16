class_name popupPanel

extends Control

@export_multiline var text:String = ""
@onready var rich_text_label:RichTextLabel = $Panel/VBoxContainer/MarginContainer/RichTextLabel
@onready var pause_component:Node = $PauseComponent

func _ready() -> void:
	pause_component.pause()
	set_text(text)

func _on_button_button_down() -> void:
	pause_component.resume()
	queue_free() # Replace with function body.

## Sets the text of the popup panel to the text passed to the function
##
## @param text: Text to be displayed by the popup panel
## @return: void
func set_text(text:String) -> void:
	rich_text_label.clear()
	rich_text_label.append_text(text)
