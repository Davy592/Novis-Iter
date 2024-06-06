extends Control

var tile_info: TileInfo = null

func set_tile_info(tile_info):
	self.tile_info = tile_info
	update_slot_info()

func update_slot_info():
	#$CenterContainer/Background/TileIcon.texture = tile_info.get_texture()
	$CenterContainer/TileName.text = tile_info.get_tile_name()

func get_tile_info():
	return tile_info
