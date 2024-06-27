extends StaticBody2D
class_name InvisibilePlatform

var showing = false
var stop_animation = false

func _on_area_2d_body_entered(body):
	if stop_animation:
		return
	
	if body.is_in_group("Player") and !showing:
		showing = true
		$AnimationPlayer.play("FadeIn")
		
func _on_area_2d_body_exited(body):
	if stop_animation:
		return
	
	if body.is_in_group("Player") and showing:
		showing = false
		$AnimationPlayer.play("FadeOut")
