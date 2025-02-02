extends CharacterBody2D


var ACCELERATION = 290
@onready var navigation_agent = $NavigationAgent2D
var move = false
var path_together = false
var path_different = false
var dialogue_player = true
var start_quest = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _physics_process(delta):
	#print("z: " + str(z_index))
	#print("coll: " + str(collision_layer))
	#print("mask: " + str(collision_mask))
	#print("visi: " + str(visible))
	if move:
		var target_character = Global.player
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
		var target_character = null
		global_position.y += 1
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
	if start_quest:
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
			start_quest = false
		

func handle_animation(velocity: Vector2):
	if velocity.length_squared() > 0:
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
		if $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.stop()
		if $AnimatedSprite2D.animation != "front_idle":
			$AnimatedSprite2D.play("front_idle")

func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

func _on_dialogic_signal(argument: Variant):
	if argument is String:
		if argument == "follower":
			move = true
			Global.remy_follow = true
			$Timer.start()
			#$CollisionShape2D.disabled = false #true
			set_collision_layer(0)
			Dialogic.VAR.remy = true
			$DialogueActionable.set_collision_layer(8)
			$DialogueActionable.set_collision_layer(8)
		if argument == "together":
			Global.remy_follow = false
			start_quest = true
			move = false
			dialogue_player = false
			#$CollisionShape2D.disabled = false
			set_collision_layer(0)
			$DialogueActionable.set_collision_layer(8)
			$DialogueActionable.set_collision_layer(8)
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
	if Global.tile_name != "res://scenes/tiles/tile_3.tscn":
		Global.remy_follow = false
		move = false
		#$CollisionShape2D.disabled = false
		#print("arrivo")
		set_collision_layer(Global.player.get_collision_layer())
		$DialogueActionable.set_collision_layer(2)
		$DialogueActionable.set_collision_layer(2)
		#print("fatto")
		Dialogic.VAR.remy = false
		if not dialogue_player:
			Dialogic.VAR.remy = true
	else:
		$Timer.start()
