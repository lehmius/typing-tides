extends Node2D

signal keyPressed(key:InputEventKey)		# A signal that allows for the result of the input handling (conversion to String) to be accessed by all nodes in the project.
signal shoot(Projectile, pressed_key, global_position)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed:int = 300

#var Projectile = preload("res://scenes/projectile.tscn")

func _ready() -> void:
	$Area2D.connect("body_entered",sendGameOver)
	SignalBus.connect("levelOver", _on_level_over)
	animated_sprite.play("swimming")
	pass

## Emits the shoot(projectile, pressedKey, global_position) signal on InputEventKey.pressed event.
##
## @param event: InputEvent
## @returns: void
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var keycode: int
		keycode = event.keycode
		if keycode==4194305:
			GlobalState.isPaused=!GlobalState.isPaused
		if not event.shift_pressed:
			match keycode:
				59:
					keycode = "ü".unicode_at(0)
				96:
					keycode = "ö".unicode_at(0)
				39:
					keycode = "ä".unicode_at(0)
				91:
					keycode = "ß".unicode_at(0)
				_:
					keycode = keycode | 0x20
		else:
			match keycode:
				59:
					keycode = "Ü".unicode_at(0)
				96:
					keycode = "Ö".unicode_at(0)
				39:
					keycode = "Ä".unicode_at(0)
				_:
					pass
		if keycode > 20 and keycode < 40000:
			shoot.emit(Projectile, String.chr(keycode), global_position)
			SignalBus.keyPressed.emit(String.chr(keycode))
			#print(String.chr(keycode),": ",  keycode)



func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	#velocity.x = speed
	#move_and_slide()

func _on_level_over() -> void:
	animated_sprite.play("idle")

func sendGameOver(body:Node2D) -> void:
	animated_sprite.play("idle")
	SignalBus.emit_signal("gameOver")
