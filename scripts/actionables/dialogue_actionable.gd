extends Area2D

@export var dialogue_resource: DialogicTimeline:
	set(new_dialog): 
		dialogue_resource = new_dialog
	get: return dialogue_resource

func action() -> void:
	Dialogic.start(dialogue_resource)
