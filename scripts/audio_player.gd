extends Node

var AudioStreams = {}
var AudioPlayers = {}



func _ready() -> void:
	# Connect signals
	SignalBus.playHit.connect(playEnemyHit)
	SignalBus.playError.connect(playError)
	SignalBus.playEndless.connect(playEndless)
	SignalBus.playLevel.connect(playLevel)
	# Load assets
	AudioStreams["endless"]=load("res://assets/sounds/soundtrack/atmosphere-of-atlantis-246389.mp3")
	AudioStreams["level"]=load("res://assets/sounds/soundtrack/deep-in-the-ocean-116172.mp3")
	# Instantiate audioplayers and save references to them
	for entry in AudioStreams:
		AudioPlayers[entry] = AudioStreamPlayer.new()
		AudioPlayers[entry].stream=AudioStreams[entry]
		add_child(AudioPlayers[entry])


func playEnemyHit() -> void:
	pass

func playError() -> void:
	pass

# TODO: Check if stopping previous song when when level is loaded feels okay or bad
func playEndless() -> void:
	AudioPlayers["level"].stop()
	AudioPlayers["endless"].play(0)

func playLevel() -> void:
	AudioPlayers["endless"].stop()
	AudioPlayers["level"].play(0)
