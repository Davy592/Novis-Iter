extends Area2D

var remy: Node2D

@export var destination: Vector2 = Vector2(0, 0):
	set(new_destination): destination = new_destination
	get: return destination
	
## Used to set the camera limits of the location where the player will teleport.
## The values ​​must be set in this way:
## x = top, y = right, z = bottom, w = left
@export var destination_camera_limits: Vector4 = Vector4(0, 0, 0, 0):
	set(new_camera_limits): destination_camera_limits = new_camera_limits
	get: return destination_camera_limits

func _ready():
	set_process(false)

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		var main_node = get_tree().get_root().get_node('Main')
		var player = main_node.get_node('Player')
		if Global.remy_follow:
			remy = main_node.get_node('remy')
		
		Global.set_camera_limits(
			player,
			destination_camera_limits.x,
			destination_camera_limits.y,
			destination_camera_limits.z,
			destination_camera_limits.w
		)
		body.position = destination
		if Global.remy_follow:
			remy.position = body.position
