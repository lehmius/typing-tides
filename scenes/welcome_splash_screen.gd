extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		SignalBus.loadLevel.emit(-2)
		queue_free()
