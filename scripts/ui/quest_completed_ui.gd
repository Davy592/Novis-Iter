extends Control

var color_rect : ColorRect
var timer : Timer

func _ready():
	Global.quest_handler.quest_completed.connect(_on_quest_completed)
	color_rect = $ColorRect
	timer = $Timer
	
func _on_quest_completed(quest_title: String):
	visible = true
	timer.start()

func _on_timer_timeout():
	visible = false
