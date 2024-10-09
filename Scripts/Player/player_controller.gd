extends CharacterBody2D
class_name Player

# Tools
var maxRange := 200.0
var equippedTool : Tool = null
var selectedItem : Item = null
var toolManager : ToolManager
var floorMap : TileMapLayer
signal itemUpdate

# Movement
var movementVector : Vector2
const speed : float = 300.0
const acceleration : float = 50.0
enum directions{
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var dir: directions = directions.DOWN
var moving : bool = false

# Inventory
@export var inventory : Inventory
@export var selectedSlot : int = 0

func _ready():
	toolManager = find_child("Tool")
	floorMap = get_parent().get_parent().find_child("TileLayers").find_child("Ground")
	inventory.update.connect(updateEquippedItem)
	updateEquippedItem()

func _process(delta):
	manageMovementInput(delta)
	manageInventoryInput()
	inventory.updateItems() # ?
	move_and_slide()
	AnimatePlayer()

func manageMovementInput(delta):
	# Gets axis of movement
	movementVector.x = Input.get_axis("Move_Left", "Move_Right")
	if (movementVector.x < 0):
		dir = directions.LEFT
	elif (movementVector.x > 0):
		dir = directions.RIGHT
	movementVector.y = Input.get_axis("Move_Up", "Move_Down")
	if (movementVector.y < 0):
		dir = directions.UP
	elif (movementVector.y > 0):
		dir = directions.DOWN
	# Sets velocity
	velocity = lerp(movementVector * TileSpeed(), movementVector * acceleration, 0.1)
	
	fixSpeed()

func TileSpeed() -> float:
	# Multiplies speed by the floor tiles speed multiplier
	if (floorMap):
		var floorPos : Vector2i = floor(floorMap.local_to_map(position) / 3.5)
		if (floorMap.get_cell_tile_data(floorPos)):
			var tileSpeedMult = floorMap.get_cell_tile_data(floorPos).get_custom_data("WalkSpeedMult")
			if (tileSpeedMult > 0):
				return speed * tileSpeedMult
			else:
				return speed
	return speed

func fixSpeed():
	# Detects if the velocity is greater than the max player speed
	if velocity.length() > TileSpeed():
		# Forces the velocity to be the speed
		velocity = velocity.normalized() * TileSpeed()
		
# Animates the player
func AnimatePlayer():
	# Saves player sprite as var
	var sprite : AnimatedSprite2D = $"PlayerSprite"
	# sets if moving variable
	moving = false
	if (abs(movementVector.length()) > 0):
		moving = true
	
	# Flips the animation direction beforehand so we dont need to worry about doing it later
	sprite.flip_h = false
	
	match dir:
		directions.LEFT:
			# Moving left, flips sprite
			sprite.flip_h = true
			if (moving):
				sprite.play("Walk_Side")
			else:
				sprite.play("Idle_Side")
		directions.RIGHT:
			# Moving right
			if (moving):
				sprite.play("Walk_Side")
			else:
				sprite.play("Idle_Side")
		directions.UP:
			# Moving up
			if (moving):
				sprite.play("Walk_Up")
			else:
				sprite.play("Idle_Up")
		directions.DOWN:
			# Moving down
			if (moving):
				sprite.play("Walk_Down")
			else:
				sprite.play("Idle_Down")


func updateEquippedItem():
	selectedItem = null
	equippedTool = null
	if (inventory.slots[selectedSlot].item):
		selectedItem = inventory.slots[selectedSlot].item
		if !selectedItem.relatedBlockPath.is_empty() && !selectedItem.relatedBlock:
			selectedItem.loadRelatedBlock(selectedItem.relatedBlockPath)
		if (selectedItem.relatedTool):
			equippedTool = selectedItem.relatedTool
	itemUpdate.emit()

# Manages inventory input
func manageInventoryInput():
	var newSlot : int = 0
	
	if Input.is_action_just_pressed("Inv_Slot1"):
		newSlot = 0
	elif Input.is_action_just_pressed("Inv_Slot2"):
		newSlot = 1
	elif Input.is_action_just_pressed("Inv_Slot3"):
		newSlot = 2
	elif Input.is_action_just_pressed("Inv_Slot4"):
		newSlot = 3
	elif Input.is_action_just_pressed("Inv_Slot5"):
		newSlot = 4
	else:
		return
	
	if newSlot != selectedSlot:
		selectedSlot = newSlot
		updateEquippedItem()
