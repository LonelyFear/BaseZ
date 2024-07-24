extends Resource
class_name Drop

@export var item : Item
@export var amount : int

func dropItems(position : Vector2, parent, drop : Drop):
	for i in range(amount):
		print(item)
		var droppedItem = preload("res://Scenes/item.tscn").instantiate()
		#droppedItem.item = itemDrop
		droppedItem.position = position
		parent.add_child(droppedItem)
