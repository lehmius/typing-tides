class_name popupPanel

extends Control

@onready var pause_component:Node = $PauseComponent
@onready var close_button: Button = $Panel/Button
@export var ui_element:Control

func _ready() -> void:
	if not ui_element is popupPanel or not ui_element is InformationalPopup:
		close_button.process_mode = 4
		close_button.hide()
	#pause_component.pause()

func _on_button_button_down() -> void:
	#pause_component.resume()
	ui_element.queue_free() # Replace with function body.
