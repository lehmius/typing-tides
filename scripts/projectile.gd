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

## Changes the rotation of the projectile using radians. 
## Rotating also adjusts the direction in which the projectile travels.
##
## @param radians: The new rotation in radians
##
## @returns: void
func rotate_using_radians(radians: float) -> void:
	rotation += radians
	velocity = velocity.rotated(radians)
	print(velocity)

## Changes the rotation of the projectile using degrees. 
## Rotating also adjusts the direction in which the projectile travels.
##
## @param degree: The new rotation in degrees
##
## @returns: void
func rotate_using_degrees(degree: float) -> void:
	rotate_using_radians(deg_to_rad(degree))


## Resets the visual and movement rotation to neutral.
## For the movement rotation this means left to right movement.
##
## @returns: void
func reset_rotation() -> void:
	velocity = velocity.rotated(-rotation)
	rotation = 0
