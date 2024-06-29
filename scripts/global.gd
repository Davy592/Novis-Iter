extends Node

var quest_handler: QuestHandler = QuestHandler.new()
var inventory: Inventory = Inventory.new()
var current_tile_map_node_id: int
var tiles_inventory: TilesInventory = TilesInventory.new()
var map_graph: Graph = Graph.new()
var dialogue_manager: DialogueManager = DialogueManager.new()
var hubs_clues = {}
var caso: String
var remy_follow = false
var remy_tile = "tile1"
var battle_on = true

signal current_map_node_updated
signal stop_battle

func _ready():
	var current_tile_info = TileInfo.new("res://resources/data/hub1.json")
	var main_node = get_tree().get_root().get_node('Main')
	current_tile_map_node_id = map_graph.add_node(Graph.MapNodeData.new(current_tile_info, 0, 0))
	Dialogic.timeline_ended.connect(dialogue_manager._on_timeline_ended)
	
func set_clue(key, value):
	hubs_clues[key] = value

func get_clue(key):
	return hubs_clues.get(key, false)
	
var player
var tile_name
func change_current_tile(tile: TileInfo, side, id):
	var main_node = get_tree().get_root().get_node('Main')
	var tile_instance = tile.get_scene_instance()
	tile_name = tile_instance.get_name()
	player = main_node.get_node('Player')
	var remy = main_node.get_node('remy')
	#player.position = Vector2(0, 0) # se non lo fai quando ci ritorna si ritrova nella porta e richiama il cambio mappa
	#disconnect_current_tile_signals()
	main_node.remove_child(main_node.get_node('CurrentTile'))
	print(tile_name)
	player.position = tile.get_side_entry_point(side)
	print("Qui lo trovo a " + str(remy_follow))
	if remy_follow:
		remy_tile = tile_name
		remy.position = player.position
		print("1")
	else:
		if tile_name != remy_tile:
			remy.visible = false
			print("2")
			remy.get_node("DialogueActionable").set_collision_layer(8)
			remy.get_node("DialogueActionable").set_collision_layer(8)
		else:
			remy.visible = true
			print("3")
			remy.get_node("DialogueActionable").set_collision_layer(2)
			remy.get_node("DialogueActionable").set_collision_layer(2)
	tile_instance.set_name('CurrentTile')
	main_node.add_child(tile_instance)
	#connect_current_tile_signals()

	current_tile_map_node_id = id
	current_map_node_updated.emit()
	
	set_camera_limits(
		player, 
		tile.get_cam_top_limit(), 
		tile.get_cam_right_limit(), 
		tile.get_cam_bottom_limit(), 
		tile.get_cam_left_limit()
	)

func set_camera_limits(
	player: CharacterBody2D, 
	top_limit: int, right_limit: int, 
	bottom_limit: int, left_limit: int
):
	var camera: Camera2D = player.get_node('Camera2D')
	
	camera.limit_top = top_limit
	camera.limit_right = right_limit
	camera.limit_bottom = bottom_limit
	camera.limit_left = left_limit
	
func use_item(name: String):
	match name:
		"Bandiera":
			print("bandiera")
			Dialogic.VAR.battle = false
			emit_signal("stop_battle")
			battle_on = false
	
	
#func add_item_by_json_path(path):
	#var file = FileAccess.open(path, FileAccess.READ)
	#var json_as_text = file.get_as_text()
	#var item_data = JSON.parse_string(json_as_text)
	#item_data['quantity'] = 1
	#item_data['texture'] = load(item_data['texture'])
	#inventory.add(Item.new(item_data))

#func connect_current_tile_signals():
	#var player_node = get_tree().get_root().get_node('Main/Player') #Main/CurrentTile/
	#var in_game_menu = get_tree().get_root().get_node('Main/CanvasLayer/InGameMenu')
	#var inventory_ui = get_tree().get_root().get_node('Main/CanvasLayer/InventoryUI')
	#var interact_ui = get_tree().get_root().get_node('Main/CanvasLayer/InteractUI')
	#var map_ui = get_tree().get_root().get_node('Main/CanvasLayer/MapEditor')
	#player_node.menu_requested.connect(in_game_menu._on_player_menu_requested)
	#player_node.inventory_requested.connect(inventory_ui._on_player_inventory_requested)
	#player_node.interact_ui_requested.connect(interact_ui._on_player_interact_ui_requested)
	#player_node.interact_ui_revoked.connect(interact_ui._on_player_interact_ui_revoked)
	#
	#player_node.map_requested.connect(map_ui._on_player_map_requested)
#
#func disconnect_current_tile_signals():
	#var player_node = get_tree().get_root().get_node('Main/Player')
	#var in_game_menu = get_tree().get_root().get_node('Main/CanvasLayer/InGameMenu')
	#var inventory_ui = get_tree().get_root().get_node('Main/CanvasLayer/InventoryUI')
	#var interact_ui = get_tree().get_root().get_node('Main/CanvasLayer/InteractUI')
	#var map_ui = get_tree().get_root().get_node('Main/CanvasLayer/MapEditor')
	#player_node.menu_requested.disconnect(in_game_menu._on_player_menu_requested)
	#player_node.inventory_requested.disconnect(inventory_ui._on_player_inventory_requested)
	#player_node.interact_ui_requested.disconnect(interact_ui._on_player_interact_ui_requested)
	#player_node.interact_ui_revoked.disconnect(interact_ui._on_player_interact_ui_revoked)
	#
	#player_node.map_requested.disconnect(map_ui._on_player_map_requested)
