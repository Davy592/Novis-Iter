
var tile1_path = "res://scenes/tiles/tile_layout.tscn"
var tile2_path = "res://scenes/tiles/tile6.tscn"
var hub1_scene = "res://scenes/tiles/hub_1.tscn"

func find_tile1_id():
	var it = Global.map_graph.get_bfs_iterator(Global.current_tile_map_node_id)
	var data: Graph.MapNodeData
	var id
	while it.has_next():
		id = it.next()
		data = Global.map_graph.get_node_data(id)
		if data.get_tile_info().get_scene().resource_path == tile1_path:
			return id

func is_condition_satisfied():
	var tile1_id = find_tile1_id()
	var right_id = Global.map_graph.get_neighbor(
		tile1_id, 
		Graph.MapNode.LINK_SIDE.RIGHT)
	var bottom_id = Global.map_graph.get_neighbor(
		tile1_id, 
		Graph.MapNode.LINK_SIDE.BOTTOM)
	if right_id == -1 or bottom_id == -1:
		return false
	var neighbor_scene_path = Global.map_graph.get_node_data(
		right_id).get_tile_info().get_scene().resource_path
	var bottom_scene_path = Global.map_graph.get_node_data(
	bottom_id).get_tile_info().get_scene().resource_path
	return bottom_scene_path == tile2_path and neighbor_scene_path == hub1_scene and Global.current_tile_map_node_id == tile1_id 
