extends Resource
class_name Enemy

@export var meleeDmg : float = 1.0
@export var blockDmg : float = 1.0
@export var maxHealth : float = 10.0
@export var speedMult : float = 1.0
@export var scaleMult : float = 1.0
@export var spriteAnim : SpriteFrames = preload("res://Resources/EnemyAnimations/basic_zombie_anim.tres")
@export var drops : Array[Drop]

