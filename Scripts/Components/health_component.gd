extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
var health : float
var dead : bool

signal death

func _ready():
	resetHealth()

func _process(delta):
	if health > 0:
		dead = false

func resetHealth():
	health = MAX_HEALTH

func damage(dmg : float):
	if (health > 0):
		health -= dmg
	elif (!dead):
		dead = true
		death.emit()

