extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.position.x<=get_viewport().get_visible_rect().size.x/2:
			SignalBus.loadLevel.emit(-2)
		else:
			SignalBus.loadLevel.emit(0)
		queue_free()
