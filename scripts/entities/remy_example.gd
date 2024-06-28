extends CharacterBody2D


var ACCELERATION = 150
@export var target_character: CharacterBody2D
@onready var navigation_agent = $NavigationAgent2D
var move = false
var tile3 = false
var path_together = false
var path_different = false
var dialogue_player = true


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if tile3:
		global_position.x = 1365
		global_position.y = 410

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
	if path_together or path_different:
		global_position.y += 1
	if tile3:
		if global_position.y < 600:
			$AnimatedSprite2D.play("front_walk")
			global_position.y += 1
		elif global_position.y >= 600 and global_position.x > 925:
				$AnimatedSprite2D.play("left_walk")
				global_position.x -= 1
		elif global_position.x <= 925 and global_position.y < 965:
				$AnimatedSprite2D.play("front_walk")
				global_position.y += 1
		elif global_position.y >= 965 and global_position.x > 805:
				$AnimatedSprite2D.play("left_walk")
				global_position.x -= 1
		elif global_position.x <= 805:
				$AnimatedSprite2D.stop()
				$AnimatedSprite2D.play("front_idle")
				tile3 = false
		

func handle_animation(velocity: Vector2):
	if velocity.length_squared() > 0:
		print("Moving with velocity: ", velocity)  # Debug print
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				if $AnimatedSprite2D.animation != "right_walk":
					$AnimatedSprite2D.play("right_walk")
			else:
				if $AnimatedSprite2D.animation != "left_walk":
					$AnimatedSprite2D.play("left_walk")
		else:
			if velocity.y > 0:
				if $AnimatedSprite2D.animation != "front_walk":
					$AnimatedSprite2D.play("front_walk")
			else:
				if $AnimatedSprite2D.animation != "back_walk":
					$AnimatedSprite2D.play("back_walk")
	else:
		print("Stopping animation")  # Debug print
		if $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.stop()
		if $AnimatedSprite2D.animation != "front_idle":
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
		dialogue_player = false
		$CollisionShape2D.disabled = true
		_on_timer_timeout()
	if argument == "shoot":
		$AnimatedSprite2D.play("left_shoot_idle")
	if argument == "death":
		$AnimatedSprite2D.play("left_shoot")
	if argument == "path_together":
		path_together = true
		$AnimatedSprite2D.play("front_walk")
	if argument == "stop_shooting":
		$AnimatedSprite2D.play("front_idle")
	if argument == "path_different":
		$AnimatedSprite2D.play("front_walk")
		path_different = true


func _on_timer_timeout():
	move = false
	$CollisionShape2D.disabled = false
	Dialogic.VAR.remy = false
	if not dialogue_player:
		Dialogic.VAR.remy = true
