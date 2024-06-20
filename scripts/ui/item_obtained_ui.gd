extends Control

var color_rect : ColorRect
var label : Label
var timer : Timer

func _ready():
	Global.inventory.item_obtained.connect(_on_item_obtained)
	color_rect = $ColorRect
	label = $ColorRect/Label
	timer = $Timer
	
func _on_item_obtained(type: int, item_name: String, quantity: int):
	if type == 0:
		if visible:
			label.text += "\n" + item_name + " - " + str(quantity)
		else:
			label.text = item_name + " - " + str(quantity)
	else:
		if visible:
			label.text += "\n" + item_name + " + " + str(quantity)
		else:	
			label.text += item_name+ " + " + str(quantity)
	
	visible = true
	timer.start()

func _on_timer_timeout():
	visible = false
	label.text = ""
