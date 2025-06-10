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
func rotate_using_radians(radius: float) -> void:
	rotation += radius
	velocity = velocity.rotated(radius)
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

## Adds a pixel per second value to the current velocity.
## New velocity is calculated with neutral rotation and then rotated.
##
## @param velocity_increase
func add_velocity(velocity_increase: float) -> void:
	velocity += Vector2(velocity_increase, 0).rotated(rotation)

## Sets the velocity to a pixels per second value. 
## Current rotation of the projectile is considered for travel direction.
##
## @param new_velocity: The new velocity. Positive number represents left to right movement.
##
## @returns: void
func set_velocity(_velocity: float) -> void:
	velocity = Vector2(_velocity, 0).rotated(get_rotation())

## Returns the current velocity in pixels per second.
## 
## @returns: float
func get_velocity() -> float:
	return velocity.rotated(-rotation)[0]
