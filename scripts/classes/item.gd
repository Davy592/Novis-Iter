class_name Item

var name
var description
var quantity
var type
var effect
var texture: Texture

signal stop_battle

func _init(dict):
	name = dict['name']
	description = dict['description']
	quantity = dict['quantity']
	type = dict['type']
	effect = dict['effect']
	texture = dict['texture']

func get_name():
	return name

func get_description():
	return description

func get_texture():
	return texture
	
func get_quantity():
	return quantity

func increment_quantity(n):
	quantity += n

func use_item(name):
	match name:
		"flag":
			Dialogic.VAR.battle = false
			emit_signal("stop_battle")
