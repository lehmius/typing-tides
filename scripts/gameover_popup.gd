extends Control

@onready var restart_button:Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/RestartButton
@onready var menu_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer2/MenuButton

func _ready() -> void:
	restart_button.set_levelID_to_current()
	menu_button.set_scene_to_be_loaded(-2)
