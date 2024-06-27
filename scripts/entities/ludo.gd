extends NPC
class_name Ludo

func check_current_stage():
	match quest.stage: 
		10:
			pass
		100:
			$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _on_screen_exited():
	position = Vector2(0, 0)
	$VisibleOnScreenNotifier2D.screen_exited.disconnect(_on_screen_exited)
