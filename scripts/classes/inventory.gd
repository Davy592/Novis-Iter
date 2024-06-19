class_name Inventory

signal inventory_updated(item, index)

var items
#var INVENTORY_SIZE = 40 # nel caso in cui vogliamo limitare la size

func _init():
	items = []

func add(item: Item):
	var index = -1
	for i in range(items.size()):
		if items[i].get_name() == item.get_name():
			index = i
	if index != -1:
		items[index].increment_quantity(1)
	else:
		items.append(item)
	emit_signal("inventory_updated", items[index], index)

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
