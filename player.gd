extends CharacterBody2D

var speed = 400
var angular_speed = PI

var current_dir = "None"

func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		play_anim(4)
		velocity += Vector2.LEFT * speed
	elif Input.is_action_pressed("ui_right"):
		play_anim(3)
		velocity += Vector2.RIGHT * speed
	if Input.is_action_pressed("ui_up"):
		play_anim(1)
		velocity += Vector2.UP * speed
	elif Input.is_action_pressed("ui_down"):
		play_anim(2)
		velocity += Vector2.DOWN * speed

	position += velocity * delta

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	match movement:
		1:
			anim.flip_h=false
			anim.play("back_walk")
		2:
			anim.flip_h=false
			anim.play("front_walk")
		3:
			anim.flip_h=false
			anim.play("side_walk")
		4:
			anim.flip_h=true
			anim.play("side_walk")
