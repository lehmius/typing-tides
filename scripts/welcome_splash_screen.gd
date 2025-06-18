extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		SignalBus.loadLevel.emit(-3)
		queue_free()
