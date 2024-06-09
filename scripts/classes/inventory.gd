class_name Inventory

signal inventory_updated(item, index)

var items
#var INVENTORY_SIZE = 40 # nel caso in cui vogliamo limitare la size

func _init():
	items = []

func add(item):
	var index = -1
	for i in range(items.size()):
		if items[i].get_name() == item.get_name():
			index = i
	if index != -1:
		items[index].increment_quantity(1)
	else:
		items.append(item)
	emit_signal("inventory_updated", items[index], index)

func get_size():
	return items.size()

func get_item(index):
	return items[index]
