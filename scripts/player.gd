extends CharacterBody2D

signal shoot(Projectile, pressed_key, global_position)

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
		var keycode: int
		keycode = event.keycode
		if not event.shift_pressed:
			keycode = keycode | 0x20
		#shoot.emit(Projectile, String.chr(keycode), global_position)
		print(OS.get_keycode_string(keycode))
		


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.x = speed
	move_and_slide()
