extends Control

var color_rect : ColorRect
var label : Label
var timer : Timer

func _ready():
	color_rect = $ColorRect
	label = $ColorRect/Label
	timer = $Timer
	
	Global.quest_handler.quest_started.connect(_on_quest_started)
	Global.quest_handler.quest_completed.connect(_on_quest_completed)

func _on_quest_started(quest_title: String):
	label.text = "Quest \"" + quest_title + "\"\n iniziata!" 
	visible = true
	timer.start()

func _on_quest_completed(quest_title: String):
	label.text = "Quest \"" + quest_title + "\"\n completata!" 
	visible = true
	timer.start()

func _on_timer_timeout():
	visible = false
