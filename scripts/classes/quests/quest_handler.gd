class_name QuestHandler

signal quest_completed(quest_title)

#region: Variables/Constants
const NO_ELEMENT_INDEX = -1

var quests_in_progress: Array[Quest] :
	set(new_quest_array): quests_in_progress = new_quest_array
	get: return quests_in_progress
var completed_quests: Array[Quest] :
	set(new_quest_array): completed_quests = new_quest_array
	get: return completed_quests
#endregion

func _init():
	quests_in_progress = []
	completed_quests = []

## Utile per verificare il completamento di una quest tra quelle presenti
func update_quests(item_name: String):
	var current_quest = null
	
	for i in range(0, quests_in_progress.size()):
		current_quest = quests_in_progress[i]
		current_quest.update(item_name)
		
		if current_quest.stage == 100 and !current_quest.is_completed:
			complete_quest(i)

func complete_quest(index: int):
	emit_signal("quest_completed", quests_in_progress[index].title)
	
	quests_in_progress[index].is_completed = true
	completed_quests.append(quests_in_progress[index])
	quests_in_progress.remove_at(index)
	
	Global.inventory.add(
		completed_quests.back().reward_item, 
		completed_quests.back().reward_item.quantity
	)
	
	if completed_quests.back() is ItemQuest:
		Global.inventory.remove_by_name(
			completed_quests.back().item_to_collect.name, 
			completed_quests.back().item_to_collect.quantity
		)

func set_current_stage(id: int, amount: int):
	var index: int = get_quest(id)

	if index != NO_ELEMENT_INDEX and quests_in_progress[index].stage < amount:
		Dialogic.VAR.current_stage = amount
		quests_in_progress[index].stage = amount

		if quests_in_progress[index].stage == 100:
			complete_quest(index)

func get_current_stage(id: int):
	var stage: int = 0
	var index: int = get_quest(id)
	
	if index != NO_ELEMENT_INDEX:
		stage = quests_in_progress[index].stage
	else: # Caso in cui la quest é stata completata
		index = get_completed_quest(id)
		if index != NO_ELEMENT_INDEX:
			stage = completed_quests[index].stage
	
	Dialogic.VAR.current_stage = stage
	Dialogic.VAR.scelta = false
	
	if stage > 0:
		Dialogic.VAR.scelta = true

#region: Search
func get_quest(id: int) -> int:
	for i in range(0, quests_in_progress.size()):
		if quests_in_progress[i].id == id:
			return i
	return -1

func get_completed_quest(id: int) -> int:
	for i in range(0, completed_quests.size()):
		if completed_quests[i].id == id:
			return i
	return -1
#endregion

#region: Utils
func add(quest: Quest): 
	if get_quest(quest.id) == NO_ELEMENT_INDEX:
		quests_in_progress.append(quest)
func add_completed(quest: Quest): 
	if get_completed_quest(quest.id) == NO_ELEMENT_INDEX:
		completed_quests.append(quest)
	
func remove(index: int):
	quests_in_progress.remove_at(index)
func remove_completed(index: int):
	completed_quests.remove_at(index)

func get_size():
	return quests_in_progress.size()
func get_size_completed():
	return completed_quests.size()
#endregion
