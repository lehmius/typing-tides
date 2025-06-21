extends Control
class_name InformationalPopup

@export var info: LevelData
@onready var rich_text_label:RichTextLabel = $Popup/MarginContainer/RichTextLabel

func _ready() -> void:
	set_text(info.text)

## Sets the text of the popup panel to the text passed to the function
##
## @param text: Text to be displayed by the popup panel
## @return: void
func set_text(text:String) -> void:
	info.text += " " + text
	rich_text_label.clear()
	rich_text_label.append_text(text)
