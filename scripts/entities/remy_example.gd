extends CharacterBody2D


var ACCELERATION = 150
@export var target_character: CharacterBody2D
@onready var navigation_agent = $NavigationAgent2D
var move = false
var tile3 = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _physics_process(delta):
	if move and not tile3:
		var distance_to_target = target_character.position.distance_to(position)
		set_movement_target(target_character.global_position)
		if navigation_agent.is_navigation_finished() or distance_to_target < 100:
			return
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * ACCELERATION * 2
		velocity = new_velocity  
		move_and_slide() 
		handle_animation(velocity)
		

func handle_animation(velocity: Vector2):
	if velocity.length_squared() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				$AnimatedSprite2D.play("right_walk")
			else:
				$AnimatedSprite2D.play("left_walk")
		else:
			if velocity.y > 0:
				$AnimatedSprite2D.play("front_walk")
			else:
				$AnimatedSprite2D.play("back_walk")
	else:
		$AnimatedSprite2D.play("front_idle")

func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

func _on_dialogic_signal(argument:String):
	if argument == "follower":
		move = true
		$Timer.start()
		$CollisionShape2D.disabled = true
		Dialogic.VAR.remy = true
	if argument == "together":
		move = false
		tile3 = true
		$CollisionShape2D.disabled = true
		$AnimatedSprite2D.play("front_walk")
		_on_timer_timeout()


func _on_timer_timeout():
	move = false
	$CollisionShape2D.disabled = false
	Dialogic.VAR.remy = false
