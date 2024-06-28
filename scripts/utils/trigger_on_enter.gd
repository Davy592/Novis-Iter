extends Area2D

var is_triggered: bool = false:
	set(new_triggered_state): is_triggered = new_triggered_state
	get: return is_triggered
@export var dialogue_resource: DialogicTimeline:
	set(new_dialog): dialogue_resource = new_dialog
	get: return dialogue_resource

func _on_body_entered(body):
	if body.is_in_group("Player") and !is_triggered:
		Global.dialogue_manager.start_dialogue(dialogue_resource)
		is_triggered = true
