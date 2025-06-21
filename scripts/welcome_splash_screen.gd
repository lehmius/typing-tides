extends Control

var alreadyEmitted = false # Prevents double calls before queue_free() is done


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if !alreadyEmitted:
			alreadyEmitted=true
			SignalBus.loadLevel.emit(-3)
			queue_free()
