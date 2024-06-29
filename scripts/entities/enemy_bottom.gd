extends Node2D

var bullet_bottom_scene = preload("res://scenes/entities/bullet_bottom.tscn")
var bullet_interval = 0.5
var time_since_last_shot = 0.0
var speed = 800
var moving_right = true
var bullet_b: Node2D
var battle_on = Global.battle_on

func _ready():
	Global.connect("stop_battle", Callable(self, "_on_stop_battle"))
	#if not battle_on:
		#get_parent().get_node("Flag").visible = false
		#get_parent().get_node("Flag").set_collision_layer(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if battle_on:
		time_since_last_shot += delta
		if moving_right:
			position.x += speed * delta
			if position.x >= 1895:
				moving_right = false
		elif not moving_right:
			position.x -= speed * delta
			if position.x <= 183:
				moving_right = true
		if time_since_last_shot >= bullet_interval:
			fire_bullet()
			time_since_last_shot = 0.0

func fire_bullet():
	bullet_b = bullet_bottom_scene.instantiate()
	bullet_b.position = self.position
	get_parent().add_child(bullet_b)

func _on_stop_battle():
	bullet_b.free()
	battle_on = false 
