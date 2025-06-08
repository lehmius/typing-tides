extends CharacterBody2D

signal shoot(projectile, pressedKey, global_position)
signal keyPressed(key:InputEventKey)

@export var speed:int = 300

#var Projectile = preload("res://scenes/projectile.tscn")

func _ready() -> void:
	pass

## Emits the shoot(projectile, pressedKey, global_position) signal on InputEventKey.pressed event.
##
## @param event: InputEvent
## @returns: void
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
#		shoot.emit(Projectile, event.keycode, global_position)
		keyPressed.emit(event) 			# A signal is used so that input handling is only done in one place, rather than several.
		pass


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	#velocity.x = speed
	#move_and_slide()
