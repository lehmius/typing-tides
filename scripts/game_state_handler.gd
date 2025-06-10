## This script is responsible for the core functionality of the gameplay loop.
## It keeps track of the gamestate, instances enemies and handles failure states.
## This Node/Script should be autoloaded to allow access to it from all nodes, as it is needed in any level of the game.
extends Node

# Constants
const maxConsecutiveErrors:int = 2		# Maximum of consecutive Errors, allowed to be made before changing targeting.

# Variables
var levelID:int=0						# ID for the currently loaded level
var consecutiveErrors:int=0				# Amount of consecutive wrong inputs, used for targeting decay

# The following are reference variables.
var enemyReferences:Array[Enemy] = []	# Holds references to each currently instanced enemy
var player:Node							# Holds the reference to the player
var currentTarget:Node

var playerScene: PackedScene = preload("res://scenes/player.tscn")
var enemyScene: PackedScene = preload("res://scenes/enemy.tscn")

func _ready() -> void:
	instancePlayer()
	SignalBus.connect("keyPressed",receiveKey)
	instanceEnemiesDEBUG(5)

## Instances the Player within the game.
##
## @returns: void
func instancePlayer() -> void:
	player=playerScene.instantiate()
	player.position = Vector2(50,190)
	add_child(player)

## Helper function to get the next enemy for the current Level (based on levelID)
## Until a database is available, this function is a placeholder to generate basic words for testing. 
##
## @returns: A random word from a hardcoded list as a String.
func getNextWord() -> String:
	var wordlist="Katze,Hund,Haus,Apfel,Buch,Tisch,Wasser,Stadt,Fenster,Blume,Regen,Erde,Lächeln,Fahrrad,Mond".to_lower().split(",") # Remove .to_lower() after testing TODO
	var word=wordlist[randi_range(0,wordlist.size()-1)]
	return word

## Instances an enemy scene with a word from the getNextWord function, 
## positions it at a random position just outside the screen and populates variables accordingly.
##
## @returns: void
func instanceEnemy() -> void:
	var nextEnemy = enemyScene.instantiate() 
	nextEnemy.position = Vector2(680,randi_range(15,345))
	nextEnemy.Player = player
	nextEnemy.text = getNextWord()
	SignalBus.connect("onHit",enemyDeathHandler)
	enemyReferences+=[nextEnemy]
	add_child(nextEnemy)
	
## Instances a provided amount of Enemies, to use in debugging and testing.  
##
## @param amount: int - The amount of enemies to spawn.
## @returns: void
func instanceEnemiesDEBUG(amount:int) -> void:
	for i in range(amount):
		instanceEnemy()

## Handles picking enemies as well as enemy targeting decay.
##
## @param letter: String - Letter that is trying to change the targeting
## @returns: void
func updateEnemyTargeting(letter:String) -> void:
	if currentTarget==null: # No current target selected
		currentTarget = getNearestTarget(letter)
		setTarget(currentTarget)
	else:
		if letter!=currentTarget.text.substr(0,1):
			consecutiveErrors+=1
			if consecutiveErrors>maxConsecutiveErrors:
				var newTarget = getNearestTarget(letter)
				setTarget(newTarget)
				consecutiveErrors=0


## Gets the nearest valid enemy target that matches the provided letter.
##
## @param letter: String - Letter that is defining the target.
## @returns: Enemy candidate that matches the provided letter and is the closest to the player.
func getNearestTarget(letter:String) -> Enemy:
	var shortestDistance:float = INF
	var currentCandidate:Enemy
	for enemy in enemyReferences:
		if enemy.text.substr(0,1)==letter:
			var thisDistance=player.position.distance_to(enemy.position)
			if thisDistance<shortestDistance:
				currentCandidate=enemy
				shortestDistance=thisDistance
	return currentCandidate

## Sets the provided Enemy as the current target, colors it to communicate that information with the user.
## Provide null to unset target.
##
## @param target: Enemy - Enemy reference that should be targeted.
## @returns: void
func setTarget(target:Enemy) -> void:
	var highlightColor = Color(1,0,0,1)
	# Reset previous target color before changing or resetting target.
	if currentTarget!=null:
			currentTarget.get_node("Label").set("theme_override_colors/font_color",Color(1,1,1,1))
	if not target==null:
		currentTarget=target
		target.get_node("Label").set("theme_override_colors/font_color",highlightColor)
	else:
		currentTarget=null

## Handler function for inputEvents (after being processed by the input handler in the Player scene). 
## Delegates the event to required other functions.
##
## @param event: InputEventKey - Button was pressed in an InputEvent.
## @returns: void
func receiveKey(event:InputEventKey) -> void:
	var letter = OS.get_keycode_string(event.keycode).to_lower() # Remove once Input handler is implemented and event is replaced with letter
	updateEnemyTargeting(letter)
	if currentTarget!=null:
		currentTarget.attemptHit(letter)

## Handler function for when an enemy died. Used to clear the reference out of the enemyReferences array.
##
## @ param deadEnemy: Enemy
## @returns: void
func enemyDeathHandler(deadEnemy:Enemy) -> void:
	enemyReferences.erase(deadEnemy)
