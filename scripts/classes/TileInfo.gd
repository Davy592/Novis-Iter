extends Node

class_name TileInfo

var tile_name
var scene
var texture
var description
var scene_instance
var entry_points = [null, null, null, null]
var default_entry_point

func _init(json_path):
	var json_as_text = FileAccess.get_file_as_string(json_path)
	var tile_data = JSON.parse_string(json_as_text)
	self.tile_name = tile_data['name']
	self.scene = load(tile_data['scene'])
	#self.texture = load(tile_data['texture'])
	self.description = tile_data['description']
	self.scene_instance = null
	var point
	for side in Graph.MapNode.LINK_SIDE:
		point = tile_data[side.to_lower() + '_entry_point']
		if point != null:
			self.entry_points[Graph.MapNode.LINK_SIDE.get(side)] = Vector2(point[0], point[1])
	point = tile_data['default_entry_point']
	self.default_entry_point = Vector2(point[0], point[1])

func get_default_entry_point():
	return self.default_entry_point

func get_side_entry_point(side: Graph.MapNode.LINK_SIDE):
	return self.entry_points[side]
	

func istantiate_scene():
	self.scene_instance = scene.instantiate()

func free_scene_instance():
	self.scene_instance.free()

func get_scene_instance():
	return self.scene_instance

func get_tile_name():
	return tile_name

func get_scene():
	return scene
	
func get_texture():
	return texture

func get_description():
	return description
