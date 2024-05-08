extends CharacterBody2D

var MAX_SPEED = 600
var ACCELERATION = 150
var DECELERATION = 0.2
var TRESHOLD = 1
var direction = "front"
var move = "idle"

func _physics_process(delta):
	var axis = get_input_axis()
	apply_movement(axis)
	move_and_slide()
	play_animation()
	#print(velocity)

func apply_movement(axis):
	apply_acceleration(axis)
	apply_friction(axis)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_front")) - int(Input.is_action_pressed("move_back"))
	axis = axis.normalized()
	move = "walk"
	if axis.y > 0:
		direction = "front"
	elif axis.y < 0:
		direction = "back"
	elif axis.x > 0:
		direction = "right"
	elif axis.x < 0:
		direction = "left"
	else:
		move = "idle"
	return axis

func apply_acceleration(axis):
	velocity += axis * ACCELERATION
	var vel_len = velocity.length()
	velocity += int(vel_len > MAX_SPEED) * velocity.normalized() * (MAX_SPEED - vel_len)

func apply_friction(axis):
	velocity.x -= int(axis.x == 0) * velocity.x * DECELERATION
	velocity.x = int(abs(velocity.x) - TRESHOLD >= 0) * velocity.x
	velocity.y -= int(axis.y == 0) * velocity.y * DECELERATION
	velocity.y = int(abs(velocity.y) - TRESHOLD >= 0) * velocity.y

func play_animation():
	var anim = $AnimatedSprite2D
	anim.play(direction + "_" + move)
