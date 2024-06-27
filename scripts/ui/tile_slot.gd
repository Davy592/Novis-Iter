extends Control

var map_node_id: int
var owners_counter = 1

func set_id(id: int):
	map_node_id = id
	update_slot_info()

func increment_owners_counter():
	owners_counter += 1
	#update_slot_info()
	
func decrement_owners_counter():
	owners_counter -= 1
	#update_slot_info()

func update_slot_info():
	if map_node_id != -1:
		var data = Global.map_graph.get_node_data(map_node_id)
		var tile_info = data.get_tile_info()
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/TileName.text = tile_info.get_tile_name()# + '\n' + str(owners_counter)
		var visible_flag = tile_info.get_side_entry_point(Graph.MapNode.LINK_SIDE.TOP) != null
		$CenterContainer/TileButton/VBoxContainer/Bottom.visible = visible_flag
		visible_flag = tile_info.get_side_entry_point(Graph.MapNode.LINK_SIDE.BOTTOM) != null
		$CenterContainer/TileButton/VBoxContainer/Top.visible = visible_flag
		visible_flag = tile_info.get_side_entry_point(Graph.MapNode.LINK_SIDE.RIGHT) != null
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Left.visible = visible_flag
		visible_flag = tile_info.get_side_entry_point(Graph.MapNode.LINK_SIDE.LEFT) != null
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Right.visible = visible_flag
	else:
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/TileName.text = "empty"# + '\n' + str(owners_counter)
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Right.visible = false
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Left.visible = false
		$CenterContainer/TileButton/VBoxContainer/Top.visible = false
		$CenterContainer/TileButton/VBoxContainer/Bottom.visible = false

func _on_map_node_data_updated():
	update_slot_info()
