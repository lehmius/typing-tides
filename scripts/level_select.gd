extends Control

@onready var optionsBT = $"ButtonOpt"

func _ready() -> void:
	for button in $ButtonContainer.get_children():
		if button is Button:
			button.pressed.connect(onButtonPressed.bind(button))
			button.mouse_entered.connect(onHover)
	optionsBT.mouse_entered.connect(onHover)
	optionsBT.pressed.connect(openOptions)
	
func openOptions() -> void:
	var options = load("res://scenes/options.tscn")
	var optionsWindow=options.instantiate()
	add_child(optionsWindow)

## Handler for if a button is pressed to set the correct levelID
##
## @returns: void
func onButtonPressed(button: Button) ->void:
	var buttonName = str(button.name)
	var levelIDToSet = int(buttonName.lstrip("Button"))
	SignalBus.loadLevel.emit(levelIDToSet)
	queue_free()

## Handler for when a mouse is hovering over the button
##
## @returns void
func onHover() -> void:
	SignalBus.buttonHover.emit()
