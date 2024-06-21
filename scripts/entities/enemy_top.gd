extends Node2D

var bullet_top_scene = preload("res://scenes/entities/bullet_top.tscn")
var bullet_interval = 0.5
var time_since_last_shot = 0.0
var speed = 500
var moving_right = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shot += delta
	if moving_right:
		position.x += speed * delta
		if position.x >= 1710:
			moving_right = false
	elif not moving_right:
		position.x -= speed * delta
		if position.x <= 29:
			moving_right = true
	
	if time_since_last_shot >= bullet_interval:
		fire_bullet()
		time_since_last_shot = 0.0

func fire_bullet():
	var bullet_t = bullet_top_scene.instantiate()
	bullet_t.position = self.position
	get_parent().add_child(bullet_t)

func _on_item_stop_battle():
	bullet_top_scene.queue_free()
