extends Control

@onready var restart_button:Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/RestartButton
@onready var menu_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer2/MenuButton
@onready var heading: RichTextLabel = $Popup/VBoxContainer/MarginContainer/RichTextLabel

func _ready() -> void:
	if GlobalState.getLevelID() > 0:
		heading.text = "Wie schade... Level %s nicht geschafft" % str(GlobalState.getLevelID())
	else:
		heading.text = "GAME OVER"
	restart_button.set_levelID_to_current()
	menu_button.set_scene_to_be_loaded(-3)
	SignalBus.deleteMenus.connect(deleteSelf)
	restart_button.mouse_entered.connect(hoverSound)
	menu_button.mouse_entered.connect(hoverSound)

func hoverSound() -> void:
	SignalBus.buttonHover.emit()
	
	
## Deletes popup
##
## @returns: void
func deleteSelf() -> void:
	queue_free()
