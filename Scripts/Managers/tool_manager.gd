extends Node2D


@export var equippedTool : Tool
@onready var sprite := $"ToolSprites"
func _ready():
	get_parent().toolUpdate.connect(updateTool)
	updateTool()

func updateTool():
	equippedTool = get_parent().equippedTool
	if (equippedTool):
		visible = true
		sprite.frame = equippedTool.spriteID
		get_parent().maxRange = equippedTool.toolRange
		get_parent().equippedTool = equippedTool
	else:
		visible = false

func rotateTexture():
	if (sprite):
		look_at(get_global_mouse_position())
		if get_global_mouse_position().x > global_position.x:
			sprite.flip_v = false
		else:
			sprite.flip_v = true

func _process(delta):
	if (equippedTool):
		look_at(get_global_mouse_position())
		rotateTexture()
