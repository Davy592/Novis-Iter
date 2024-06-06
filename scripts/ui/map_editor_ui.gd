extends Control

enum {
	SELECT_ACTION,
	ADD_TILE_SLOT
}

var tile_slot_scene_path = preload("res://scenes/ui/tile_slot.tscn")
var tile_info_scene_path = preload("res://scenes/ui/tile_info_ui.tscn")
@onready var tiles_info_vbox = $MarginContainer/VBoxContainer/Content/ScrollContainer/VBoxContainer
@onready var map = $MarginContainer/VBoxContainer/Content/MapContainer/Map
@onready var remove_menu = $MarginContainer/CenterContainer/RemoveMenu
@onready var add_menu = $MarginContainer/CenterContainer/AddMenu
@onready var error_menu = $MarginContainer/CenterContainer/Error

var dragging = false
var last_mouse_position = Vector2()
var speed = 10
var current_tile_info_ui_pressed
var current_tile_slot_pressed
var mode = SELECT_ACTION
var current_map_node_tile_slot

func _ready():
	set_process_input(true)
	Global.tiles_inventory.tiles_inventory_updated.connect(_on_tiles_inventory_updated)

func _process(delta):
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_front")) - int(Input.is_action_pressed("move_back"))
	axis = axis.normalized() * speed
	map.position += axis 

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			dragging = true
			last_mouse_position = event.position
		else:
			dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			var mouse_delta = event.position - last_mouse_position
			last_mouse_position = event.position
			map.position += mouse_delta
	elif event is InputEventKey and not event.echo:
		if event.is_action_pressed('map'):
			get_viewport().set_input_as_handled()
			visible = false
			get_tree().paused = false
			process_mode = Node.PROCESS_MODE_DISABLED

func disable_current_map_node_tile_slot():
	current_map_node_tile_slot.get_node('CenterContainer/TileButton').pressed.disconnect(_on_tile_slot_button_pressed)

func render():
	var it = Global.map_graph.get_bfs_iterator(Global.current_tile_map_node_id)
	var data: Graph.MapNodeData
	var id
	var tile_slot
	init_tiles_inventory()
	while it.has_next():
		id = it.next()
		data = Global.map_graph.get_node_data(id)
		tile_slot = add_tile_slot_by_id(id)
		if id == Global.current_tile_map_node_id:
			current_map_node_tile_slot = tile_slot
	for child in map.get_children():
		add_empty_tile_slots(child)
	disable_current_map_node_tile_slot()
	
func add_tile_slot_by_id(id: int):
	var tile_slot = tile_slot_scene_path.instantiate()
	var data = Global.map_graph.get_node_data(id)
	var x = data.get_x()
	var y = data.get_y()
	tile_slot.set_name(str(x) + '_' + str(y))
	tile_slot.set_id(id)
	tile_slot.get_node('CenterContainer/TileButton').pressed.connect(_on_tile_slot_button_pressed)
	map.add_child(tile_slot)
	tile_slot.position = Vector2(x * tile_slot.size.x, y * tile_slot.size.y)
	tile_slot.position -= tile_slot.size / 2
	data.map_node_data_updated.connect(tile_slot._on_map_node_data_updated)
	return tile_slot

func update_tile_slot_focus(tile_slot):
	var tile_button = tile_slot.get_node('CenterContainer/TileButton')
	var slot_name = tile_slot.get_name()
	var tokens = slot_name.split('_')
	var rel_x = int(tokens[0])
	var rel_y = int(tokens[1])
	var neighbor_button
	slot_name = str(rel_x) + '_' + str(rel_y - 1)
	if map.has_node(slot_name):
		neighbor_button = map.get_node(slot_name).get_node('CenterContainer/TileButton')
		tile_button.focus_neighbor_top = neighbor_button.get_path()
		neighbor_button.focus_neighbor_bottom = tile_button.get_path()
	else:
		tile_button.focus_neighbor_top = NodePath("") # tile_button.get_path()
	slot_name = str(rel_x + 1) + '_' + str(rel_y)
	if map.has_node(slot_name):
		neighbor_button = map.get_node(slot_name).get_node('CenterContainer/TileButton')
		tile_button.focus_neighbor_right = neighbor_button.get_path()
		neighbor_button.focus_neighbor_left = tile_button.get_path()
	else:
		tile_button.focus_neighbor_right = NodePath("")
	slot_name = str(rel_x) + '_' + str(rel_y + 1)
	if map.has_node(slot_name):
		neighbor_button = map.get_node(slot_name).get_node('CenterContainer/TileButton')
		tile_button.focus_neighbor_bottom = neighbor_button.get_path()
		neighbor_button.focus_neighbor_top = tile_button.get_path()
	else:
		tile_button.focus_neighbor_bottom = NodePath("") # tile_button.get_path()
	slot_name = str(rel_x - 1) + '_' + str(rel_y)
	if map.has_node(slot_name):
		neighbor_button = map.get_node(slot_name).get_node('CenterContainer/TileButton')
		tile_button.focus_neighbor_left = neighbor_button.get_path()
		neighbor_button.focus_neighbor_right = tile_button.get_path()
	else:
		tile_button.focus_neighbor_left = NodePath("") # tile_button.get_path()

