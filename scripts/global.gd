extends Node

var inventory: Inventory = Inventory.new()

func _ready():
	connect_current_tile_signals()
	# debug per vedere se funziona
	#change_current_tile(load("res://scenes/tiles/tile_5.tscn").instantiate())

func connect_current_tile_signals():
	var player_node = get_tree().get_root().get_node('Main/CurrentTile/Player')
	var in_game_menu = get_tree().get_root().get_node('Main/CanvasLayer/InGameMenu')
	var inventory_ui = get_tree().get_root().get_node('Main/CanvasLayer/InventoryUI')
	var interact_ui = get_tree().get_root().get_node('Main/CanvasLayer/InteractUI')
	player_node.menu_requested.connect(in_game_menu._on_player_menu_requested)
	player_node.inventory_requested.connect(inventory_ui._on_player_inventory_requested)
	player_node.interact_ui_requested.connect(interact_ui._on_player_interact_ui_requested)
	player_node.interact_ui_revoked.connect(interact_ui._on_player_interact_ui_revoked)

func disconnect_current_tile_signals():
	var player_node = get_tree().get_root().get_node('Main/CurrentTile/Player')
	var in_game_menu = get_tree().get_root().get_node('Main/CanvasLayer/InGameMenu')
	var inventory_ui = get_tree().get_root().get_node('Main/CanvasLayer/InventoryUI')
	var interact_ui = get_tree().get_root().get_node('Main/CanvasLayer/InteractUI')
	player_node.menu_requested.disconnect(in_game_menu._on_player_menu_requested)
	player_node.inventory_requested.disconnect(inventory_ui._on_player_inventory_requested)
	player_node.interact_ui_requested.disconnect(interact_ui._on_player_interact_ui_requested)
	player_node.interact_ui_revoked.disconnect(interact_ui._on_player_interact_ui_revoked)

func change_current_tile(tile):
	var main_node = get_tree().get_root().get_node('Main')
	disconnect_current_tile_signals()
	main_node.remove_child(main_node.get_node('CurrentTile'))
	tile.set_name('CurrentTile')
	main_node.add_child(tile)
	connect_current_tile_signals()
