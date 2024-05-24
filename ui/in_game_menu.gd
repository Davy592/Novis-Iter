extends "res://ui/menu.gd"

# Non so se lasciarla o meno. Non eliminatela
#func _process(delta):
	#super._process(delta)
	#if Input.is_action_just_pressed("menu"):
		#_on_play_pressed()

func _on_player_menu_requested():
	get_tree().paused = true
	visible = true

func _on_play_pressed():
	get_tree().paused = false
	visible = false

func _on_exit_pressed():
	get_tree().quit()
