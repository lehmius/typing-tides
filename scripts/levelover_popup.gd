extends Control

@onready var popup: Control = $Popup
@onready var restart_button:Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/RestartButton
@onready var menu_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer2/MenuButton
@onready var next_level_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer3/NextLevelButton

func _ready() -> void:
	popup.close_button.process_mode = 4
	popup.close_button.hide()
	restart_button.set_levelID_to_current()
	menu_button.set_scene_to_be_loaded(-3)
	next_level_button.set_scene_to_be_loaded(int(GameStateHandler.getCurrentLevel()+1))
	restart_button.mouse_entered.connect(hoverSound)
	menu_button.mouse_entered.connect(hoverSound)
	next_level_button.mouse_entered.connect(hoverSound)

func hoverSound() -> void:
	SignalBus.buttonHover.emit()
