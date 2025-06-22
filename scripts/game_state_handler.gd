## This script is responsible for the core functionality of the gameplay loop.
## It keeps track of the gamestate, instances enemies and handles failure states.
## This Node/Script should be autoloaded to allow access to it from all nodes, as it is needed in any level of the game.
extends Node

# Constants
const maxConsecutiveErrors:int = 2		# Maximum of consecutive Errors, allowed to be made before changing targeting.

# Variables
var consecutiveErrors:int=0				# Amount of consecutive wrong inputs, used for targeting decay
# Player performance metrics
var totalLettersTyped:int=0				# The total amount of letters typed
var totalMistakesMade:int=0				# The total amount of invalid letters typed
var highestConsecutiveStreak:int=0		# The highest consecutive amount of valid letters typed
var currentConsecutiveStreak:int=0		# The current amount of consecutive valid letters typed
#var comboMeter:float=0.0				# The curent comboMeter, influencing how score gets measured (Currently not implemented)
var wordsTyped:int=0					# How many words (=enemies) have been typed
# Score has been refactored into a global variable to make enemies access it easier
#var score:int=0							# The total score for the level
var wordMistakes:int=0					# Tracking per word mistakes
var wordCorrectLetters:int=0			# Tracking per word correct letters
var time:float=0.0						# Time since starting the level
var enemySpawnTimerDuration:float = 3	# Time for the enemy Spawn timer, dynamically changes based on player performance
var lastTTK:float=enemySpawnTimerDuration# Time to kill the last enemy, can't be given in method as it's also connected to a signal and connection fails with more arguments
var endscreenExists:bool=false			# Variable that prevents double popups from appearing (which can happen very rarely if win and lose condition are triggered on the same frame.

# The following are reference variables.
var enemyReferences:Array[Enemy] = []	# Holds references to each currently instanced enemy
var player:Node							# Holds the reference to the player
var currentTarget:Node
var enemySpawnTimer:Timer
var enemiesToSpawn:Variant
var backgroundNode:Node

var playerScene: PackedScene = preload("res://scenes/player.tscn")
var enemyScene: PackedScene = preload("res://scenes/enemy.tscn")
var gameover_popup: PackedScene = preload("res://scenes/gameover_popup.tscn")
var levelover_popup: PackedScene = preload("res://scenes/levelover_popup.tscn")
var informational_popup: PackedScene = preload("res://scenes/informational_popup.tscn")

enum inputType{VALID,INVALID}

func _ready() -> void:
	# Signal related
	SignalBus.connect("keyPressed",receiveKey)
	SignalBus.connect("gameOver",gameOverTriggered)
	SignalBus.connect("onHit",enemyDeathHandler)
	SignalBus.connect("loadLevel",loadLevel)
	
	# Create the central timer
	enemySpawnTimer=Timer.new()
	add_child(enemySpawnTimer)
	enemySpawnTimer.connect("timeout",spawnNextEnemy)
	
	# Create Player and turn him invisible
	instancePlayer()
	player.visible=false
	
	
	# Load start level. THIS MUST BE DONE AFTER CREATING TIMER
	loadLevel(-4)


func _physics_process(delta: float) -> void:
	if not GlobalState.isPaused:
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
func instanceEnemy(enemyData:Dictionary) -> void:
	var nextEnemy = enemyScene.instantiate() 
	if GlobalState.levelID==1:
		nextEnemy.position= Vector2(randi_range(320,640),380)
	else:
		nextEnemy.position = Vector2(680,randi_range(15,345))
	nextEnemy.Player = player
	nextEnemy.text = enemyData["word"]
	nextEnemy.score=enemyData["difficulty"]
	enemyReferences+=[nextEnemy]
	var sprite:AnimatedSprite2D=nextEnemy.get_node("AnimatedSprite2D")
	sprite.play(getEnemyAnimations(GlobalState.levelID,sprite))
	add_child(nextEnemy)

