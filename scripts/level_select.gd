extends Control

func _ready() -> void:
	for button in $ButtonContainer.get_children():
		if button is Button:
			button.pressed.connect(onButtonPressed.bind(button))
			
## Handler for if a button is pressed to set the correct levelID
##
## @returns: void
func onButtonPressed(button: Button) ->void:
	var buttonName = str(button.name)
	var levelIDToSet = int(buttonName.lstrip("Button"))
	SignalBus.loadLevel.emit(levelIDToSet)
	queue_free()
