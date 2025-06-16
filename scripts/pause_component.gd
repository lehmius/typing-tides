extends Node

## Pauses the game by setting the simulation speed to 0.
## 
## returns: void
func pause() -> void:
	Engine.set_time_scale(0)

## Resumes the game by setting the simulation speed to 1.
##
## returns: void
func resume() -> void: 
	Engine.set_time_scale(1)
