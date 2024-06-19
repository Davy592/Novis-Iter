extends Area2D

@export var dialogue_resource: DialogicTimeline

func action() -> void:
	Global.dialogue_manager.start_dialogue(dialogue_resource)
