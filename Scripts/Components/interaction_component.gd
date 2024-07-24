extends Area2D
class_name InteractionComponent

enum InteractionTypes {
	ATTACK,
	OPEN,
	INTERACT
}

signal Interacted
@export var interactionType : InteractionTypes

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("Action"):
		Interacted.emit()
