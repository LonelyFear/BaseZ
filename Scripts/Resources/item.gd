extends Resource
class_name Item

@export var itemName : String = "Item"
@export var SpriteID : int = 0
@export var maxStack : int = 69 # ehehehehe :3
@export var relatedTool : Tool = null
@export var relatedBlockPath : String
var relatedBlock : Block

func loadRelatedBlock(path : String):
	if (path):
		var result = load(path)
		relatedBlock = result
	else:
		relatedBlock = null
