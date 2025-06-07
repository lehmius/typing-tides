extends Area2D

@export var speed = Vector2.RIGHT

func _physics_process(delta: float) -> void:
    position += speed * delta