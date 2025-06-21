extends Control

@onready var popup: Control = $Popup
@onready var restart_button:Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/RestartButton
@onready var menu_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer2/MenuButton

func _ready() -> void:
	popup.close_button.process_mode = 4
	popup.close_button.hide()
	restart_button.set_levelID_to_current()
	menu_button.set_scene_to_be_loaded(-3)
	SignalBus.deleteMenus.connect(deleteSelf)
	
## Deletes popup
##
## @returns: void
func deleteSelf() -> void:
	queue_free()
