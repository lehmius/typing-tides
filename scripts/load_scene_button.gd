extends Button

@export var levelID: int

## Calls on the GameStateHandler to load a specified scene.
func _on_button_down() -> void:
	GameStateHandler.loadLevel(levelID)

## Sets the scene the button points to.
##
## @param scene: The scene to be loaded as a PackedScene
## @returns: void
func set_scene_to_be_loaded(ID: int) -> void:
	levelID = ID

## Sets the current level of the GameStateHandler as the target to be loaded.
func set_levelID_to_current() -> void:
	levelID = GameStateHandler.getCurrentLevel()
