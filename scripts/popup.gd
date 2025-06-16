class_name popupPanel

extends Control

@onready var pause_component:Node = $PauseComponent
@export var ui_element:Control

func _ready() -> void:
	pause_component.pause()

func _on_button_button_down() -> void:
	pause_component.resume()
	ui_element.queue_free() # Replace with function body.
