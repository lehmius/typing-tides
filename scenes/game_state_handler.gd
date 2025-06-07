## This script is responsible for the core functionality of the gameplay loop.
## It keeps track of the gamestate, instances enemies and handles failure states.
extends Node

# The following are reference variables.
var enemyReferences:Array[Enemy] = []	# Holds references to each currently instanced enemy
var player:Node					# Holds the reference to the player

var playerScene: PackedScene = preload("res://scenes/player.tscn")

func _ready() -> void:
	instancePlayer()

## Instances the Player within the game.
##
## @returns: void
func instancePlayer() -> void:
	player=playerScene.instantiate()
	add_child(player)
