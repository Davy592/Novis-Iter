extends NPC

func check_current_stage():
	if quest.stage == 10:
		$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
		print("ora scompare")

func _on_screen_exited():
	position = Vector2(0, 0)
	$VisibleOnScreenNotifier2D.screen_exited.disconnect(_on_screen_exited)
	print("ora non piú")
