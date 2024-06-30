extends Node2D

@export var item_quantity = 1
@export_file("*.json") var json_data_file
var item: Item

## Istanzia l'item, acquisendo i dati corrispondenti dal file 
## JSON specificato, e assegna la texture al nodo "Sprite2D".
func _ready():
	var json_as_text = FileAccess.get_file_as_string(json_data_file)
	var item_data = JSON.parse_string(json_as_text)
	
	item_data['quantity'] = item_quantity
	item_data['texture'] = load(item_data['texture'])
	item = Item.new(item_data)
	
	if not Engine.is_editor_hint():
		$Sprite2D.texture = item_data['texture']

## Aggiunge l'item all'inventario e aggiorna le quest interessate.
func action() -> void:
	Global.inventory.add(item, 1)
	Global.quest_handler.update_quests(item.name)
	self.queue_free()
