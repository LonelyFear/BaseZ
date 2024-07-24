extends StaticBody2D

const particles = preload("res://Scenes/TreeChopParticles.tscn")

@export var drops : Array[Drop]
var player : CharacterBody2D

func _ready():
	player = get_parent().get_parent().find_child("PlayerCharacter")
	position = round(position / 56) * 56

func _on_interaction_component_interacted():
	if (player and player.find_child("Crosshair").currentState == player.find_child("Crosshair").states.AIM):
		if (player.position.distance_to(position) <= player.maxRange && player.equippedTool):
			$"HealthComponent".damage(player.equippedTool.miningDmg)
			# Use the Godot Particle system - a great system for making particles - to make some great particles
			var particleInstance = particles.instantiate()
			particleInstance.position = position
			add_sibling(particleInstance)
			
func _on_health_component_death():
	for drop in drops:
		drop.dropItems(position, get_parent().get_parent(), drop)
	queue_free()
