## This script is responsible for the core functionality of the gameplay loop.
## It keeps track of the gamestate, instances enemies and handles failure states.
extends Node

# Variables to change manually
var levelID:int=0						# ID for the currently loaded level

# The following are reference variables.
var enemyReferences:Array[Enemy] = []	# Holds references to each currently instanced enemy
var player:Node							# Holds the reference to the player

var playerScene: PackedScene = preload("res://scenes/player.tscn")
var enemyScene: PackedScene = preload("res://scenes/enemy.tscn")

func _ready() -> void:
	instancePlayer()
	instanceEnemy()

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
	var wordlist="Katze,Hund,Haus,Apfel,Buch,Tisch,Wasser,Stadt,Fenster,Blume,Regen,Erde,Lächeln,Fahrrad,Mond".split(",")
	var word=wordlist[randi_range(0,wordlist.size()-1)]
	return word

## Instances an enemy scene with a word from the getNextWord function, 
## positions it at a random position just outside the screen and populates variables accordingly.
##
## @returns: void
func instanceEnemy() -> void:
	var word = getNextWord()
	var nextEnemy = enemyScene.instantiate() 
	nextEnemy.position = Vector2(680,randi_range(15,345))
	nextEnemy.Player=player
	enemyReferences+=[nextEnemy]
	add_child(nextEnemy)
