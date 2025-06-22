extends Control

@onready var dbutton = $Popup/deutsch
@onready var ebutton = $Popup/englisch
@onready var difficultySlider = $Popup/HSlider

func _ready() -> void:
	var buttonGroup = ButtonGroup.new()
	dbutton.button_group = buttonGroup
	ebutton.button_group = buttonGroup
	dbutton.button_pressed=true
	dbutton.toggle_mode=true
	ebutton.toggle_mode=true
	difficultySlider.connect("value_changed",newDifficulty)
	dbutton.connect("button_down",dButtonPressed)
	ebutton.connect("button_down",eButtonPressed)


func eButtonPressed() -> void:
	if GlobalState.language == "deutsch":
		GlobalState.language = "english"

func dButtonPressed() -> void:
	if GlobalState.language == "english":
		GlobalState.language = "deutsch"




func newDifficulty(newValue) -> void:
	var value = newValue
	GlobalState.difficulty=value/100
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		queue_free()
