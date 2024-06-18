extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.y += 1


func _on_area_2d_area_entered(area):
	$AnimatedSprite2D.play("bullet_explosion")
