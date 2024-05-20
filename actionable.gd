extends Area2D

signal action_is_ended

func action() -> void:
	print('Action Executed!')
	# Esempio di azione
	Dialogic.start('res://timelines/prova.dtl')
	emit_signal("action_is_ended")
