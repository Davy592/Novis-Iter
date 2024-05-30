extends Node

func _ready():
	$Player.menu_requested.connect($CanvasLayer/InGameMenu._on_player_menu_requested)
	$Player.inventory_requested.connect($CanvasLayer/InventoryUI._on_player_inventory_requested)
	$Player.interact_ui_requested.connect($CanvasLayer/InteractUI._on_player_interact_ui_requested)
	$Player.interact_ui_revoked.connect($CanvasLayer/InteractUI._on_player_interact_ui_revoked)
