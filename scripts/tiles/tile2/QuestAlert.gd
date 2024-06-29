extends Area2D

var fatto = false

@export var dialogue_resource: DialogicTimeline:
	set(new_dialog): 
		dialogue_resource = new_dialog
	get: return dialogue_resource

func _on_body_exited(body):
	if body.get_name() == 'Player':
		body.z_index = 0
		body.set_collision_layer(1)
		body.set_collision_mask(1)
		#print("z: " + str(body.z_index))
		#print("coll: " + str(body.collision_layer))
		#print("mask: " + str(body.collision_mask))
		if not fatto:
			Global.dialogue_manager.start_dialogue(dialogue_resource)
			fatto = true
