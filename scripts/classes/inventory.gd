class_name Inventory

signal inventory_updated(item, index)
signal item_obtained(type, item_name, quantity)

var items : Array[Item]
#var INVENTORY_SIZE = 40 # nel caso in cui vogliamo limitare la size

func _init():
	items = []

<<<<<<< HEAD
func add(item: Item, quantity: int):
=======
func add(item: Item):
>>>>>>> 477632daca9566ad8fe7a2eef88853d17bd776ad
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

func remove_by_name(item_name: String):
	var index = -1
	for i in range(items.size()):
		if items[i].get_name() == item_name:
			index = i
	if index != -1:
		items.remove_at(index)
		emit_signal("inventory_updated", null, index)

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
	
