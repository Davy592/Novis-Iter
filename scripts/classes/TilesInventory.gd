class_name TilesInventory

signal tiles_inventory_updated(tile_info, index)

var tiles : Array[TileInfo]

func _init():
	tiles = [
		TileInfo.new("res://resources/data/hub2.json"),
		TileInfo.new("res://resources/data/tile1.json"),
		TileInfo.new("res://resources/data/tile2.json"),
		TileInfo.new("res://resources/data/tile3.json")
	]

func unlock():
	var arguments = [
		TileInfo.new("res://resources/data/tile4.json"),
		TileInfo.new("res://resources/data/tile6.json"),
		TileInfo.new("res://resources/data/hub3.json")
	]
	for tile_info in arguments:
		add(tile_info)

#region: Add e Remove 
func add(tile_info):
	tiles.append(tile_info)
	emit_signal("tiles_inventory_updated", tile_info, -1)

func remove(index):
	tiles.remove_at(index)
	emit_signal("tiles_inventory_updated", null, index)
#endregion
 
#region: Getters & Setters
func get_size():
	return tiles.size()

func get_tile_info_at(index):
	return tiles[index]
#endregion
