extends Control

@export var movementSpeed:int = 50 #Movement speed of the background in pixels/second

@onready var bg1:TextureRect=$bg1
@onready var backgrounds=[bg1]

var textureHeight=1280
var textureWidth=640

var maxOffset=1280-360		# Maximum offset before the end of the image becomes visible
var scrollingBGTexture=load("res://assets/levels/background/endless_loop.png")

# Instances backgrounds as needed to give permanent scrolling effect
func _physics_process(delta: float) -> void:
	for picture in backgrounds:
		picture.position.y-=movementSpeed*delta
	if backgrounds[0].position.y<-(maxOffset) and backgrounds.size()<2:
		backgrounds+=[createNewBackground(backgrounds[0].position.y+1280)]
	if backgrounds[0].position.y<-textureHeight:
		backgrounds[0].queue_free()
		backgrounds.remove_at(0)



## Creates a new background instance
##
## @returns: Reference to TextureRectNode
func createNewBackground(yposition=0):
	var backgroundRect = TextureRect.new()
	backgroundRect.texture=scrollingBGTexture
	add_child(backgroundRect)
	backgroundRect.position.y=yposition
	return backgroundRect
