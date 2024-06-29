extends Area2D

var is_triggered = false

@export var dialogue_resource: DialogicTimeline:
	set(new_dialog): dialogue_resource = new_dialog
	get: return dialogue_resource

func _on_body_entered(body):
	#print("segnale dentro")
	if body.get_name() == 'Player' and !is_triggered:
		is_triggered = true
		Global.remy._on_timer_timeout()
		Global.dialogue_manager.start_dialogue(dialogue_resource)
