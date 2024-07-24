extends Control

@export var selected : bool = false

func _ready():
	$"ItemSprite".visible = false
	$"ItemCounter".visible = false

func updateSlot(slot : InvSlot):
	if (slot.item):
		$"ItemSprite".visible = true
		$"ItemSprite".frame = slot.item.SpriteID
		$"ItemCounter".visible = true
		$"ItemCounter".text = str(slot.amount)
		if (slot.amount == 1):
			$"ItemCounter".visible = false
	else:
		$"ItemSprite".visible = false
		$"ItemCounter".visible = false
	
	if selected: # selected (white outline)
		if $"SlotSprite".frame == 0: 
			$"SlotSprite".frame = 1
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.075, 1.075), 0.15)
	else:
		if $"SlotSprite".frame == 1: 
			$"SlotSprite".frame = 0
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)
	
