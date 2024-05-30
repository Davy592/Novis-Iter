extends Control

# OVERRIDES

func _ready():
	$MarginContainer/VBoxContainer/MenuEntries/NewGame.grab_focus()

# SIGNALS REACTIONS

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/tiles/tile_layout.tscn")

func _on_load_game_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