func init_tiles_inventory():
	var tile_info_ui
	var tile_info
	for index in range(Global.tiles_inventory.get_size()):
		tile_info = Global.tiles_inventory.get_tile_info_at(index)
		add_tile_info_slot(tile_info)

func add_tile_info_slot(tile_info):
	var tile_info_ui = tile_info_scene_path.instantiate()
	var tile_button = tile_info_ui.get_node('CenterContainer/TileButton')
	tile_button.pressed.connect(_on_tile_info_button_pressed)
	#item_button.focus_entered.connect(_on_item_button_focus_entered)
	tile_info_ui.set_tile_info(tile_info)
	tiles_info_vbox.add_child(tile_info_ui)

func init_focus():	
	if current_tile_info_ui_pressed and mode != ADD_TILE_SLOT:
		current_tile_info_ui_pressed.get_node('CenterContainer/TileButton').grab_focus()
		current_tile_info_ui_pressed = null
		#print('usato current_tile_info_ui_pressed')
	elif current_tile_slot_pressed:
		current_tile_slot_pressed.get_node('CenterContainer/TileButton').grab_focus()
		current_tile_slot_pressed = null
		#print('usato current_tile_slot_pressed')
	else:
		var id = Global.current_tile_map_node_id
		var data = Global.map_graph.get_node_data(id)
		var slot_name = str(data.get_x()) + '_' + str(data.get_y())
		map.get_node(slot_name + '/CenterContainer/TileButton').grab_focus()
		#print('usato id')

func link_new_tile_slot_node(tile_slot):
	var slot_name = tile_slot.get_name()
	var tokens = slot_name.split('_')
	var x = int(tokens[0])
	var y = int(tokens[1])
	var neighbor_id
	slot_name = str(x) + '_' + str(y - 1)
	if map.has_node(slot_name):
		neighbor_id = map.get_node(slot_name).map_node_id
		if neighbor_id != -1:
			Global.map_graph.add_link(tile_slot.map_node_id, neighbor_id, Graph.MapNode.LINK_SIDE.TOP)
	slot_name = str(x + 1) + '_' + str(y)
	if map.has_node(slot_name):
		neighbor_id = map.get_node(slot_name).map_node_id
		if neighbor_id != -1:
			Global.map_graph.add_link(tile_slot.map_node_id, neighbor_id, Graph.MapNode.LINK_SIDE.RIGHT)
	slot_name = str(x) + '_' + str(y + 1)
	if map.has_node(slot_name):
		neighbor_id = map.get_node(slot_name).map_node_id
		if neighbor_id != -1:
			Global.map_graph.add_link(tile_slot.map_node_id, neighbor_id, Graph.MapNode.LINK_SIDE.BOTTOM)
	slot_name = str(x - 1) + '_' + str(y)
	if map.has_node(slot_name):
		neighbor_id = map.get_node(slot_name).map_node_id
		if neighbor_id != -1:
			Global.map_graph.add_link(tile_slot.map_node_id, neighbor_id, Graph.MapNode.LINK_SIDE.LEFT)	

