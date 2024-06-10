extends Node

class_name TileInfo

#region: Variabili
var tile_name : String
var scene : PackedScene
var texture: Texture
var description : String
var scene_instance
var entry_points : Array = [null, null, null, null]
var default_entry_point : Vector2
var cam_top_limit : int
var cam_right_limit : int
var cam_left_limit : int
var cam_bottom_limit : int
#endregion

func _init(json_path):
	var json_as_text := FileAccess.get_file_as_string(json_path)
	var tile_data = JSON.parse_string(json_as_text)
	
	# Inizializza le variabili con tile_data
	tile_name = tile_data['name']
	scene = load(tile_data['scene'])
	#texture = load(tile_data['texture'])
	description = tile_data['description']
	scene_instance = null
	cam_top_limit = tile_data['cam_top_limit']
	cam_right_limit = tile_data['cam_right_limit']
	cam_left_limit = tile_data['cam_left_limit']
	cam_bottom_limit = tile_data['cam_bottom_limit']
	
	var point
	for side in Graph.MapNode.LINK_SIDE:
		point = tile_data[side.to_lower() + '_entry_point']
		if point != null:
			self.entry_points[Graph.MapNode.LINK_SIDE.get(side)] = Vector2(point[0], point[1])
	
	point = tile_data['default_entry_point']
	self.default_entry_point = Vector2(point[0], point[1])

#region: Getters & Setters
func istantiate_scene() -> void:
	self.scene_instance = scene.instantiate()

func free_scene_instance() -> void:
	self.scene_instance.free()

func get_tile_name() -> String :
	return tile_name

func get_scene() -> PackedScene:
	return scene
	
func get_texture() -> Texture:
	return texture

func get_description() -> String:
	return description

func get_scene_instance() -> PackedScene:
	return self.scene_instance

func get_side_entry_point(side: Graph.MapNode.LINK_SIDE) -> int:
	return self.entry_points[side]

func get_default_entry_point() -> Vector2:
	return self.default_entry_point

func get_cam_top_limit() -> int:
	return cam_top_limit

func get_cam_right_limit() -> int:
	return cam_right_limit

func get_cam_bottom_limit() -> int:
	return cam_bottom_limit

func get_cam_left_limit() -> int:
	return cam_left_limit
#endregion
