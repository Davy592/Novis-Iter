extends Node2D

var creature = false
var path_together = false
var path_different = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dialogic_signal(argument:String):
	if argument == "together":
		creature = true
		$tile3_creature.visible = true
		Dialogic.VAR.creature_action = true
		Dialogic.VAR.quest = true
		Dialogic.VAR.husband = false
	if argument == "death":
		$tile3_creature.rotation_degrees = -90
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
		$remy_example.visible = false
	if path_different:
		$remy_example.visible = false


func _on_timer_2_timeout():
	$grisby.visible = false
