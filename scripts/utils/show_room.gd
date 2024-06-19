extends Area2D

enum SHOW_SIDE {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

@export var show_side: SHOW_SIDE
@export var tile_map_node: TileMap

func _on_body_exited(body):
	var size = $CollisionShape2D.get_shape().get_rect().size * $CollisionShape2D.scale
	var right_x = $CollisionShape2D.position.x + $CollisionShape2D.get_shape().get_rect().end.x * $CollisionShape2D.scale.x
	var left_x = $CollisionShape2D.position.x + $CollisionShape2D.get_shape().get_rect().position.x * $CollisionShape2D.scale.x
	var bottom_y = $CollisionShape2D.position.y + $CollisionShape2D.get_shape().get_rect().end.y * $CollisionShape2D.scale.y
	var top_y = $CollisionShape2D.position.y + $CollisionShape2D.get_shape().get_rect().position.y * $CollisionShape2D.scale.y
	var collision_rect: Rect2 = $CollisionShape2D.get_shape().get_rect()
	#print(body.get_name())
	if body.get_name() == 'Player':
		match show_side:
			SHOW_SIDE.TOP:
				if body.position.y < top_y:
					tile_map_node.visible = false
				else:
					tile_map_node.visible = true
			SHOW_SIDE.RIGHT:
				if body.position.x > right_x:
					tile_map_node.visible = false
				else:
					tile_map_node.visible = true
			SHOW_SIDE.BOTTOM:
				if body.position.y > bottom_y:
					tile_map_node.visible = false
				else:
					tile_map_node.visible = true
			SHOW_SIDE.LEFT:
				if body.position.x < left_x:
					tile_map_node.visible = false
				else:
					tile_map_node.visible = true
	#print(tile_map_node.visible)
	#print("body: ", body.position)
	#print("top_x: ", top_y)
	#print("right_x: ", right_x)
	#print("bottom_x: ", bottom_y)
	#print("left_x: ", left_x)
