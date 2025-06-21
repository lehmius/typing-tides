extends Node

func _ready() -> void:
	SignalBus.playHit.connect(playEnemyHit)
	SignalBus.playError.connect(playError)
	SignalBus.playEndless.connect(playEndless)
	SignalBus.playLevel.connect(playLevel)


func playEnemyHit() -> void:
	pass

func playError() -> void:
	pass

func playEndless() -> void:
	pass

func playLevel() -> void:
	pass
