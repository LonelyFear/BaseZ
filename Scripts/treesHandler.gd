extends Node2D

var treePositions = {}
var player : Player

var treeViewDist : float = 1000

func endWorldGen(player):
	self.player = player

func _process(delta: float) -> void:
	if (player):
		for pos in treePositions:
			if (pos.distance_to(player.position) < treeViewDist):
				var dataAtPos = treePositions[pos]
				var newTree = preload("res://Scenes/tree.tscn").instantiate()
				newTree.position = pos
				newTree.find_child("HealthComponent").health = treePositions[pos]
				add_child(newTree)
				treePositions.erase(pos)
