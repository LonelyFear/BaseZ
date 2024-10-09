extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
@export var resetHealthOnReady : bool = true

var health : float
var dead : bool

var lasthealth



signal death
signal healthChanged

func _ready():
	if (resetHealthOnReady):
		resetHealth()

func _process(delta):
	if health > 0:
		dead = false
		
	if lasthealth != health:
		healthChanged.emit(health)
		lasthealth = health

func resetHealth():
	health = MAX_HEALTH

func damage(dmg : float):
	print(health)
	if (health > 0):
		health -= dmg
	elif (!dead):
		dead = true
		death.emit()
