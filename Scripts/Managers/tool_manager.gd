extends Node2D
class_name ToolManager

@export var equippedTool : Tool
@onready var sprite := $"ToolSprite"
@onready var cooldown := $"Cooldown"

var toolTypes
var toolType : Tool.toolTypes
var maxRange : float
func _ready():
	toolTypes = Tool.toolTypes
	get_parent().itemUpdate.connect(updateTool)
	updateTool()

func updateCooldown():
	$"Cooldown".wait_time = equippedTool.cooldown
	$"Cooldown".start()

func updateTool():
	var oldTool = equippedTool
	equippedTool = get_parent().equippedTool
	if (equippedTool):
		if (oldTool != equippedTool):
			updateCooldown()
		visible = true
		sprite.texture = equippedTool.sprite
		maxRange = equippedTool.toolRange
		toolType = equippedTool.toolType
	else:
		visible = false

func useTool(requiredType : Tool.toolTypes) -> bool:
	if (cooldown.is_stopped() && equippedTool && requiredType == toolType || cooldown.is_stopped() && requiredType == -1):
		updateCooldown()
		return true
	else:
		return false

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
