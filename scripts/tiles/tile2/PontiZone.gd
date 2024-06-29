extends Area2D

func _on_body_exited(body):
	if body.get_name() == 'Player':
		#print(body.get_name())
		body.z_index = 1
		body.set_collision_layer(4)
		body.set_collision_mask(4)
		if Global.remy_follow:
			Global.remy.z_index = 1
			Global.remy.set_collision_mask(4)
		#print("z: " + str(body.z_index))
		#print("coll: " + str(body.collision_layer))
		#print("mask: " + str(body.collision_mask))
