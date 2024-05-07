extends CharacterBody2D

var MAX_SPEED = 500
var ACCELERATION = 2000000000
var dir = "down"
var axis

func _physics_process(delta):
	axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
		play_anim(false)
	else:
		apply_movement(axis * ACCELERATION * delta)
		play_anim(true)
	move_and_slide()


func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if axis.y > 0:
		dir = "down"
	elif axis.y < 0:
		dir = "up"
	elif axis.x > 0:
		dir = "right"
	elif axis.x < 0:
		dir = "left"
	return axis.normalized()


func apply_friction(deceleration):
	if velocity.x < 0:
		velocity.x += deceleration
		velocity.x = clamp(velocity.x, -MAX_SPEED, 0)
	else:
		velocity.x -= deceleration
		velocity.x = clamp(velocity.x, 0, MAX_SPEED)
	if velocity.y < 0:
		velocity.y += deceleration
		velocity.y = clamp(velocity.y, -MAX_SPEED, 0)
	else:
		velocity.y -= deceleration
		velocity.y = clamp(velocity.y, 0, MAX_SPEED)
	print(velocity)


func apply_movement(acceleration):
	velocity = Vector2.ZERO
	velocity += acceleration
	velocity = velocity.clamp(Vector2(-MAX_SPEED, -MAX_SPEED), Vector2(MAX_SPEED, MAX_SPEED))
	#velocity = velocity.normalized() * MAX_SPEED
	print(velocity)


func play_anim(movement):
	var anim = $AnimatedSprite2D
	if movement:
		if dir == "down":
			anim.play("front_walk")
		elif dir == "up":
			anim.play("back_walk")
		elif dir == "right":
			anim.play("right_walk")
		elif dir == "left":
			anim.play("left_walk")
	else:
		if dir == "down":
			anim.play("front_idle")
		elif dir == "up":
			anim.play("back_idle")
		elif dir == "right":
			anim.play("right_idle")
		elif dir == "left":
			anim.play("left_idle")
