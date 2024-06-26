extends Path2D

var speed = 600
var old_progress
var idle_points = []
var is_time_out = true
var move = 'idle'
var direction = 'front'
@onready var timer = $Timer
@onready var npc = $PathFollow2D/BirdCreature
@onready var sight_direction = npc.get_node('Direction')
@onready var anim = npc.get_node('AnimatedSprite2D')
@onready var path_follow_2d = $PathFollow2D
@export var idle_index_points = []
@export var idle_time: int = 2.0

func _ready():
	old_progress = path_follow_2d.progress
	for index in idle_index_points:
		idle_points.append(curve.get_point_position(index))

func get_position_at_progress(progress: float) -> Vector2:
	return curve.sample_baked(progress)

func _process(delta):
	if is_time_out and Global.dialogue_manager.are_all_dialogues_ended():
		update_position(delta)
	else:
		move = 'idle'
	anim.play(move + "_" + direction)

func update_position(delta):
	
	var angle = 0
	var current_position = get_position_at_progress(path_follow_2d.progress)
	var new_position = get_position_at_progress(path_follow_2d.progress + speed * delta)
	var velocity = new_position - current_position
	
	if velocity.x > 0:
		direction = 'right'
		angle = -90
	else:
		direction = 'left'
		angle = 90
	if velocity.y > 0:
		direction = 'front'
		angle = 0
	elif velocity.y < 0:
		direction = 'back'
		angle = 180

	var collision = npc.move_and_collide(velocity, true)
	if not collision:
		# ATTENZIONE: con il PathFollow2D è la posizione del PathFollow2D che viene cambiata
		# e non quella dell'npc. La posizione dell'npc si riferisce a quella relativa al nodo PathFollow2d
		# e pertanto la posizione dell'npc sarà sempre a 0,0 relativamente al PathFollow2D dato che è suo figlio
		#print(npc.position)
		#npc.position = new_position
		sight_direction.rotation_degrees = angle
		path_follow_2d.progress += speed * delta
		move = 'walk'
		old_progress = path_follow_2d.progress
	else:
		move = 'idle'

	for i in range(idle_points.size()):
		if new_position.distance_to(idle_points[i]) < 2.0:
			move = 'idle'
			timer.start(idle_time)
			is_time_out = false
			break

func _on_timer_timeout():
	is_time_out = true
