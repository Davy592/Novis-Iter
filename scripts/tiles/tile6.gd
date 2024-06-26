extends Node2D

var negative_actions = 0
var max_neg_actions = 4
var done_dialogues = []
var minigame_is_active = false
var player_discovered = false

@onready var path2d = $Path2D
@onready var path_follow = $Path2D/PathFollow2D

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Global.dialogue_manager.all_dialogues_ended.connect(_on_all_dialogues_ended)
	path_follow.get_node('BirdCreature/Direction').body_entered.connect(_on_area_2d_body_entered)

func _process(delta):
	if minigame_is_active:
		check_minigame_quests()

func check_minigame_quests():
	var npc_position = path2d.get_position_at_progress(path_follow.progress)
	if 'res://timelines/tile6/bird_see_no_fish.dtl' not in done_dialogues:
		if npc_position.distance_to(path2d.idle_points[3]) < 3.0 and not has_node('Fish'): # pesce rosso
			Global.dialogue_manager.start_dialogue('res://timelines/tile6/bird_see_no_fish.dtl')
			done_dialogues.append('res://timelines/tile6/bird_see_no_fish.dtl')
			increment_negative_actions()
	if 'res://timelines/tile6/bird_see_book.dtl' not in done_dialogues:
		if npc_position.distance_to(path2d.idle_points[5]) < 3.0 and Dialogic.VAR.tile6_book_written:
			Global.dialogue_manager.start_dialogue('res://timelines/tile6/bird_see_book.dtl')
			done_dialogues.append('res://timelines/tile6/bird_see_book.dtl')
			increment_negative_actions()
	if 'res://timelines/tile6/bird_drink_coffee_with_soap.dtl' not in done_dialogues:
		if npc_position.distance_to(path2d.idle_points[5]) < 3.0 and Dialogic.VAR.tile6_soap_in_coffee:
			Global.dialogue_manager.start_dialogue('res://timelines/tile6/bird_drink_coffee_with_soap.dtl')
			done_dialogues.append('res://timelines/tile6/bird_drink_coffee_with_soap.dtl')
			increment_negative_actions()

func increment_negative_actions():
	negative_actions += 1
	#print(negative_actions)
	if negative_actions == max_neg_actions:
		Global.dialogue_manager.start_dialogue('res://timelines/tile6/final_dialogue.dtl')

func _on_dialogic_signal(argument:String):
	if argument == "music":
		increment_negative_actions()
		remove_child(get_node('MusicAction'))
	elif argument == 'throw_fish':
		Global.inventory.remove_by_name('Pesce Rosso', 1)
	elif argument == 'soap':
		Global.inventory.remove_by_name('Saponetta', 1)
	elif argument == 'minigame':
		minigame_is_active = true
		get_parent().get_node("Player").position = Vector2(1024, 1522)
	elif argument == 'exit':
		minigame_is_active = false
		get_parent().get_node("Player").position = Vector2(1024, 2000)
		if has_node('Bird'):
			remove_child(get_node('Bird'))
			path2d.visible = true
			path2d.process_mode = Node.PROCESS_MODE_ALWAYS
	elif argument == 'talk_to_bird':
		path2d.visible = false
		path2d.process_mode = Node.PROCESS_MODE_DISABLED
		var bird = preload("res://scenes/entities/bird_creature.tscn").instantiate()
		bird.set_name('Bird')
		add_child(bird)
		bird.position = Vector2(1024, 1490)
		get_parent().get_node("Player").position = Vector2(1024, 1522)
		Global.dialogue_manager.start_dialogue('res://timelines/tile6/bird_quest_dialogue.dtl')

func remove_minigame():
	remove_child(get_node('Path2D'))
	remove_child(get_node('Kitchen'))
	remove_child(get_node('Studio'))
	remove_child(get_node('Bathroom'))
	remove_child(get_node('Lounge'))
	remove_child(get_node('ShowRoomArea'))
	remove_child(get_node('ShowRoomArea2'))
	remove_child(get_node('ShowRoomArea3'))
	remove_child(get_node('ShowRoomArea4'))
	#if has_node('Fish'):
		#remove_child(get_node('Fish'))
	Global.dialogue_manager.all_dialogues_ended.disconnect(_on_all_dialogues_ended)

func _on_area_2d_body_entered(body):
	if body.get_name() == 'Player' and minigame_is_active:
		Global.dialogue_manager.start_dialogue("res://timelines/tile6/bird_see_player.dtl")
		minigame_is_active = false
		player_discovered = true

func _on_all_dialogues_ended():
	if negative_actions == max_neg_actions:
		remove_minigame()
	elif player_discovered:
		get_parent().get_node("Player").position = Vector2(1024, 2000)
		player_discovered = false
