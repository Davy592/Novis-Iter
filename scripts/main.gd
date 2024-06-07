extends Node

func _ready():
	var tile_info = Global.map_graph.get_node_data(Global.current_tile_map_node_id).get_tile_info()
	tile_info.istantiate_scene()
	var current_tile = tile_info.get_scene_instance()
	current_tile.set_name('CurrentTile')
	add_child(current_tile)
	$CanvasLayer/MapEditor.render()
	$Player.z_index = 100
	$Player.position = tile_info.get_default_entry_point()
	Global.current_map_node_updated.connect($CanvasLayer/MapEditor._on_current_map_node_updated)
	
