## This script controls the movement of the enemy character.
## The enemy moves towards a target position either defined as "target" (typically the player),
## or can be passed a custom target via the moveEnemyTo function.
##
## @export text: The word associated with the enemy.
## @export speed: The speed at which the enemy moves in pixels/second.

extends CharacterBody2D

class_name Enemy

@export var text:String = "default" #: Value of the word associated with the enemy
@export var speed:int = 300 		#: Enemy speed in pixels/second

var target:Vector2 = Vector2(0,0) 	# Target the enemy is moving towards.
var bobFrequency: float = 2.0		# Frequency of the bobbing motion
var bobAmplitude: float = 4.0			# Amplitude of the bobbing motion
var direction: Vector2 = Vector2(0,0)# Vector from position to target, updated when any move function is called
@onready var visualSprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var Player					# Holds a reference to the Player.
@onready var errorAnimationPlayer:AnimationPlayer = $AnimationPlayer
var time:float = 0.0 				# Elapsed time since node was instantiated
var timeToKill:float = 0.0			# Elapsed time since the node has been first attacked
const maxBobbingSeverity:float = 2.0# Scales the bobbing motion to reach (at most) this value.
var score:float = 1.0						# Difficulty vector the enemy has assigned to it
var hasBeenDamaged:bool = false				# A simple variable to determine if the enemy has been damaged before
signal enemyDied(enemyInstance:Enemy,score:float,timeToKill:float)

func _ready() -> void:
	updateState()
	setBobbingDynamics()

func _physics_process(delta: float) -> void:
	if not GlobalState.isPaused:
		time+=delta
		timeToKill+=delta
		moveEnemyToPlayer()

## Moves the enemy across the scene to a custom location in a linear path.
##
## @param custom_target: The target the enemy should move towards
##
## @param custom_target: Vector 2 - The target that the enemy should move to.
## @returns: void
func moveEnemyTo(custom_target:Vector2) -> void:
	if not GlobalState.isPaused:
		if position.distance_to(custom_target) > 5: # Only move if enemy is not already on top of target 
			direction = (custom_target - position).normalized()
			velocity = direction * speed
			move_and_slide() # Automatically handles frame rate independent movement
		addBobbing()

## Moves the enemy across the scene to the player in a linear path.
##
## @returns: void
func moveEnemyToPlayer() -> void:
	moveEnemyTo(Player.position)

## Adds visual interest to fish movement by adding a sinoid bobbing motion to the movement.
## Does not affect the CollisionShape2D or Label, only the AnimatedSprite2D.
##
## @returns:void
func addBobbing() -> void:
	visualSprite.position.y = bobAmplitude * sin(time * bobFrequency * TAU) 

## Set the dynamic values of the bobbing motion (bobFrequency, bobAmplitude) relative to text length on startup.
## Includes some random component to prevent two words of same length syncing up perfectly in their movement.
##
## @returns: void
func setBobbingDynamics() -> void:
	var relativeSize:float = clamp(float(text.length())/15,0.1,1) 	# Maps textlength to values of 0.1-1, maxing out at length 15
	var randomizedComponent:float = (randf()-0.5)/4 				# Adds a random amount to the size to give visual interest
	var randomizedSize:float = clamp(relativeSize+randomizedComponent,0.1,0.9) * maxBobbingSeverity
	
	bobFrequency = maxBobbingSeverity -  randomizedSize 	# Larger size = Lower frequency for bobbing (slow movement)
	bobAmplitude = randomizedSize * 10						# Larger size = Higher amplitude for bobbing (big movement)

## Updates the state of the enemy to ensure consistent display properties.
## Should be called on any changes of the state of the enemy instance.
##
## @returns: void
func updateState() -> void:
	$Label.text=text

## Removes the first letter of the text variable from the enemy, simulating a hit.
##
## @returns: void
func takeDamage() -> void:
	text=text.substr(1,text.length())
	if text.length()==0:
		death()
	updateState()

## Handler method for if the enemy runs out of letters, simulating a "death".
## Emits a onHit Signal to notify game_state_handler about the death of the enemy.
##
## @returns: void
func death() -> void:
	SignalBus.onHit.emit(self,score,timeToKill)
	queue_free()

## Attempts to simulate a hit by the player to the enemy. If successfull, results in damage.
## If not, it shakes the enemy to indicate so.
##
## @param letter: String - Letter that is trying to simualte a hit.
## @returns: void
func attemptHit(letter:String) -> void:
	if letter==text.substr(0,1):
		takeDamage()
		if !hasBeenDamaged: hasBeenDamaged=true
	else:
		# If the attempted Hit is not correct, play an error shake, acting upon the Label.
		errorAnimationPlayer.play("ErrorShake(Vertical)")
