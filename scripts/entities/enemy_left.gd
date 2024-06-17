extends Node2D

var bullet_left_scene = preload("res://scenes/entities/bullet_left.tscn")
var bullet_interval = 0.5
var time_since_last_shot = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shot += delta
	if time_since_last_shot >= bullet_interval:
		fire_bullet()
		time_since_last_shot = 0.0

func fire_bullet():
	var bullet_l = bullet_left_scene.instantiate()
	bullet_l.position = self.position
	get_parent().add_child(bullet_l)


