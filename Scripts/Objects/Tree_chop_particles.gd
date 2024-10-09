extends GPUParticles2D
class_name BreakParticles

# Called when the node enters the scene tree for the first time.
func _ready():
	texture.region = Rect2(randi_range(0, 11), randi_range(0, 11), 5, 5)
	emitting = true
	await finished
	queue_free()


func summonParticles(amount : int, texture : CompressedTexture2D, pos : Vector2, parent):
	var particleInstance = load("res://Scenes/particles.tscn").instantiate()
	particleInstance.texture.atlas = texture
	particleInstance.amount = amount
	particleInstance.position = pos
	parent.add_sibling(particleInstance)
