## This script creates a Godot Signal Bus - allowing many nodes to send and receive signals without having to know each other.
## Compared to a more traditional Signal implementation, this use of a bus should be both more stable and reduce overhead.
## The Node this Script is attached to (SignalBus) has to be Autoloaded within the project to be accessible by all Nodes.
extends Node

signal onHit # Expects a reference to the Enemy that has been hit.
signal keyPressed # Expects a event of the pressed Key.
signal gameOver # Game Over signal if Player is hit
signal levelOver # Level Over signal for when a level is beaten.
signal levelData # Data transfer needed when loading a level
signal displayPerformance # Display the player performance metrics and endscreen
signal loadLevel # Signals that a new level should be loaded.
signal fetchLevelData # Tells the dataLoader to fetch the signal data.
signal deleteMenus	# Deletes all popups/menus

# Audio signals
signal playHit
signal playError
signal playEndless
signal playLevel
signal spawnEnemy
signal enemyDeath
signal playWelcome
