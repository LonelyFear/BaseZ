extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	texture.region = Rect2(randi_range(0, 11), randi_range(0, 11), 5, 5)
	emitting = true
	await finished
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
