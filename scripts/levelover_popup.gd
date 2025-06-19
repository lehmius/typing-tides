extends Control

@onready var restart_button:Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/RestartButton
@onready var menu_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer2/MenuButton
@onready var next_level_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer3/NextLevelButton

func _ready() -> void:
	restart_button.set_levelID_to_current()
	menu_button.set_scene_to_be_loaded(-3)
	next_level_button.set_scene_to_be_loaded(int(GameStateHandler.getCurrentLevel()+1))
