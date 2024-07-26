extends Resource
class_name Block

@export var blockName : String = "Empty Block"
@export var minDmg : float = 0.0
@export var requiredToolType : Tool.toolTypes
@export var blockHealth : float = 1.0
@export var atlasPos : Vector2i = Vector2i(0,0)
@export var drops : Array[Drop]


func placeBlock(position : Vector2i, tileMap : TileMap):
	tileMap.set_cell(0, position, 0, atlasPos)
