extends Control
class_name InformationalPopup

@export var info: LevelData
@onready var rich_text_label:RichTextLabel = $Popup/VBoxContainer/MarginContainer/RichTextLabel
@onready var button: Button = $Popup/VBoxContainer/Button

func _ready() -> void:
	set_text(info.text)
	button.pressed.connect(_on_button_down)


func _on_button_down() -> void:
	GlobalState.setUpaused()
	self.queue_free()

## Sets the text of the popup panel to the text passed to the function
##
## @param text: Text to be displayed by the popup panel
## @return: void
func set_text(text:String) -> void:
	info.text += " " + text
	rich_text_label.clear()
	rich_text_label.append_text(text)

func hoverSound() -> void:
	SignalBus.buttonHover.emit()
