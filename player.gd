extends CharacterBody2D

var MAX_SPEED = 600
var ACCELERATION = 150
var DECELERATION = ACCELERATION * 0.002 #si potrebbe inserire il "regolarizzatore" in un altra parte della formula, se non si "regolarizza" la convergenza verso lo 0 è troppo fast e si incomincia a ballare attorno a 0 (stile learning rate troppo alto)
var TRESHOLD = 1
var direction = "front"
var move = "idle"

func _physics_process(delta):
	var axis = get_input_axis()
	apply_movement(axis)
	move_and_slide()
	play_animation()
	print(velocity)


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
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED


func apply_friction(axis):
	#AAAAAA i draghi
	velocity.x -= int(axis.x == 0) * velocity.x * DECELERATION
	velocity.x = int(abs(velocity.x) - TRESHOLD >= 0) * velocity.x #pone velocity a 0 se non è in un intervallo compreso fra <[-inf, -tres], [tres, inf]>
	velocity.y -= int(axis.y == 0) * velocity.y * DECELERATION
	velocity.y = int(abs(velocity.y) - TRESHOLD >= 0) * velocity.y

	#roba vecchia (che pero funzia na meraviglia eh)
	#if velocity.x < 0:
		#velocity.x += DECELERATION
		#velocity.x = clamp(velocity.x, -MAX_SPEED, 0)
	#else:
		#velocity.x -= DECELERATION
		#velocity.x = clamp(velocity.x, 0, MAX_SPEED)
	#if velocity.y < 0:
		#velocity.y += DECELERATION
		#velocity.y = clamp(velocity.y, -MAX_SPEED, 0)
	#else:
		#velocity.y -= DECELERATION
		#velocity.y = clamp(velocity.y, 0, MAX_SPEED)
		
	#I draghi di prima ma cerco di farlo oneline
	#velocity -= ((-(axis.abs().sign()))+Vector2.ONE) * velocity * DECELERATION #a regola questa è giusta
	#velocity = velocity * int(!velocity.is_zero_approx()) #questa non lo è perche approssima solo se il vettore è vicino a zero,
														  #ossia se entrambe le componenti sono prossime a zero (e in piu approssima poco senza poter scegliere treshold)


func play_animation():
	var anim = $AnimatedSprite2D
	anim.play(direction + "_" + move)
