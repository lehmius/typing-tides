extends Control

var popup_scene: PackedScene = preload("res://scenes/informational_popup.tscn")
var popup_data: LevelData = preload("res://data/level_data/0-1_informational_text.tres")
var popup: Control 

func _ready() -> void:
	if not GlobalState.getSeenModeSelectPopup():
		GlobalState.flipSeenModeSelectPopup()
		popup = popup_scene.instantiate()
		popup.info = popup_data
		add_child(popup)

func _input(event: InputEvent) -> void:
	if popup == null and event is InputEventMouseButton and event.is_pressed():
		if event.position.x<=get_viewport().get_visible_rect().size.x/2:
			SignalBus.loadLevel.emit(-2)
		else:
			SignalBus.loadLevel.emit(0)
		queue_free()
