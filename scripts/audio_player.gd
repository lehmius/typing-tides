extends Node

var AudioStreams = {}	# For sounds that can not be played overlapping or have multiple instances
var SoundStreams = {}	# For sounds that need to be able to be instanced in multiples and overlap
var AudioPlayers = {}	# References to the players
var enemySpawnSounds = []
var projectileSounds = []



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
	SoundStreams["projectile"]=preload("res://assets/sounds/soundFX/8-bit-game-sfx-sound-6-269965.mp3")
	
	# Instantiate audioplayers and save references to them
	for entry in AudioStreams:
		AudioPlayers[entry] = AudioStreamPlayer.new()
		AudioPlayers[entry].stream=AudioStreams[entry]
		add_child(AudioPlayers[entry])


func playEnemyHit() -> void:
	instanceOverlappingSound("projectile",GlobalState.playProjectileSound,projectileSounds)

func playError() -> void:
	AudioPlayers["error"].play()

func playSpawn() -> void:
	instanceOverlappingSound("spawn",GlobalState.playSpawnSound,enemySpawnSounds)

func instanceOverlappingSound(soundName:String,condition:bool,referenceArray) -> void:
	for instance in enemySpawnSounds:
		if instance.playing==false:
			instance.queue_free()
			enemySpawnSounds.erase(instance)
	if condition:
		var newSoundInstance = AudioStreamPlayer.new()
		newSoundInstance.stream=SoundStreams[soundName]
		add_child(newSoundInstance)
		newSoundInstance.play()

func playEndless() -> void:
	AudioPlayers["level"].stop()
	AudioPlayers["endless"].play(0)

func playLevel() -> void:
	AudioPlayers["endless"].stop()
	AudioPlayers["level"].play(0)
