extends Node

var AudioStreams = {}	# For sounds that can not be played overlapping or have multiple instances
var SoundStreams = {}	# For sounds that need to be able to be instanced in multiples and overlap
var AudioPlayers = {}	# References to the players
var enemySpawnSounds = []



func _ready() -> void:
	# Connect signals
	SignalBus.playHit.connect(playEnemyHit)
	SignalBus.playError.connect(playError)
	SignalBus.playEndless.connect(playEndless)
	SignalBus.playLevel.connect(playLevel)
	SignalBus.spawnEnemy.connect(playSpawn)
	# Load assets
	AudioStreams["endless"]=preload("res://assets/sounds/soundtrack/atmosphere-of-atlantis-246389.mp3")
	AudioStreams["level"]=preload("res://assets/sounds/soundtrack/deep-in-the-ocean-116172.mp3")
	AudioStreams["error"]=preload("res://assets/sounds/soundFX/short-beep-tone-47916.mp3")
	SoundStreams["spawn"]=preload("res://assets/sounds/soundFX/bubbles-03-91268.mp3")
	# Instantiate audioplayers and save references to them
	for entry in AudioStreams:
		AudioPlayers[entry] = AudioStreamPlayer.new()
		AudioPlayers[entry].stream=AudioStreams[entry]
		add_child(AudioPlayers[entry])


func playEnemyHit() -> void:
	pass

func playError() -> void:
	AudioPlayers["error"].play()

func playSpawn() -> void:
	for enemy in enemySpawnSounds:
		if enemy.playing==false:
			enemy.queue_free()
			enemySpawnSounds.erase(enemy)
	if GlobalState.playSpawnSound:
		var newSoundInstance = AudioStreamPlayer.new()
		newSoundInstance.stream=SoundStreams["spawn"]
		add_child(newSoundInstance)
		newSoundInstance.play()

# TODO: Check if stopping previous song when when level is loaded feels okay or bad
func playEndless() -> void:
	AudioPlayers["level"].stop()
	AudioPlayers["endless"].play(0)

func playLevel() -> void:
	AudioPlayers["endless"].stop()
	AudioPlayers["level"].play(0)
