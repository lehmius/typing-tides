extends CharacterBody2D

@export var SPEED:int = 300

func _physics_process(delta: float) -> void:
	velocity.x = SPEED
	move_and_slide()
