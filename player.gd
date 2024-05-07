extends CharacterBody2D

var MAX_SPEED = 600
var ACCELERATION = 150
var DECELERATION = ACCELERATION * 0.3
var direction = "front"

func _physics_process(delta):
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_front")) - int(Input.is_action_pressed("move_back"))
	axis = axis.normalized()
	velocity += axis * ACCELERATION
	#velocity *= 0.8
	#velocity -= velocity * 0.1
	#velocity -= velocity.normalized() * DECELERATION
	#if velocity.length() > MAX_SPEED:
		#velocity = velocity.normalized() * MAX_SPEED
	apply_friction()
	move_and_slide()
	play_animation(axis)
	print(velocity)

func play_animation(axis):
	var anim = $AnimatedSprite2D
	if axis.y > 0:
		anim.play("front_walk")
		direction = "front"
	elif axis.y < 0:
		anim.play("back_walk")
		direction = "back"
	elif axis.x > 0:
		anim.play("right_walk")
		direction = "right"
	elif axis.x < 0:
		anim.play("left_walk")
		direction = "left"
	else:
		anim.play(direction + "_idle")

func apply_friction():
	if velocity.x < 0:
		velocity.x += DECELERATION
		velocity.x = clamp(velocity.x, -MAX_SPEED, 0)
	else:
		velocity.x -= DECELERATION
		velocity.x = clamp(velocity.x, 0, MAX_SPEED)
	if velocity.y < 0:
		velocity.y += DECELERATION
		velocity.y = clamp(velocity.y, -MAX_SPEED, 0)
	else:
		velocity.y -= DECELERATION
		velocity.y = clamp(velocity.y, 0, MAX_SPEED)
