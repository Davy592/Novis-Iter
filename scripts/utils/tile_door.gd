extends Area2D

@export var side: Graph.MapNode.LINK_SIDE
var count = 0

func _on_body_entered(body):	
	count += 1
	
	var neighbor_id = Global.map_graph.get_neighbor(Global.current_tile_map_node_id, side)	
	if neighbor_id != -1:
		Global.call_deferred('change_current_tile', Global.map_graph.get_node_data(neighbor_id).get_tile_info(), side, neighbor_id)