extends Resource
class_name Drop

@export var item : Item
@export var amount : int

func dropItems(position : Vector2, parent, drop : Drop):
	for i in range(amount):
		var droppedItem = loadItem("res://Scenes/item_object.tscn")
		droppedItem.item = item
		droppedItem.position = position
		parent.add_child(droppedItem)

func loadItem(path : String) -> RigidBody2D:
	var result = load(path).instantiate()
	return result
