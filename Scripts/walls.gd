extends TileMapLayer
class_name WallsMap
var tileDict = {}

signal tileBroken(blockData : Block)

func _ready():
	#updateGrid()
	pass

func placeTile(position : Vector2i, block : Block):
	set_cell(position, 0, block.atlasPos)

func damageTile(pos : Vector2i, damage : int, drop : bool = true):
	tileDict[pos] -= damage
	if (tileDict[pos] < 1):
		if (drop):
			dropBlock(get_cell_tile_data(pos).get_custom_data("BlockData"), Vector2(pos.x + 0.5, pos.y + 0.5))
		erase_cell(pos)
		tileDict.erase(pos)
		
		updateGrid()

func dropBlock(blockData : Block, pos : Vector2):
	for drop in blockData.drops:
		drop.dropItems(pos * 56, get_parent().get_parent().find_child("Objects"), drop)

func updateGrid(player = null):
	for currentTile in get_used_cells():
		# Checks if the cell has data
		if (get_cell_tile_data(currentTile)):
			# If the cell has data, we get the block data for its health, name, minimum mining damage, etc.
			# We get the health value of the block
			var blockHealth = get_cell_tile_data(currentTile).get_custom_data("BlockData").blockHealth
			# Checks if the tile we are looking at doesnt have a health value already
			if !tileDict.get(currentTile):
				# We add the health value to our dictionary at the position of the tile
				tileDict[currentTile] = blockHealth
