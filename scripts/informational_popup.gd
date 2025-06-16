extends Control

@export_multiline var text:String = ""
@onready var rich_text_label:RichTextLabel = $Popup/VBoxContainer/MarginContainer/RichTextLabel

func _ready() -> void:
	set_text(text)

## Sets the text of the popup panel to the text passed to the function
##
## @param text: Text to be displayed by the popup panel
## @return: void
func set_text(text:String) -> void:
	rich_text_label.clear()
	rich_text_label.append_text(text)
