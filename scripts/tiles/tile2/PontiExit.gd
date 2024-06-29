extends Area2D

func _on_body_entered(body):
	if body.get_name() == 'Player':
		body.z_index = 0
		body.set_collision_layer(1)
		body.set_collision_mask(1)
		#print("z: " + str(body.z_index))
		#print("coll: " + str(body.collision_layer))
		#print("mask: " + str(body.collision_mask))