func add_tile_slot_by_coordinates(x, y):
	var tile_slot = tile_slot_scene_path.instantiate()
	var slot_name = str(x) + '_' + str(y)
	
	if not map.has_node(slot_name):
		tile_slot.set_name(slot_name)
		tile_slot.set_id(-1)
		tile_slot.get_node('CenterContainer/TileButton').pressed.connect(_on_tile_slot_button_pressed)
		map.add_child(tile_slot)
		tile_slot.position = Vector2(x * tile_slot.size.x, y * tile_slot.size.y)
		tile_slot.position -= tile_slot.size / 2

func add_empty_tile_slots(tile_slot):
	var id = tile_slot.map_node_id
	var data = Global.map_graph.get_node_data(id)
	var x = data.get_x()
	var y = data.get_y()
	
	add_tile_slot_by_coordinates(x, y - 1)
	add_tile_slot_by_coordinates(x + 1, y)
	add_tile_slot_by_coordinates(x, y + 1)
	add_tile_slot_by_coordinates(x - 1, y)

func increment_all_around(tile_slot):
	var tile_button = tile_slot.get_node('CenterContainer/TileButton')
	var slot_name = tile_slot.get_name()
	var tokens = slot_name.split('_')
	var rel_x = int(tokens[0])
	var rel_y = int(tokens[1])
	var neighbor_slot
	slot_name = str(rel_x) + '_' + str(rel_y - 1)
	if map.has_node(slot_name):
		neighbor_slot = map.get_node(slot_name)
		neighbor_slot.increment_owners_counter()
	slot_name = str(rel_x + 1) + '_' + str(rel_y)
	if map.has_node(slot_name):
		neighbor_slot = map.get_node(slot_name)
		neighbor_slot.increment_owners_counter()
	slot_name = str(rel_x) + '_' + str(rel_y + 1)
	if map.has_node(slot_name):
		neighbor_slot = map.get_node(slot_name)
		neighbor_slot.increment_owners_counter()
	slot_name = str(rel_x - 1) + '_' + str(rel_y)
	if map.has_node(slot_name):
		neighbor_slot = map.get_node(slot_name)
		neighbor_slot.increment_owners_counter()
	tile_slot.increment_owners_counter()

func get_slot_name_by_id(id):
	var data = Global.map_graph.get_node_data(id)
	var x = data.get_x()
	var y = data.get_y()
	return str(x) + '_' + str(y) 

func decrement_all_around(tile_slot):
	var tile_button = tile_slot.get_node('CenterContainer/TileButton')
	var slot_name = tile_slot.get_name()
	var tokens = slot_name.split('_')
	var rel_x = int(tokens[0])
	var rel_y = int(tokens[1])
	var neighbor_slot
	slot_name = str(rel_x) + '_' + str(rel_y - 1)
	if map.has_node(slot_name):
		neighbor_slot = map.get_node(slot_name)
		neighbor_slot.decrement_owners_counter()
		if neighbor_slot.owners_counter < 1:
			map.remove_child(neighbor_slot)
	slot_name = str(rel_x + 1) + '_' + str(rel_y)
	if map.has_node(slot_name):
		neighbor_slot = map.get_node(slot_name)
		neighbor_slot.decrement_owners_counter()
		if neighbor_slot.owners_counter < 1:
			map.remove_child(neighbor_slot)
	slot_name = str(rel_x) + '_' + str(rel_y + 1)
	if map.has_node(slot_name):
		neighbor_slot = map.get_node(slot_name)
		neighbor_slot.decrement_owners_counter()
		if neighbor_slot.owners_counter < 1:
			map.remove_child(neighbor_slot)
	slot_name = str(rel_x - 1) + '_' + str(rel_y)
	if map.has_node(slot_name):
		neighbor_slot = map.get_node(slot_name)
		neighbor_slot.decrement_owners_counter()
		if neighbor_slot.owners_counter < 1:
			map.remove_child(neighbor_slot)
	tile_slot.decrement_owners_counter()
	if tile_slot.owners_counter < 1:
		map.remove_child(tile_slot)

func _on_player_map_requested():
	visible = true
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	init_focus()

