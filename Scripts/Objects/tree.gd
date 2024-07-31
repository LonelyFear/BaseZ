extends StaticBody2D

@export var drops : Array[Drop]
var player : Player

func _ready():
	# Gets player and puts tree on grid
	player = get_parent().get_parent().find_child("PlayerCharacter")
	position = round(position / 56) * 56

func _on_interaction_component_interacted():
	var playerTool : Tool
	if (player.selectedItem && player.selectedItem.relatedTool):
		playerTool = player.selectedItem.relatedTool
	else:
		return
	# Checks if the player is holding an axe
	var toolTypes =  player.selectedItem.relatedTool.toolTypes
	# Checks if we are in range
	if (player.toolManager.useTool(Tool.toolTypes.AXE)):
		# Damages the tree
		$"HealthComponent".damage(player.equippedTool.miningDmg)
		# Use the Godot Particle system - a great system for making particles - to make some great particles
		BreakParticles.new().summonParticles(10, preload("res://Sprites/plank.png"), position, self)
			
func _on_health_component_death():
	# Drops tree loot
	for drop in drops:
		drop.dropItems(position, get_parent().get_parent(), drop)
	queue_free()
