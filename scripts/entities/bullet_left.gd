extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x += 1



func _on_area_2d_area_entered(area):
	$AnimatedSprite2D.play("bullet_explosion")
