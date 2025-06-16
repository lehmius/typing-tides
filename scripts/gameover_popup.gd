extends Control

@onready var restart_button:Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/RestartButton
@onready var menu_button: Button = $Popup/VBoxContainer/CenterContainer/HBoxContainer/MarginContainer2/MenuButton
@onready var score_label: RichTextLabel = $Popup/VBoxContainer/score

func _ready() -> void:
	restart_button.set_levelID_to_current()
	menu_button.set_scene_to_be_loaded(-2)
	SignalBus.connect("displayPerformance", _on_playerPerformanceMetrics)

## On receiving the player performance metrics this function inserts the stats
## into a table in the score RichTextLabel.
##
## @param playerPerformanceMetrcis: Dictionary containing the player stats
## @returns: void
func _on_playerPerformanceMetrics(playerPerformanceMetrics: Dictionary) -> void:
	score_label.text = """[table=3]
	[cell][b]score[/b][/cell][cell][b]Zeichen/min[/b][/cell][cell][b]Genauigkeit[/b][/cell]
	[/table]"""
