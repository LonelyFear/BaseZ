extends Node2D

var groundMap : TileMapLayer
var wallMap : TileMapLayer

var heightMap = {}
var humidityMap = {}

signal worldGenFinished(player : Player)

var noise : FastNoiseLite = FastNoiseLite.new()
@export var worldSize : Vector2i = Vector2i(400,400)

func _ready() -> void:
	groundMap = $"Ground"
	wallMap = $"Walls"
	
	worldGenFinished.connect(wallMap.updateGrid)
	startWorldGen()

func startWorldGen() -> void:
	clearMaps()
	heightMap = createNoiseMap(noise.TYPE_SIMPLEX_SMOOTH, 6)
	humidityMap = createNoiseMap(noise.TYPE_SIMPLEX_SMOOTH)
	for x in worldSize.x:
		for y in worldSize.y:
			var currentTile : Vector2i = Vector2i(x,y)
			# Placess grass on the whole world as a base
			groundMap.set_cell(currentTile, 0, Vector2i(1,0))
			
			# Adds Mud
			if (humidityMap[Vector2(x,y)] > 0.8):
				groundMap.set_cell(currentTile, 0, Vector2i(2,2))
			
			# Lake Water
			if (humidityMap[Vector2(x,y)] > 1):
				groundMap.set_cell(currentTile, 0, Vector2i(1, 2))
			
			# Adds Mountains
			if (heightMap[Vector2(x,y)] > 0.8):
				groundMap.set_cell(currentTile, 0, Vector2i(2,1))
				wallMap.set_cell(currentTile, 0, Vector2i(2,0))
			
			# Adds Rivers
			if (heightMap[Vector2(x,y)] < 0.15):
				groundMap.set_cell(currentTile, 0, Vector2i(1, 2))
	spawnTrees()
	finishWorldgen()

func spawnTrees():
	var totalTrees : int = 0
	var treeHolder = get_parent().find_child("Objects").find_child("Trees")
	worldGenFinished.connect(treeHolder.endWorldGen)
	
	for x in worldSize.x:
		for y in worldSize.y:
			if groundMap.get_cell_atlas_coords(Vector2i(x,y)) == Vector2i(1,0):
				if (randi_range(0, 25) < 1):
					totalTrees += 1
					treeHolder.treePositions[Vector2(x + 0.5,y + 0.5) * 56] = 10
	print("Trees: " + str(totalTrees))

func finishWorldgen():
	var player = preload("res://Scenes/player.tscn").instantiate()
	positionPlayer(player)
	get_parent().find_child("Objects").add_child(player)
	get_parent().find_child("DevCamera").queue_free()
	
	worldGenFinished.emit(player)

func positionPlayer(player):
	var testPos = Vector2i(randi_range(worldSize.x/10, worldSize.x - worldSize.x/10), randi_range(worldSize.x/10, worldSize.y - worldSize.y/10))
	if (groundMap.get_cell_atlas_coords(testPos) == Vector2i(1,0)):
		player.position = testPos*56
	else:
		positionPlayer(player)
func createNoiseMap(noiseType := noise.TYPE_PERLIN, octaves := 8):
	
	noise.seed = randi()
	noise.noise_type = noiseType
	noise.fractal_octaves = octaves
	
	var noiseMap = {}
	for x in worldSize.x:
		for y in worldSize.y:
			var noiseValue = 2*(abs(noise.get_noise_2d(x,y)))
			noiseMap[Vector2(x,y)] = noiseValue
	return noiseMap

func clearMaps():
	for i in wallMap.get_used_cells():
		wallMap.erase_cell(i)
	for i in groundMap.get_used_cells():
		groundMap.erase_cell(i)
