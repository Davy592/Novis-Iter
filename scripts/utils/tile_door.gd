extends Area2D

@export var side: Graph.MapNode.LINK_SIDE

func _on_body_entered(body):
	var neighbor_id = Global.map_graph.get_neighbor(Global.current_tile_map_node_id, side)	
	
	if neighbor_id != -1:
		var tile_info = Global.map_graph.get_node_data(neighbor_id).get_tile_info()
		if tile_info.get_side_entry_point(side) != null and tile_info.is_condition_satisfied():
			Global.call_deferred('change_current_tile', tile_info, side, neighbor_id)
