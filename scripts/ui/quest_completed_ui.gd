extends Control

var color_rect : ColorRect
var label : Label
var timer : Timer

func _ready():
	Global.quest_handler.quest_completed.connect(_on_quest_completed)
	color_rect = $ColorRect
	label = $ColorRect/Label
	timer = $Timer
	
func _on_quest_completed(quest_title: String):
	label.text = "Quest \"" + quest_title + "\" completata!" 
	visible = true
	timer.start()

func _on_timer_timeout():
	visible = false
