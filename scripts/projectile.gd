class_name Projectile

extends Area2D

var velocity:Vector2

func _ready() -> void:
	velocity = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	position += velocity * delta

## Projectiles delete themeselves as soon as they leave the screen.
## This is a fallback option should they not be deleted prior to this.
func _on_screen_existed() -> void:
	queue_free()
