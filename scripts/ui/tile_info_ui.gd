extends Control

var tile_info: TileInfo = null

func set_tile_info(tile_info):
	self.tile_info = tile_info
	update_slot_info()

func update_slot_info():
	#$CenterContainer/Background/TileIcon.texture = tile_info.get_texture()
	$CenterContainer/TileButton/VBoxContainer/HBoxContainer/TileName.text = tile_info.get_tile_name()
	var visible_flag = tile_info.get_side_entry_point(Graph.MapNode.LINK_SIDE.TOP) != null
	if tile_info.get_key_exit(Graph.MapNode.LINK_SIDE.TOP):
		$CenterContainer/TileButton/VBoxContainer/Top.color = Color.YELLOW
	else:
		$CenterContainer/TileButton/VBoxContainer/Top.color = Color.WHITE
	$CenterContainer/TileButton/VBoxContainer/Bottom.visible = visible_flag
	visible_flag = tile_info.get_side_entry_point(Graph.MapNode.LINK_SIDE.BOTTOM) != null
	if tile_info.get_key_exit(Graph.MapNode.LINK_SIDE.BOTTOM):
		$CenterContainer/TileButton/VBoxContainer/Bottom.color = Color.YELLOW
	else:
		$CenterContainer/TileButton/VBoxContainer/Bottom.color = Color.WHITE
	$CenterContainer/TileButton/VBoxContainer/Top.visible = visible_flag
	visible_flag = tile_info.get_side_entry_point(Graph.MapNode.LINK_SIDE.RIGHT) != null
	if tile_info.get_key_exit(Graph.MapNode.LINK_SIDE.LEFT):
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Left.color = Color.YELLOW
	else:
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Left.color = Color.WHITE
	$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Left.visible = visible_flag
	visible_flag = tile_info.get_side_entry_point(Graph.MapNode.LINK_SIDE.LEFT) != null
	if tile_info.get_key_exit(Graph.MapNode.LINK_SIDE.RIGHT):
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Right.color = Color.YELLOW
	else:
		$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Right.color = Color.WHITE
	$CenterContainer/TileButton/VBoxContainer/HBoxContainer/Right.visible = visible_flag

func get_tile_info():
	return tile_info
