class_name DialogueManager

var dialogue_queue = []
var is_last_dialogue_ended = true

signal all_dialogues_ended

func start_dialogue(dialogue):
	if is_last_dialogue_ended:
		Dialogic.start(dialogue)
		is_last_dialogue_ended = false
	else:
		dialogue_queue.append(dialogue)

func are_all_dialogues_ended():
	return is_last_dialogue_ended

func _on_timeline_ended():
	if not dialogue_queue.is_empty():
		Dialogic.start(dialogue_queue.pop_front())
	else:
		is_last_dialogue_ended = true
		all_dialogues_ended.emit()
		
