extends Node2D

var explosion = false
var speed = 70


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.y += 3


func _on_area_2d_area_entered(area):
	$AnimatedSprite2D.play("bullet_explosion")
	explosion = true


func _on_area_2d_body_entered(body):
	if  not explosion:
		if body.has_signal("map_requested"):
			$AnimatedSprite2D.play("bullet_explosion")
			if body.position.y > -2:
				body.position.y -= speed
