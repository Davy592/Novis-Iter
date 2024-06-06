extends Node

func _ready():
	var tile_info = Global.tiles_inventory.get_tile_info_at(0)
	tile_info.istantiate_scene()
	var current_tile = tile_info.get_scene_instance()
	current_tile.set_name('CurrentTile')
	add_child(current_tile)
	Global.connect_current_tile_signals()
	Global.init_graph()
	$CanvasLayer/MapEditor.render()
