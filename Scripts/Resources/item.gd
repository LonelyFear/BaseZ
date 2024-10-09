extends Resource
class_name Item

@export var itemName : String = "Item"
@export var sprite : CompressedTexture2D
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
