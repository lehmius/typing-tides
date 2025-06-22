extends Control

@onready var restart_button:Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/RestartButton
@onready var menu_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer2/MenuButton
@onready var next_level_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer3/NextLevelButton
@onready var heading: RichTextLabel = $Popup/VBoxContainer/MarginContainer/RichTextLabel

func _ready() -> void:
	if GlobalState.getLevelID() > 0:
		heading.text = "Juhu! Level %s geschafft" % str(GlobalState.getLevelID())
	heading.text = heading.text.format(GlobalState.getLevelID())
	restart_button.set_levelID_to_current()
	menu_button.set_scene_to_be_loaded(-3)
	next_level_button.set_scene_to_be_loaded(int(GameStateHandler.getCurrentLevel()+1))
	restart_button.mouse_entered.connect(hoverSound)
	menu_button.mouse_entered.connect(hoverSound)
	next_level_button.mouse_entered.connect(hoverSound)

func hoverSound() -> void:
	SignalBus.buttonHover.emit()
