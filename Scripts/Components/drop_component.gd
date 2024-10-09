extends Node2D
class_name DropComponent

@export var drops : Array[Drop]

func dropTable():
	if (drops):
		for i in drops:
			dropItem(i, i.amount)

func dropItem(drop : Drop, amount : int = 1):
	for i in range(amount):
		var item = preload("res://Scenes/item.tscn")
		var droppedItem = item.instantiate()
		droppedItem.item = drop.itemDrop
		droppedItem.position = get_parent().position
		get_parent().get_parent().add_child(droppedItem)


