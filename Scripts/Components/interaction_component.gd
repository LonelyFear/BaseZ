extends Area2D
class_name InteractionComponent

enum InteractionTypes {
	ATTACK,
	OPEN,
	INTERACT
}

signal Interacted
@export var interactionType : InteractionTypes
var player : Player
func _on_input_event(viewport, event, shape_idx):
	if (get_parent().player):
		player = get_parent().player
	if Input.is_action_pressed("Action"):
		if (interactionType == InteractionTypes.ATTACK):
			if (player.equippedTool && get_parent().position.distance_to(player.position) <= player.equippedTool.toolRange):
				Interacted.emit()
		else:
			Interacted.emit()
