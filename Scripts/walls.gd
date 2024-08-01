extends TileMap
class_name WallsMap
var tileDict = {}

signal tileBroken(blockData : Block)

func _ready():
	updateGrid()

func damageTile(pos : Vector2i, damage : int):
	print("tile Damaged")
	tileDict[pos] -= damage
	print(tileDict[pos])
	if (tileDict[pos] < 1):
		tileBroken.emit(get_cell_tile_data(0, pos).get_custom_data("BlockData"))
		erase_cell(0 , pos)
		tileDict.erase(pos)
		
		updateGrid()

func updateGrid():
	for currentTile in get_used_cells(0):
		# Checks if the cell has data
		if (get_cell_tile_data(0, currentTile)):
			# If the cell has data, we get the block data for its health, name, minimum mining damage, etc.
			# We get the health value of the block
			var blockHealth = get_cell_tile_data(0, currentTile).get_custom_data("BlockData").blockHealth
			# Checks if the tile we are looking at doesnt have a health value already
			if !tileDict.get(currentTile):
				# We add the health value to our dictionary at the position of the tile
				tileDict[currentTile] = blockHealth
