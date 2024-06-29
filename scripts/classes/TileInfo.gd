extends Node

class_name TileInfo

var tile_name
var scene
var texture
var description
var scene_instance
var entry_points = [null, null, null, null]
var default_entry_point
var cam_top_limit
var cam_right_limit
var cam_left_limit
var cam_bottom_limit
var condition
var key_exits

func _init(json_path):
	var json_as_text = FileAccess.get_file_as_string(json_path)
	var tile_data = JSON.parse_string(json_as_text)
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
	self.condition = tile_data['condition_script']
	if self.condition != null:
		self.condition = ResourceLoader.load(self.condition).new()
		assert(self.condition.has_method("is_condition_satisfied"), "TileInfo: condition has no method named is_condition_satisfied()")
	self.key_exits = tile_data['key_exits']

func get_key_exit(side: Graph.MapNode.LINK_SIDE):
	return self.key_exits[side]

func is_condition_satisfied():
	return self.condition == null or self.condition.is_condition_satisfied()

func get_default_entry_point():
	return self.default_entry_point

func get_side_entry_point(side: Graph.MapNode.LINK_SIDE):
	return self.entry_points[side]
	
func get_cam_top_limit():
	return cam_top_limit

func get_cam_right_limit():
	return cam_right_limit

func get_cam_bottom_limit():
	return cam_bottom_limit

func get_cam_left_limit():
	return cam_left_limit

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
