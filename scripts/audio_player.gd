extends Node

var AudioStreams = {}	# For sounds that can not be played overlapping or have multiple instances
var SoundStreams = {}	# For sounds that need to be able to be instanced in multiples and overlap
var AudioPlayers = {}	# References to the players
var enemySpawnSounds = []
var projectileSounds = []
var enemyDeathSounds = []

var welcomeMusicHasBeenPlayedBefore:bool = false



func _ready() -> void:
	# Connect signals
	SignalBus.playHit.connect(playEnemyHit)
	SignalBus.playError.connect(playError)
	SignalBus.playEndless.connect(playEndless)
	SignalBus.playLevel.connect(playLevel)
	SignalBus.spawnEnemy.connect(playSpawn)
	SignalBus.enemyDeath.connect(playEnemyDeath)
	SignalBus.playWelcome.connect(playWelcomeMusic)
	SignalBus.buttonHover.connect(playHover)
	# Load assets
	# Audio Streams
	AudioStreams["endless"]=preload("res://assets/sounds/soundtrack/atmosphere-of-atlantis-246389.mp3")
	AudioStreams["level"]=preload("res://assets/sounds/soundtrack/deep-in-the-ocean-116172.mp3")
	AudioStreams["error"]=preload("res://assets/sounds/soundFX/short-beep-tone-47916.mp3")
	AudioStreams["welcome"]=preload("res://assets/sounds/soundtrack/soul-of-the-underwater-kingdom-248171.mp3")
	AudioStreams["hover"]=preload("res://assets/sounds/menu_sounds/hover-button-287656.mp3")
	# Sound Streams
	SoundStreams["spawn"]=preload("res://assets/sounds/soundFX/bubbles-03-91268.mp3")
	SoundStreams["projectile"]=preload("res://assets/sounds/soundFX/8-bit-game-sfx-sound-6-269965.mp3")
	SoundStreams["enemyDeath"]=preload("res://assets/sounds/soundFX/death2-340040.mp3")
	# Instantiate audioplayers and save references to them
	for entry in AudioStreams:
		AudioPlayers[entry] = AudioStreamPlayer.new()
		AudioPlayers[entry].stream=AudioStreams[entry]
		add_child(AudioPlayers[entry])
	
	# This is a slightly hacky workaround - calling this in welcomesplashscreen may send signal 
	# before it is connected. This ensures it is connected and sends signal when the game is run
	SignalBus.playWelcome.emit()

func playHover() -> void:
	if GlobalState.buttonHoverSound:
		AudioPlayers["hover"].play()

func playWelcomeMusic() -> void:
	print("receiving emission")
	if !welcomeMusicHasBeenPlayedBefore:
		# These stop signals should never be relevant but are added for redundancy
		AudioPlayers["level"].stop()
		AudioPlayers["endless"].stop()
		AudioPlayers["welcome"].play()
		welcomeMusicHasBeenPlayedBefore=true

func playEnemyDeath() -> void:
	instanceOverlappingSound("enemyDeath",GlobalState.playEnemyDeathSounds,enemyDeathSounds)

func playEnemyHit() -> void:
	instanceOverlappingSound("projectile",GlobalState.playProjectileSound,projectileSounds)

func playError() -> void:
	if GlobalState.playErrorSound:
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
	AudioPlayers["welcome"].stop()
	AudioPlayers["level"].stop()
	AudioPlayers["endless"].play(0)

func playLevel() -> void:
	AudioPlayers["welcome"].stop()
	AudioPlayers["endless"].stop()
	AudioPlayers["level"].play(0)
