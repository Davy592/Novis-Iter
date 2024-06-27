extends StaticBody2D

var showing = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and !showing:
		showing = true
		$AnimationPlayer.play("FadeIn")
		
func _on_area_2d_body_exited(body):
	if body.is_in_group("Player") and showing:
		showing = false
		$AnimationPlayer.play("FadeOut")
