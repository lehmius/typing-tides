extends RichTextLabel

func _ready() -> void:
	SignalBus.connect("displayPerformance", _on_playerPerformanceMetrics)


## On receiving the player performance metrics this function inserts the stats
## into a table in the score RichTextLabel.
##
## @param playerPerformanceMetrcis: Dictionary containing the player stats
## @returns: void
func _on_playerPerformanceMetrics(playerPerformanceMetrics: Dictionary) -> void:
	append_text("""[center][table=2]
	[cell][left]score[/left][/cell][cell][left]{score}[/left][/cell]
	[cell][left]Zeichen/min[/left][/cell][cell][left]{charactersPerMinute}[/left][/cell]
	[cell][left]Genauigkeit[/left][/cell][cell][left]{accuracy}[/left][/cell]
	[cell][left]Beste Streak[/left][/cell][cell][left]{highestConsecutiveStreak}[/left][/cell]
	[cell][left]Zeit[/left][/cell][cell][left]{time}[/left][/cell]
	[/table][center]""".format(playerPerformanceMetrics))
