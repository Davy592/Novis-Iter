extends Control

var map_node_id: int
var owners_counter = 1

func set_id(id: int):
	map_node_id = id
	update_slot_info()

func increment_owners_counter():
	owners_counter += 1
	update_slot_info()
	
func decrement_owners_counter():
	owners_counter -= 1
	update_slot_info()

func update_slot_info():
	if map_node_id != -1:
		var data = Global.map_graph.get_node_data(map_node_id)
		var tile_info = data.get_tile_info()
		$CenterContainer/TileName.text = tile_info.get_tile_name() + '\n' + str(owners_counter)
	else:
		$CenterContainer/TileName.text = "empty" + '\n' + str(owners_counter)

func _on_map_node_data_updated():
	update_slot_info()
