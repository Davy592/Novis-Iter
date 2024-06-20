extends Quest

class_name ItemQuest

var item_to_collect: Item:
	set(new_item): item_to_collect = new_item
	get: return item_to_collect
var collected_items: int:
	set(new_item): collected_items = new_item
	get: return collected_items

## Inizializza la quest (con super()) e 
func _init(data):
	super(data)
	
	# Aggiungi dati aggiuntivi per l'item da collezionare
	collected_items = 0
	item_to_collect = init_item(data['collect_item_file'], data['collect_item_quantity'])

func update():
	collected_items += 1
	
	if collected_items == item_to_collect.get_quantity():
		Global.quest_handler.set_current_stage(id, 100)
	else:
		Global.quest_handler.set_current_stage(id, stage + 10)
