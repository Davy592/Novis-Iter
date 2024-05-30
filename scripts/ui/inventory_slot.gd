extends Control

var item = null

func set_item(item):
	self.item = item
	update_slot_info()

func update_slot_info():
	$CenterContainer/Background/ItemIcon.texture = item.get_texture()
	$CenterContainer/Background/ItemQuantity.text = str(item.get_quantity())

func get_item_in_slot():
	return item