## Returns a valid/possible enemy animation for the levelID as a string (animation name)
##
## @returns: String - Animation name of a valid animation
func getEnemyAnimations(levelID:int,enemySprite:AnimatedSprite2D) -> String:
	var candidates:Array[String] = []
	var animationData:PackedStringArray=[]
	animationData = enemySprite.sprite_frames.get_animation_names()
	if levelID==0:
		return animationData[randi_range(0,animationData.size()-1)]
	for entry in animationData:
		var data = entry.split("-")
		if data.size()==3:
			if levelID==int(data[0]) or levelID==int(data[1]):
				candidates+=[entry]
		elif data.size()==2:
			if levelID==int(data[0]):
				candidates+=[entry]
	return candidates[randi_range(0,candidates.size()-1)]

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
func enemyDeathHandler(deadEnemy:Enemy,difficultyScore:float,timeToKill:float) -> void:
	GlobalState.currentScore+=currentConsecutiveStreak*difficultyScore
	enemyReferences.erase(deadEnemy)
	wordCorrectLetters=0
	wordMistakes=0
	wordsTyped+=1
	lastTTK=timeToKill
	if len(enemiesToSpawn) > 0:
		spawnNextEnemy()
	else:
		if enemyReferences.size()==0:
			handleLevelOver()

## Resets all perfomance metrics to their initialization values.
##
## @returns:void
func resetPerformanceMetrics() -> void:
	totalLettersTyped=0
	totalMistakesMade=0
	highestConsecutiveStreak=0
	currentConsecutiveStreak=0
	wordsTyped=0
	GlobalState.currentScore=0
	wordMistakes=0
	wordCorrectLetters=0
	time=0

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
	if not totalLettersTyped==0: return (float(totalLettersTyped)-float(totalMistakesMade))/float(totalLettersTyped)
	else: return 0

## Calculate the characters per minute typed
##
## @returns: float - Characters per minute (including wrong ones)
func getCharactersPerMinute() -> float:
	if not time==0: return totalLettersTyped/(time/60)
	else: return 0

## Calculates the players performance metrics and sends them over the signal bus.
##
## @returns: void
func emitPlayerPerformanceMetrics() -> void:
	var playerPerformanceMetrics: Dictionary = {
		"score":str(GlobalState.currentScore) + " Punkte",
		"charactersPerMinute": str(getCharactersPerMinute()).get_slice(".", 0),
		"accuracy": str(getTotalAccuracy()*100).left(5) + " %",
		"highestConsecutiveStreak":str(highestConsecutiveStreak) + " Zeichen",
		"time": str(time).get_slice(".", 0) + "." 
			+ str(time).get_slice(".", 1).left(3) + " sek",
	}
	SignalBus.displayPerformance.emit(playerPerformanceMetrics)

## Helper function to be run on detecting a level over state has been achieved.
##
## @returns: void
func handleLevelOver() -> void:
	if !endscreenExists:
		var popup = levelover_popup.instantiate()
		add_child(popup)
		emitPlayerPerformanceMetrics()
		GlobalState.isPaused = true
		endscreenExists=true

## Helper function to trigger when the level is over as the player has been hit. 
##
## @returns: void
func gameOverTriggered() -> void:
	print("Your final score is:",GlobalState.currentScore)
	print("GAME OVER")
	if !endscreenExists:
		var popup = gameover_popup.instantiate()
		add_child(popup)
		emitPlayerPerformanceMetrics()
		GlobalState.isPaused=true
		endscreenExists=true

## Returns the ID of the current level.
##
## @returns: int
func getCurrentLevel() -> int:
	return GlobalState.levelID
