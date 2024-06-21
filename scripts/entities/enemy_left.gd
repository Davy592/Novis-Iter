extends Node2D

var bullet_left_scene = preload("res://scenes/entities/bullet_left.tscn")
var bullet_interval = 0.5
var time_since_last_shot = 0.0
var speed = 500
var moving_top = true
var item_script

func _ready():
	var script_path = "res://scripts/classes/item.gd"
	var script_resource = load(script_path)
	script_resource.connect("stop_battle", Callable(self, "_on_item_stop_battle"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shot += delta
	if moving_top:
		position.y -= speed * delta
		if position.y <= 15:
			moving_top = false
	else:
		position.y += speed * delta
		if position.y >= 1029:
			moving_top = true
	if time_since_last_shot >= bullet_interval:
		fire_bullet()
		time_since_last_shot = 0.0

func fire_bullet():
	var bullet_l = bullet_left_scene.instantiate()
	bullet_l.position = self.position
	get_parent().add_child(bullet_l)

func _on_item_stop_battle():
	bullet_left_scene.queue_free()


