extends Resource
class_name Inventory

signal update

@export var slots : Array[InvSlot]
#@export var selectedSlot : int = 0

func addItem(item : Item) -> bool:
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = InvSlot.new()
	
	var itemSlots = slots.filter(func(slot): return slot.item == item && slot.amount < item.maxStack)
	if (!itemSlots.is_empty()):
		itemSlots[0].amount += 1
		updateItems()
		return true
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if (!emptySlots.is_empty()):
			emptySlots[0].item = item
			emptySlots[0].amount = 1
			updateItems()
			return true
		else:
			return false

func consumeItem(item : Item) -> bool:
	var itemSlots = slots.filter(func(slot): return slot.item == item && slot.amount > 0)
	if (!itemSlots.is_empty()):
		itemSlots[0].amount -= 1
		updateItems()
		return true
	else:
		return false

func updateItems():
	for slot in slots:
		if (slot.amount < 1 && slot.item):
			slot.item = null
			slot.amount = 0
	update.emit()
