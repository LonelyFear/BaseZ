extends Resource
class_name Tool

enum toolTypes {
	RANGED,
	AXE,
	PICKAXE
}
@export var meleeDmg : float = 0
@export var miningDmg : float = 0
@export var sprite : CompressedTexture2D
@export var toolRange : float = 400.0
@export var toolType : toolTypes
@export var cooldown : float = 0.5
#projectile
