extends Node

var isPaused:bool=false
var language="deutsch" # Possible Values: deutsch, english
var levelID:int=-4
var seenModeSelectPopup: bool = false


var playProjectileSound: bool = true
var playSpawnSound: bool = true
var playEnemyDeathSounds: bool = true
var buttonHoverSound: bool = true
var playErrorSound: bool = true



func setPaused() -> void:
	isPaused=true
	Engine.set_time_scale(0)

func setUpaused() -> void:
	isPaused=false
	Engine.set_time_scale(1)

func getLevelID() -> int:
	return levelID

func setLevelID(id: int) -> void:
	levelID = id

func getSeenModeSelectPopup() -> bool:
	return seenModeSelectPopup

func flipSeenModeSelectPopup() -> void:
	seenModeSelectPopup = !seenModeSelectPopup
