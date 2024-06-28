class_name Item

var id: String
var name: String
var description: String
var quantity: int
#var type: String
#var effect: String
var texture: Texture

signal stop_battle

func _init(dict):
	name = dict['id']
	name = dict['name']
	description = dict['description']
	quantity = dict['quantity']
	#type = dict['type']
	#effect = dict['effect']
	texture = dict['texture']

func get_id():
	return id

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

func decrement_quantity(n):
	if n < quantity:
		quantity -= n
	else: 
		quantity = 0

