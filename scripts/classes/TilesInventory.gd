class_name TilesInventory

signal tiles_inventory_updated(tile_info, index)

var tiles

func _init():
	tiles = [
		TileInfo.new("res://resources/data/tile.json"),
		TileInfo.new("res://resources/data/tile1.json"),
		TileInfo.new("res://resources/data/tile2.json"),
		TileInfo.new("res://resources/data/tile3.json")
	]

func add(tile_info):
	tiles.append(tile_info)
	emit_signal("tiles_inventory_updated", tile_info, -1)

func remove(index):
	tiles.remove_at(index)
	emit_signal("tiles_inventory_updated", null, index)

func get_size():
	return tiles.size()

func get_tile_info_at(index):
	return tiles[index]
