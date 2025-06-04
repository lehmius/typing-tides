## This script controls the movement of the enemy character.
## The enemy moves towards a target position either defined as "target" (typically the player),
## or can be passed a custom target via the move_enemy_to function.
##
## @export text: The word associated with the enemy.
## @export speed: The speed at which the enemy moves in pixels/second.

extends CharacterBody2D

@export var text:String = "default" #: Value of the word associated with the enemy
@export var speed:int = 500 		#: Enemy speed in pixels/second
var target:Vector2 = Vector2(0,0) 	# Target the enemy is moving towards.

func _ready() -> void:
	pass

# _physics_process is not needed as physics interactions are not expected.
func _process(delta: float) -> void:
	move_enemy()
	

## Moves the enemy across the scene to a custom location in a linear path.
##
## @param custom_target: The target the enemy should move towards
##
## @returns: void
func move_enemy_to(custom_target:Vector2) -> void:
	if position.distance_to(custom_target) > 5: # Only move if enemy is not already on top of target 
		var direction = (custom_target - position).normalized()
		velocity = direction * speed
		move_and_slide() # Automatically handles frame rate independent movement

## Moves the enemy across the scene to the target attribute in a linear path.
##
## @returns: void
func move_enemy() -> void:
	move_enemy_to(target)
