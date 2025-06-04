extends CharacterBody2D

@export var text:String = "default"; # Value of the word associated with the enemy
@export var speed:int; # Enemy speed in pixels/second

func _ready() -> void:
	pass

# Called every frame. _physics_process is not needed as physics interactions are not expected.
func _process(delta: float) -> void:
	pass
	
