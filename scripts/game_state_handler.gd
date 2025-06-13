## This script is responsible for the core functionality of the gameplay loop.
## It keeps track of the gamestate, instances enemies and handles failure states.
## This Node/Script should be autoloaded to allow access to it from all nodes, as it is needed in any level of the game.
extends Node

# Constants
const maxConsecutiveErrors:int = 2		# Maximum of consecutive Errors, allowed to be made before changing targeting.

# Variables
var levelID:int=0						# ID for the currently loaded level
var consecutiveErrors:int=0				# Amount of consecutive wrong inputs, used for targeting decay
# Player performance metrics
var totalLettersTyped:int=0				# The total amount of letters typed
var totalMistakesMade:int=0				# The total amount of invalid letters typed
var highestConsecutiveStreak:int=0		# The highest consecutive amount of valid letters typed
var currentConsecutiveStreak:int=0		# The current amount of consecutive valid letters typed
#var comboMeter:float=0.0				# The curent comboMeter, influencing how score gets measured (Currently not implemented)
var wordsTyped:int=0					# How many words (=enemies) have been typed
var score:int=0							# The total score for the level
var wordMistakes:int=0					# Tracking per word mistakes
var wordCorrectLetters:int=0			# Tracking per word correct letters
var time:float=0.0						# Time since starting the level
var isPaused:bool=false					# Tracks if the game is paused right now


# The following are reference variables.
var enemyReferences:Array[Enemy] = []	# Holds references to each currently instanced enemy
var player:Node							# Holds the reference to the player
var currentTarget:Node

var playerScene: PackedScene = preload("res://scenes/player.tscn")
var enemyScene: PackedScene = preload("res://scenes/enemy.tscn")

enum inputType{VALID,INVALID}

func _ready() -> void:
	instancePlayer()
	SignalBus.connect("keyPressed",receiveKey)
	SignalBus.connect("gameOver",gameOverTriggered)
	instanceEnemiesDEBUG(5)

func _physics_process(delta: float) -> void:
	if not isPaused:
		time+=delta

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
func getNextWordDEBUG() -> String:
	var wordlist="Katze,Hund,Haus,Apfel,Buch,Tisch,Wasser,Stadt,Fenster,Blume,Regen,Erde,Lächeln,Fahrrad,Mond".to_lower().split(",") # Remove .to_lower() after testing TODO
	var word=wordlist[randi_range(0,wordlist.size()-1)]
	return word

## Instances an enemy scene with a word from the getNextWordDEBUG function, 
## positions it at a random position just outside the screen and populates variables accordingly.
##
## @returns: void
func instanceEnemy() -> void:
	var nextEnemy = enemyScene.instantiate() 
	nextEnemy.position = Vector2(680,randi_range(15,345))
	nextEnemy.Player = player
	nextEnemy.text = getNextWordDEBUG()
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

## Handles picking enemies. If no enemy is chosen, tries to assign a new one.
## If the amount of errors is higher than maxConsecutiveErrors an attempt is made to switch targets too.
##
## @param letter: String - Letter that is trying to change the targeting
## @returns: void
func updateEnemyTargeting(letter:String) -> void:
	if currentTarget==null: # No current target selected
		currentTarget = getNearestTarget(letter)
		if currentTarget!=null:	setTarget(currentTarget)
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
	if (currentTarget!=null) or (target==null):
			currentTarget.get_node("Label").set("theme_override_colors/font_color",Color(1,1,1,1))
			currentTarget.set("z_index",0)
	if target!=null:
		currentTarget=target
		target.set("z_index",500)
		target.get_node("Label").set("theme_override_colors/font_color",highlightColor)
	else:
		currentTarget=null

## Handler function for inputEvents (after being processed by the input handler in the Player scene). 
## Delegates the letter of the event to required other functions.
##
## @param letter: String - Button was pressed in an InputEvent.
## @returns: void
func receiveKey(letter:String) -> void:
	if not GlobalState.isPaused:
		updateEnemyTargeting(letter)
		if currentTarget!=null:
			if currentTarget.text.substr(0,1)==letter:
				updatePerformanceMetrics(inputType.VALID)
			else:
				updatePerformanceMetrics(inputType.INVALID)
			currentTarget.attemptHit(letter)
		else: # Gets reached when the player tried to target something but no valid target was found.
			updatePerformanceMetrics(inputType.INVALID)
		#displayPerformanceMetricsDEBUG()

## Handler function for when an enemy died. Used to clear the reference out of the enemyReferences array.
##
## @param deadEnemy: Enemy - The enemy that has died
## @param score: Float - The score associated to that enemy
## @returns: void
func enemyDeathHandler(deadEnemy:Enemy,difficultyScore:float) -> void:
	score+=currentConsecutiveStreak*difficultyScore
	enemyReferences.erase(deadEnemy)
	wordCorrectLetters=0
	wordMistakes=0
	wordsTyped+=1

## Resets all perfomance metrics to their initialization values.
##
## @returns:void
func resetPerformanceMetrics() -> void:
	totalLettersTyped=0
	totalMistakesMade=0
	highestConsecutiveStreak=0
	currentConsecutiveStreak=0
	wordsTyped=0

## Keep track of the performance metric variables.
##
## @param input: inputType - specify if the input made is a valid or invalid input.
## @returns: void
func updatePerformanceMetrics(input:inputType) -> void:
	totalLettersTyped+=1
	if input==inputType.VALID:
		wordCorrectLetters+=1
		currentConsecutiveStreak+=1
		if currentConsecutiveStreak>highestConsecutiveStreak:
			highestConsecutiveStreak=currentConsecutiveStreak
	elif input==inputType.INVALID:
		wordMistakes+=1
		totalMistakesMade+=1
		currentConsecutiveStreak=0

## Function to display the performance metrics for debugging 
##
## @returns: void
func displayPerformanceMetricsDEBUG() -> void:
	print("===Performance metrics:===")
	print("Total letters typed: ",totalLettersTyped)
	print("Total mistakes made: ",totalMistakesMade)
	print("Current consecutive streak: ",currentConsecutiveStreak)
	print("Highest consecutive streak: ",highestConsecutiveStreak)

## Calculate the accuracy of this word
##
## @returns: float - The accuracy of the word as a value between 0 and 1
func getWordAccuracy() -> float:
	return wordCorrectLetters/(wordCorrectLetters+wordMistakes)

## Calculate total accuracy of the player in the level
##
## @returns: float - The total accuracy
func getTotalAccuracy() -> float:
	if not totalLettersTyped==0: return (totalLettersTyped-totalMistakesMade)/totalLettersTyped
	else: return -1

## Calculate the characters per minute typed
##
## @returns: float - Characters per minute (including wrong ones)
func getCharactersPerMinute() -> float:
	if not time==0: return totalLettersTyped/(time/60)
	else: return -1

## Helper function to trigger when the level is over as the player has been hit. 
## TODO: Implement endscreen and switch to main menu
##
## @returns: void
func gameOverTriggered() -> void:
	print("GAME OVER")
