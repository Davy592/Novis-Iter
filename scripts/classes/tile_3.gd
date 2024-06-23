extends Node2D

var creature = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if creature:
		const speed = 100
		$Path2D/PathFollow2D.progress += speed*delta

func _on_dialogic_signal(argument:String):
	if argument == "together":
		creature = true
		$tile3_creature.visible = true
		Dialogic.VAR.creature_action = true
