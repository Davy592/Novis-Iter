extends CharacterBody2D

const JUMP_VELOCITY = -400.0
var player_position
var target_position
var MAX_SPEED = 600
var ACCELERATION = 150
var DECELERATION = 0.2
@export var player = get_parent().get_node("Player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func movement():
	pass
	

func _on_dialogic_signal(argument:String):
	if argument == "follower":
		print("Something was activated!")
		movement()
		


func _on_timer_timeout():
	pass # Replace with function body.
