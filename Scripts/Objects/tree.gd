extends StaticBody2D

const particles = preload("res://Scenes/particles.tscn")

@export var drops : Array[Drop]
var player : Player

func _ready():
	# Gets player and puts tree on grid
	player = get_parent().get_parent().find_child("PlayerCharacter")
	position = round(position / 56) * 56

func _on_interaction_component_interacted():
	var toolTypes =  player.selectedItem.relatedTool.toolTypes
	var playerTool = player.selectedItem.relatedTool
	# Checks if the player is holding an axe
	if (player && playerTool && playerTool.toolType == toolTypes.AXE):
		# Checks if we are in range
		if (player.position.distance_to(position) <= player.maxRange && player.equippedTool):
			# Damages the tree
			$"HealthComponent".damage(player.equippedTool.miningDmg)
			# Use the Godot Particle system - a great system for making particles - to make some great particles
			var particleInstance = particles.instantiate()
			particleInstance.texture.atlas = preload("res://Sprites/plank.png")
			particleInstance.position = position
			add_sibling(particleInstance)
			
func _on_health_component_death():
	# Drops tree loot
	for drop in drops:
		drop.dropItems(position, get_parent().get_parent(), drop)
	queue_free()