"""
Occupied levelIDs:
	-4	=	Splash screen
	-3	=	Mode select
	-2	=	Level select
	-1	=	debug (load debug values, used during development)
	0	=	Endless runner
	1-7 = 	Levels 1-7
"""
## Loads the appropriate data for a level given the levelID
##
## @returns: void
func loadLevel(levelID:int) -> void:
	GlobalState.setLevelID(levelID)
	endscreenExists=false
	#Cleanup
	for child in get_children():
		if child != player and child != enemySpawnTimer:
			child.queue_free()
	enemiesToSpawn=null
	enemyReferences=[]
	resetPerformanceMetrics()

	
	# Load animations and backgrounds

	var background:PackedScene
	var backgroundIMG:Texture2D
	var scene:PackedScene
	
	match GlobalState.getLevelID():
		-4:
			scene = load("res://scenes/welcome_splash_screen.tscn")
		-3:
			scene = load("res://scenes/mode_select.tscn")
		-2:
			scene = load("res://scenes/level_select.tscn")
		-1:
			# Debug/ No longer needed
			pass
		0:
			scene = load("res://scenes/EndlessBG.tscn")
		1:
			backgroundIMG = load("res://assets/levels/background/level_1.png")
		2: 
			backgroundIMG = load("res://assets/levels/background/level_2_option1.png")
		3:
			backgroundIMG = load("res://assets/levels/background/Level_3.png")
		4:
			backgroundIMG = load("res://assets/levels/background/Level_4.png")
		5:
			backgroundIMG = load("res://assets/levels/background/Level_5.png")
		6:
			backgroundIMG = load("res://assets/levels/background/Level_6.png")
		7:
			backgroundIMG = load("res://assets/levels/background/Level_7.png")
	
	if levelID<-1:
		add_child(scene.instantiate())
	elif levelID>-1:
		# For endless mode; currently just levels in order. TODO: More randomness
		if levelID==0:
			SignalBus.playEndless.emit()
			add_child(scene.instantiate())	# Add background for endlessaa
			var data = []
			for i in range(5,8):		# Use words from levels 5-8
				data+=DataLoader.getLevelWords(i)
			spawnEnemies(data)
		else:
			SignalBus.playLevel.emit()
			spawnEnemies(DataLoader.getLevelWords(GlobalState.levelID))	
		backgroundNode = TextureRect.new()
		backgroundNode.texture=backgroundIMG
		backgroundNode.z_index=-5		#otherwise background gets drawn over scene
		add_child(backgroundNode)
	
	# Set variables if the level is not a menu or meta level
	if levelID>=-1:
		enemySpawnTimer.stop() # Changes to timer only affect it if paused.
		enemySpawnTimer.wait_time=enemySpawnTimerDuration #Starttime per enemy
		enemySpawnTimer.one_shot=false #Repeat the timer
		enemySpawnTimer.start()
		player.visible=true
		GlobalState.setUpaused()
	
	if levelID > 0:
		var popup = informational_popup.instantiate()
		popup.info = load("res://data/level_data/%s_informational_text.tres" % str(levelID))
		add_child(popup)
		


## Start spawning the enemies of a levelData list based on time or player destroying last enemy 
## (whichever triggers first)
##
## @returns: void
func spawnEnemies(levelData:Variant) -> void:
	enemiesToSpawn=levelData
	
	enemySpawnTimer.stop()
	enemySpawnTimer.start()
	enemySpawnTimer.emit_signal("timeout")

## Spawn the next enemy in the enemiesToSpawn list
##
## @param: Time to kill the last enemy
## @returns: void
func spawnNextEnemy() -> void:
	if GlobalState.levelID>-1:
		var endlessEndgamePoolSize:int=40		# The size at which the endless mode no longer removes entries once spawned.
		if enemiesToSpawn.size()!=0:
			SignalBus.spawnEnemy.emit()
			instanceEnemy(enemiesToSpawn[0])
		if GlobalState.levelID!=0 or (enemiesToSpawn.size()>endlessEndgamePoolSize):
			enemiesToSpawn.remove_at(0)
		enemySpawnTimer.stop()
		enemySpawnTimer.wait_time=min(0.95*lastTTK,enemySpawnTimerDuration)
		enemySpawnTimer.start() # Reset the spawn timer
		#TODO: dynamically change spawn timer based on player performance
		# Semi inplemented, very basic logic so far, should take into account word difficulty too.

## Cleans up enemies, enemy references etc.
##
## @returns:void
func cleanUpEnemies()->void:
	for enemy in enemyReferences:
		enemy.death()
	enemiesToSpawn=[]
	
## Calculates the maximum score possible in a level
## Due to randomness, 10 interations are calculated and the max is taken
##
## @returns: float - the max score of the level
func getMaxScore(id)->float:
	var max=0
	var score=0
	for i in range(20):
		var leveldata=DataLoader.getLevelWords(id)
		var combo=0
		score=0
		for entry in leveldata:
			for letter in entry["word"]:
				combo+=1
			score+=combo*entry["difficulty"]
		if score>max: max=score
	return score
