extends Control

var movementSpeed:int = 150 #Movement speed of the background in pixels/second

@onready var bg1:TextureRect=$bg1
@onready var backgrounds=[bg1]
var textureHeight=1280

var scrollingBGTexture=load("res://assets/levels/background/endless_loop.png")

func _physics_process(delta: float) -> void:
	for picture in backgrounds:
		picture.position.y-=movementSpeed*delta

## Creates a new background instance
##
## @returns: Reference to TextureRectNode
func createNewBackground(yposition=):
	var backgroundRect = TextureRect.new()
	backgroundRect.texture=scrollingBGTexture
	add_child(backgroundRect)
	backgroundRect.position.y=yposition
	return backgroundRect
