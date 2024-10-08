extends Node2D

var mousePos : Vector2
var gridPos : Vector2i
signal shoot

var player : Player
var tileGrid : WallsMap
var tileDict = {}

var tween : Tween = null

enum states{
	AIM,
	BUILD,
	HIDDEN # {NoAI:1}
}
var currentState : states
var canPlace : bool = true

func getGridPos():
	#Gets the position of crosshair on the grid
	gridPos = floor(tileGrid.local_to_map(get_global_mouse_position()) / 3.5)

func _ready():
	# Gets the player
	player = get_parent()
	# Gets the grid
	tileGrid = player.get_parent().get_parent().find_child("TileLayers").find_child("Walls")
	print(tileGrid)
	player.itemUpdate.connect(setCrosshair)
	
	#updateTileHealthValues()

func updateTileHealthValues():
	# Goes through all the cells in the tilemap
	for currentTile in tileGrid.get_used_cells():
		# Checks if the cell has data
		if (tileGrid.get_cell_tile_data(currentTile)):
			# If the cell has data, we get the block data for its health, name, minimum mining damage, etc.
			# We get the health value of the block
			var blockHealth = tileGrid.get_cell_tile_data(currentTile).get_custom_data("BlockData").blockHealth
			# Checks if the tile we are looking at doesnt have a health value already
			if !tileDict.get(currentTile):
				# We add the health value to our dictionary at the position of the tile
				tileDict[currentTile] = blockHealth

func _process(delta):
	updateTileHealthValues()
	getGridPos()
	if (currentState == states.BUILD && canPlace):
		# Checks if the player can build and if the crosshair has a block selected
		buildBlock()
	if (currentState == states.AIM):
		# Checks if the player could place a block and if the crosshair has a tool selected
		breakBlock()

func breakBlock():
	# Gets the mining damage of the player tool
	var miningDmg = player.selectedItem.relatedTool.miningDmg
	var toolType = player.selectedItem.relatedTool.toolType
	# Prepares a variable to hold the block data
	var blockData : Block
	# Checks if the block at the position has data
	if (tileGrid.get_cell_tile_data(gridPos)):
		# If it does, we get the blockData of that tile
		blockData = tileGrid.get_cell_tile_data(gridPos).get_custom_data("BlockData")
	
	# Makes sure blockData isnt null, the tool has more mining damage than the block's minimum mining damage
	# and checks if the player clicks
	if (blockData && miningDmg >= blockData.minDmg && Input.is_action_pressed("Action") && player.toolManager.useTool(blockData.requiredToolType)):
		# Subtracts the mining damage from the health at that point
		tileGrid.damageTile(gridPos, miningDmg)
		# Adds particles
		BreakParticles.new().summonParticles(10, blockData.blockSprite, position, self)

func buildBlock():
	# Gets the block that we are going to try to place
	var placedBlock = player.selectedItem.relatedBlock
	# Makes sure the player clicked and that the block isnt null
	if (Input.is_action_just_pressed("Action") && placedBlock):
		# Makes sure the tile is empty and consumes one of the item we are going to place
		if (tileGrid.get_cell_atlas_coords(gridPos) == Vector2i(-1, -1) && player.inventory.consumeItem(player.selectedItem)):
			# Runs the placeBlock function in the block class
			tileGrid.placeTile(gridPos, placedBlock)
			tileGrid.updateGrid()
			# Visual effects for placing
			$"CrosshairSprite".scale = Vector2(4, 4)
			if tween: tween.kill()
			tween = create_tween()
			tween.tween_property($"CrosshairSprite", "scale", Vector2(3.5, 3.5), 0.5)

func setCrosshair():
	if (player.equippedTool):
		# Sets the crosshair to AIM if the player is holding a tool
		show()
		currentState = states.AIM
	elif player.selectedItem && player.selectedItem.relatedBlock:
		# Sets the crosshair to BUILD if the player is holding a placeable
		show()
		currentState = states.BUILD
	else:
		# Otherwise hide the crosshair
		hide()
		currentState = states.HIDDEN
	setCrosshairTexture()

func setCrosshairTexture():
	match currentState:
		states.AIM:
			# If the state is aim, we set the crosshair to the aim sprite and rescale it
			$"CrosshairSprite".frame = 0
			$"CrosshairSprite".scale = Vector2(2,2)
			modulate = Color.WHITE
			
			global_position = get_global_mouse_position()
			if (player.position.distance_to(get_global_mouse_position()) > player.maxRange):
				# Makes sure the crosshair doesnt go outside of the range of the player's tool
				modulate = Color.RED
				position = position.normalized() * player.maxRange
		
		states.BUILD:
			# If the state is build, we rescale the crosshair
			$"CrosshairSprite".frame = 1
			modulate = Color.WHITE
			$"CrosshairSprite".scale = Vector2(3.5,3.5)
			
			# Snaps the crosshair to the grid
			global_position = Vector2(gridPos.x + 0.5, gridPos.y + 0.5) * 56


func _on_area_2d_body_entered(body):
	# Checks if the crosshair is over a tree or the player, doesnt allow placing if so
	if (body.is_in_group("Object")):
		canPlace = false


func _on_area_2d_body_exited(body):
	# Checks if the crosshair moved, then allows placing again
	if (body.is_in_group("Object")):
		canPlace = true
