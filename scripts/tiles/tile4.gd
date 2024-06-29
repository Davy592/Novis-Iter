extends Node2D

var mountain_teleport : Node2D = null

func _process(delta):
	check_ludo_stage()

func check_ludo_stage():
	var stage: int = Global.quest_handler.get_current_stage(41.0)
	
	if stage == 10:
		if mountain_teleport == null:
			mountain_teleport = get_node('Teleports/WrongTeleport').duplicate()
			mountain_teleport.name = 'MountainTeleport'
			mountain_teleport.position = Vector2(3647.0, 833.0)
			mountain_teleport.destination = Vector2(7052.0, 294.0)
			
			get_node('Teleports').add_child(mountain_teleport)
	elif stage == 90:
		var platforms = get_node('Platforms').get_children()
		
		for platform in platforms:
			if platform is InvisibilePlatform:
				var sprite = platform.get_node("Sprite2D")
				
				sprite.modulate = Color(1, 1, 1, 1)
				platform.stop_animation = true
		
		Global.quest_handler.set_current_stage(41.0, 92.0)
	elif stage == 92:
		if Global.inventory.count_by_id("1N")>0 or Global.inventory.count_by_id("2X")>0 or Global.inventory.count_by_id("3P")>0:
			Global.quest_handler.set_current_stage(41.0, 95.0)
	elif stage == 96:
		var ludo = get_node('NPC/Ludo')
		ludo.quest.reward_item = ludo.quest.init_item("res://resources/data/items/song_in_a_glass.json", 1)
		Global.quest_handler.set_current_stage(41.0, 100.0)
	elif stage == 100:
		if has_node('NPC/Ludo'):
			var npc_node = get_node('NPC')
			npc_node.remove_child(get_node('NPC/Ludo'))
