extends CharacterBody2D

var speed = 150
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var path_together = false
var path_different = false
var start_quest = false

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _physics_process(delta):
	if start_quest:
		if global_position.y < 600:
			$AnimatedSprite2D.play("front_walk")
			global_position.y += 1
		if global_position.y == 600:
			$AnimatedSprite2D.play("left_walk")
			global_position.x -= 1
		if global_position.x == 925:
			$AnimatedSprite2D.play("front_walk")
			global_position.y += 1
		if global_position.y == 965:
			$AnimatedSprite2D.play("left_walk")
			global_position.x -= 1
		if global_position.x <= 775:
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.play("front_idle")
			start_quest = false
	if path_together:
		global_position.y += 1
	if path_different:
		if global_position.y > 600:
			$AnimatedSprite2D.play("back_walk")
			global_position.y -= 1
		if global_position.y <= 600:
			$AnimatedSprite2D.play("right_walk")
			global_position.x += 1

func old_move():
	pass

func _on_dialogic_signal(argument:String):
	if argument == "together":
		$CollisionShape2D.disabled = true
		$AnimatedSprite2D.play("front_walk")
		start_quest = true
	if argument == "hurt":
		global_position.x += speed
	if argument == "path_together":
		path_together = true
	if argument == "path_different":
		path_different = true


