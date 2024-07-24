extends Control

@onready var grid = $"GridContainer"
var playerInv : Inventory = load("res://CustomResources/Inventories/player_inventory.tres")
var player : Player
func _ready():
	playerInv.update.connect(updateInventory)
	player = get_parent().get_parent().find_child("PlayerCharacter")
	createInventory()
	updateInventory()

func updateInventory():
	var selectedSlot = player.selectedSlot
	for i in range(playerInv.slots.size()):
		# TL;DR make the slot appear as selected if it's selected and vice versa
		var slot = grid.get_children()[i]
		if i == selectedSlot and not slot.selected:
			slot.selected = true
		elif i != selectedSlot and slot.selected:
			slot.selected = false
			
		slot.updateSlot(playerInv.slots[i])

func createInventory():
	for i in range(playerInv.slots.size()):
		var baseSlot = preload("res://Scenes/inv_slot.tscn")
		var newSlot = baseSlot.instantiate()
		grid.add_child(newSlot)
