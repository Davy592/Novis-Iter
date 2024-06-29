extends Control

@onready var grid = $MarginContainer/VBoxContainer/Content/ScrollContainer/GridContainer
@onready var inventory_slot_scene = preload("res://scenes/ui/inventory_slot.tscn")
var selectioned_slot

# OVERRIDES

func _ready():
	Global.inventory.inventory_updated.connect(_on_inventory_updated)
	for i in range(0, Global.inventory.get_size()):
		add_slot(Global.inventory.get_item(i))

func _input(event):
	if event is InputEventKey and not event.echo:
		if event.is_action_pressed('ui_inventory'):
			get_viewport().set_input_as_handled()
			visible = false
			get_tree().paused = false
			process_mode = Node.PROCESS_MODE_DISABLED

# SIGNALS REACTIONS

func _on_visibility_changed():	
	if visible and grid.get_child_count() > 0:
		grid.get_child(0).get_node('CenterContainer/ItemButton').grab_focus()

func _on_player_inventory_requested():
	visible = true
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_inventory_updated(item, index):
	if index != -1:
		if item != null:
			var slot = grid.get_child(index)
			slot.update_slot_info()
		else:
			grid.remove_child(grid.get_child(index))
	else:
		add_slot(item)

func add_slot(item):
	var slot = inventory_slot_scene.instantiate()
	var item_button = slot.get_node('CenterContainer/ItemButton')
	item_button.pressed.connect(_on_inventory_slot_pressed)
	item_button.focus_entered.connect(_on_item_button_focus_entered)
	slot.set_item(item)
	grid.add_child(slot)

func _on_item_button_focus_entered():
	var ItemSprite = $MarginContainer/VBoxContainer/Content/ItemSection/Container/ItemSprite
	var ItemDescription = $MarginContainer/VBoxContainer/Content/ItemSection/MarginContainer/ItemDescription
	var slot = get_viewport().gui_get_focus_owner().get_parent().get_parent()
	ItemSprite.texture = slot.item.get_texture()
	ItemDescription.text = slot.item.get_description()

func _on_inventory_slot_pressed():
	selectioned_slot = get_viewport().gui_get_focus_owner().get_parent().get_parent()
	$MarginContainer/CenterContainer.visible = true
	$MarginContainer/CenterContainer/UsageContainer/UseButton.grab_focus()	

func _on_use_button_pressed(): #TODO: ATTUALMENTE TUTTI GLI ITEM USATI SINGOLI SONO CONSUMABILI
	#print("Item usato")
	var item: Item
	item = selectioned_slot.get_item_in_slot()
	var name = item.get_name()
	Global.inventory.remove_by_name(name, 1)
	Global.use_item(name)
	_on_cancel_button_pressed()

func _on_cancel_button_pressed():
	$MarginContainer/CenterContainer.visible = false
	selectioned_slot.get_node('CenterContainer/ItemButton').grab_focus()
