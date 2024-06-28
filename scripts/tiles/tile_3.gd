extends Node2D

var creature = false
var path_together = false
var path_different = false
var tile3_creature_scene = preload("res://scenes/entities/tile_3_creature.tscn")
var creature_node: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialogic_signal(argument:String):
	if argument == "together":
		creature = true
		Dialogic.VAR.creature_action = true
		Dialogic.VAR.quest = true
		Dialogic.VAR.husband = false
		creature_node = tile3_creature_scene.instantiate()
		creature_node.position.x = 730
		creature_node.position.y = 988
		get_parent().add_child(creature_node)
	if argument == "death":
		creature_node.rotation_degrees = -90
	if argument == "path_together":
		$Timer1.start()
		path_together = true
		Dialogic.VAR.creature_action = false
	if argument == "path_different":
		$Timer1.start()
		$Timer2.start()
		path_different = true
		Dialogic.VAR.creature_action = false


func _on_timer_1_timeout():
	if path_together:
		$grisby.visible = false
		#remy visibilità
	if path_different:
		pass
		#remy visivilità


func _on_timer_2_timeout():
	$grisby.visible = false
