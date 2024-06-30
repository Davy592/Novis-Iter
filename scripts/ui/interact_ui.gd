extends Control

# SIGNALS REACTIONS

func _on_player_interact_ui_requested():
	visible = true

func _on_player_interact_ui_revoked():
	visible = false
