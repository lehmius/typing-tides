extends Node

var isPaused:bool=false
var language="deutsch" # Possible Values: deutsch, english
var levelID:int=-4

func setPaused() -> void:
	isPaused=true
	Engine.set_time_scale(0)

func setUpaused() -> void:
	isPaused=false
	Engine.set_time_scale(1)
