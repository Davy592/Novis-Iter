extends Area2D

@export var dialogue_resource: DialogicTimeline

func action() -> void:
	Dialogic.start(dialogue_resource)
