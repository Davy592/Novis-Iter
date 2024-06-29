class_name Inventory

signal inventory_updated(item, index)
signal item_obtained(type, item_name, quantity)

var items : Array[Item]
#var INVENTORY_SIZE = 40 # nel caso in cui vogliamo limitare la size

func _init():
	items = []

func create(argument: String):
	var item: Item
	var item_quantity = 1
	var json_data_file = "res://resources/data/items/rewards/" + argument + ".json"
	var json_as_text = FileAccess.get_file_as_string(json_data_file)
	var item_data = JSON.parse_string(json_as_text)
	item_data['quantity'] = item_quantity
	item_data['texture'] = load(item_data['texture'])
	item = Item.new(item_data)
	Global.inventory.add(item, 1)
	Global.quest_handler.update_quests(item.name)

func add(item: Item, quantity: int):
	var index = -1
	for i in range(items.size()):
		if items[i].get_name() == item.get_name():
			index = i
	if index != -1:
		items[index].increment_quantity(quantity)
	else:
		items.append(item)
		
	# Signals
	emit_signal("inventory_updated", items[index], index)
	emit_signal("item_obtained", 1, items[index].name, quantity)

func remove_by_name(item_name: String, quantity: int):
	print("provo rimuovere")
	var index = -1
	var removed_item = null
	
	for i in range(items.size()):
		if items[i].get_name() == item_name:
			index = i
			print("trovato")
	
	if index != -1:
		items[index].decrement_quantity(quantity)
		
		if items[index].quantity != 0:
			removed_item = items[index]
			emit_signal("item_obtained", 0, removed_item.name, quantity)
	
		emit_signal("inventory_updated", removed_item, index)

func remove_by_id(id: String):
	var index = -1
	for i in range(items.size()):
		if items[i].get_id() == id:
			index = i
	if index != -1:
		items.remove_at(index)
		emit_signal("inventory_updated", null, index)

# funzione remove di default, nel caso volete cambiarla commentate e decommentate
func remove(id: String):
	remove_by_id(id)
	#remove_by_name(id)

func contains(item_name: String) -> bool:
	return contains_by_name(item_name)

func contains_by_id(item_id: String) -> bool:
	for item in items:
		if item.get_id() == item_id:
			return true
	return false

func contains_by_name(item_name: String) -> bool:
	for item in items:
		if item.get_name() == item_name:
			return true
	return false

func get_size():
	return items.size()

func get_item(index):
	return items[index]

func get_item_from_name(item_name: String) -> Item:
	for i in range(items.size()):
		if items[i].get_name() == item_name:
			return items[i]
		
	return null
	
