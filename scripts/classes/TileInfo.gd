extends Node

class_name TileInfo

var tile_name
var scene
var texture
var description
var scene_instance

func _init(json_path):
	var json_as_text = FileAccess.get_file_as_string(json_path)
	var tile_data = JSON.parse_string(json_as_text)
	self.tile_name = tile_data['name']
	self.scene = load(tile_data['scene'])
	#self.texture = load(tile_data['texture'])
	self.description = tile_data['description']
	self.scene_instance = null

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
