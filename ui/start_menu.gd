extends "res://ui/menu.gd"

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

func _on_load_game_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
