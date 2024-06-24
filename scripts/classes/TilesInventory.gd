class_name TilesInventory

signal tiles_inventory_updated(tile_info, index)

var tiles : Array[TileInfo]

func _init():
	tiles = [
		TileInfo.new("res://resources/data/tile4.json"),
		TileInfo.new("res://resources/data/hub1.json"),
		TileInfo.new("res://resources/data/tile6.json")
	]

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
