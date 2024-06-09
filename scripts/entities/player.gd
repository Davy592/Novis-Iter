extends CharacterBody2D

signal map_requested
signal menu_requested
signal inventory_requested
signal interact_ui_requested
signal interact_ui_revoked

enum {
	MOVE,
	INTERACTING,
	#MAP, # inutili se in questo stato il gioco è in pausa, altrimenti utili
	#MENU # inutili se in questo stato il gioco è in pausa, altrimenti utili
}

var MAX_SPEED = 600
var ACCELERATION = 150
var DECELERATION = 0.2
var TRESHOLD = 1
var direction = "front"
var move = "idle"
var state = MOVE
@onready var actionable_finder = $Direction/ActionableFinder

# OVERRIDES

func _ready():
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.timeline_started.connect(_on_timeline_started)

func _physics_process(delta):
	match state:
		MOVE:
			var axis = get_input_axis()
			apply_movement(axis)
			move_and_slide()
			play_animation()

func _input(event):
	if event is InputEventKey and not event.echo and state == MOVE:
		if event.is_action_pressed('ui_inventory'):
			get_viewport().set_input_as_handled()
			emit_signal('inventory_requested')
		elif event.is_action_pressed('menu'):
			get_viewport().set_input_as_handled()
			emit_signal('menu_requested')
		elif event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			var actionables = actionable_finder.get_overlapping_areas()
			if actionables.size() > 0:
				actionables[0].action()
		elif event.is_action_pressed('map'):
			get_viewport().set_input_as_handled()
			emit_signal('map_requested')

# USER DEFINED

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
		$Direction.rotation_degrees = 0
	elif axis.y < 0:
		direction = "back"
		$Direction.rotation_degrees = 180
	elif axis.x > 0:
		direction = "right"
		$Direction.rotation_degrees = -90
	elif axis.x < 0:
		direction = "left"
		$Direction.rotation_degrees = 90
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

# SIGNALS REACTIONS

func _on_timeline_started():
	state = INTERACTING

func _on_timeline_ended():
	state = MOVE

func _on_actionable_finder_area_entered(area):
	emit_signal("interact_ui_requested")

func _on_actionable_finder_area_exited(area):
	emit_signal("interact_ui_revoked")
