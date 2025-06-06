extends CharacterBody2D

signal shoot(projectile, pressedKey, global_position)

@export var speed:int = 300

var Projectile = preload("res://scenes/projectile.tscn")

func _ready() -> void:
	pass

## Emits the shoot(projectile, pressedKey, global_position) signal on InputEventKey.pressed event.
##
## @param event: InputEvent
## @returns: void
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		shoot.emit(Projectile, event.keycode, global_position)


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.x = speed
	move_and_slide()
