extends Control

# OVERRIDES

func _input(event):
	if event is InputEventKey and not event.echo:
		if event.is_action_pressed('menu'):
			get_viewport().set_input_as_handled()
			_on_play_pressed()

# SIGNALS REACTIONS

func _on_player_menu_requested():
	visible = true
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_play_pressed():
	visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_exit_pressed():
	get_tree().quit()

func _on_visibility_changed():
	if visible:
		$MarginContainer/VBoxContainer/MenuEntries/Play.grab_focus()
