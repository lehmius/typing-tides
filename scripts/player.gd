extends CharacterBody2D

const SPEED = 300

func _physics_process(delta: float) -> void:
	velocity.x = SPEED
	move_and_slide()
