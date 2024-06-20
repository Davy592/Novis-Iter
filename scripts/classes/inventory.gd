class_name Inventory

signal inventory_updated(item, index)
signal item_obtained(type, item_name, quantity)

var items : Array[Item]
#var INVENTORY_SIZE = 40 # nel caso in cui vogliamo limitare la size

func _init():
	items = []

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

func remove(item: Item, quantity: int):
	var index = -1
	for i in range(items.size()):
		if items[i].get_name() == item.get_name():
			index = i
	
	if index != -1:
		items[index].decrement_quantity(quantity)
	
	emit_signal("inventory_updated", items[index], index)
	emit_signal("item_obtained", 0, items[index].name, quantity)

func get_size():
	return items.size()

func get_item(index):
	return items[index]

func get_item_from_name(item_name: String) -> Item:
	for i in range(items.size()):
		if items[i].get_name() == item_name:
			return items[i]
		
	return null
	