func _on_tile_slot_button_pressed():
	var tile_slot_pressed = get_viewport().gui_get_focus_owner().get_parent().get_parent()
	match mode:
		SELECT_ACTION:
			if tile_slot_pressed.map_node_id != -1:
				remove_menu.visible = true
				remove_menu.get_child(0).grab_focus()
				current_tile_slot_pressed = tile_slot_pressed
		ADD_TILE_SLOT:
			var new_tile_info = current_tile_info_ui_pressed.get_tile_info()
			var map_node_id = tile_slot_pressed.map_node_id
			new_tile_info.istantiate_scene()
			if map_node_id != -1:
				var data = Global.map_graph.get_node_data(map_node_id)
				var old_tile_info = data.get_tile_info()
				old_tile_info.free_scene_instance()
				Global.tiles_inventory.add(old_tile_info)
				data.set_tile_info(new_tile_info)
			else:
				increment_all_around(tile_slot_pressed)
				var slot_name = tile_slot_pressed.get_name()
				var tokens = slot_name.split('_')
				var x = int(tokens[0])
				var y = int(tokens[1])
				var id = Global.map_graph.add_node(Graph.MapNodeData.new(new_tile_info, x, y))
				tile_slot_pressed.set_id(id)
				add_empty_tile_slots(tile_slot_pressed)
				link_new_tile_slot_node(tile_slot_pressed)
			Global.tiles_inventory.remove(current_tile_info_ui_pressed.get_index())
			mode = SELECT_ACTION
			current_tile_info_ui_pressed = null
			init_focus()

func _on_tile_info_button_pressed():
	current_tile_info_ui_pressed = get_viewport().gui_get_focus_owner().get_parent().get_parent()
	add_menu.visible = true
	add_menu.get_child(0).grab_focus()

func _on_tiles_inventory_updated(tile_info, index):
	if index != -1:
		tiles_info_vbox.remove_child(tiles_info_vbox.get_child(index))
	else:
		add_tile_info_slot(tile_info)

func _on_cancel_button_pressed():
	add_menu.visible = false
	remove_menu.visible = false
	mode = SELECT_ACTION
	init_focus()

func _on_use_button_pressed():
	add_menu.visible = false
	mode = ADD_TILE_SLOT
	init_focus()

func _on_map_graph_current_map_node_updated():
	current_map_node_tile_slot.get_node('CenterContainer/TileButton').pressed.connect(_on_tile_slot_button_pressed)
	current_map_node_tile_slot = map.get_node(str(Global.current_tile_map_node_id))
	current_map_node_tile_slot.get_node('CenterContainer/TileButton').pressed.disconnect(_on_tile_slot_button_pressed)

func _on_remove_button_pressed():
	var map_node_id = current_tile_slot_pressed.map_node_id
	var data = Global.map_graph.get_node_data(map_node_id)
	var tile_info = data.get_tile_info()
	
	if not Global.map_graph.is_node_a_bridge(map_node_id):
		tile_info.free_scene_instance()
		current_tile_slot_pressed.set_id(-1)
		Global.map_graph.remove_node(map_node_id)
		Global.tiles_inventory.add(tile_info)
		decrement_all_around(current_tile_slot_pressed)
		init_focus()
	else:
		error_menu.visible = true
		error_menu.get_node('Ok').grab_focus()
		
	remove_menu.visible = false

func _on_map_child_entered_tree(node):
	call_deferred('update_tile_slot_focus', node)
	pass

func _on_map_child_exiting_tree(node):
	var tile_button = node.get_node('CenterContainer/TileButton')
	var top_neighbor = tile_button.focus_neighbor_top
	var right_neighbor = tile_button.focus_neighbor_right
	var bottom_neighbor = tile_button.focus_neighbor_bottom
	var left_neighbor = tile_button.focus_neighbor_left
	
	if top_neighbor:
		top_neighbor = map.get_node(top_neighbor)
		top_neighbor.focus_neighbor_bottom = NodePath("")
	if right_neighbor:
		right_neighbor = map.get_node(right_neighbor)
		right_neighbor.focus_neighbor_left = NodePath("")
	if bottom_neighbor:
		bottom_neighbor = map.get_node(bottom_neighbor)
		bottom_neighbor.focus_neighbor_top = NodePath("")
	if left_neighbor:
		left_neighbor = map.get_node(left_neighbor)
		left_neighbor.focus_neighbor_right = NodePath("")

func _on_ok_pressed():
	error_menu.visible = false
	init_focus()
