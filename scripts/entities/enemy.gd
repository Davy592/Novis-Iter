extends Node2D

var bullet_scene = preload("res://scenes/entities/bullet.tscn")
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
	var bullet = bullet_scene.instantiate()
	bullet.position = self.position
	bullet.rotation = self.rotation
	get_parent().add_child(bullet)
